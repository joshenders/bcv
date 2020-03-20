# Guide for deploying the BCV system

## How to use this guide

- This guide is intended for IT professionals who are deploying a locations-tracking system for Healthcare workers at their organization
- It assumes that one is (a) purchasing a domain from domains.google.com, (b) using AWS for their server. This may not always be the case (in which case certain steps can be skipped/modified)
- This guide uses _example_ DNS, IP address, passwords, ssh key files, etc. In a real deploy, these should be substituted.

## Services used

These are the components of the BCV suite:
- Device-side: Devices will use Traccar Client, and Android application downloadable via the [Google Play Store](https://play.google.com/store/apps/details?id=org.traccar.client) and the [Apple App Store](https://apps.apple.com/us/app/traccar-client/id843156974)
- Server-side: The server will run:
  - Traccar Server, downloadable from Traccar's [website](https://github.com/traccar/traccar/releases/download/v4.8/traccar-linux-64-4.8.zip)
  - A Shiny application for worker enrollment
  - MySQL database for management of worker identities and cases
  - Rmarkdown for generating reports

# Set up traccar

### On server

(Note: Much of this came from the [Tracar official documentation](https://www.traccar.org/documentation/))


#### Buy a domain

- Go to domains.google.com and buy a domain.
- For the purposes of this guide, the domain being used is `www.databrew.app`

#### Spin up an EC2 instance on AWS

- AMI: Ubuntu Server 18.04 LTS
- Instance type: t3.medium
- Configure instance:
  - All default except:
    - Auto-Assign Public IP: Enable
- Add Storage: (100gb)
- Add Tags: Skip
- Configure Security Group:
  - Create new: name it traccar
  - Type: All traffic
  - Source: Anywhere
- Launch
- Note, for this guide we'll use a local key called `odkkey.pem`


#### Allocate a persistent IP

- So that your AWS instance's public IP address does not change at reboot, etc., you need to create an "Elastic IP address". To do this:
  - Go to the EC2 dashboard in aws
  - Click "Elastic IPs" under "Network & Security" in the left-most menu
  - Click "Allocate new address"
  - Select "Amazon pool"
  - Click "Allocate"
  - In the allocation menu, click "Associate address"
  - Select the instance you just created. Also select the corresponding "Private IP"
  - Click "Associate"
- Note, this guide is written with the below elastic id. You'll need to replace this with your own when necessary.

```
3.130.255.155
```

- Go to instances menu
- Name the newly spun-up server "databrew.app (traccar)"


#### Setting up the domain

- In domains.google.com, click on the purchased domain.
- Click on "DNS" on the left
- Go to "Custom resource records"
- You're going to create two records:
  1. Name: @; Type: A; TTL 1h; Data: 3.130.255.155
  2. Name: www; Type: CNAME; TTL: 1h; Data: ec2-3-130-255-155.us-east-2.compute.amazonaws.com.us-east-2.compute.amazonaws.com.
- Note, you'll need to replace the above DNS/IP for your specific site.


#### Connect to the server

- In the “Instances” menu, click on “Connect” in the upper left
- This will give instructions for connecting via an SSH client
- It will be something very similar to the following:

```
ssh -i ~/.ssh/odkkey.pem ubuntu@ec2-3-130-255-155.us-east-2.compute.amazonaws.com
```

#### Install / configure dependencies

```
sudo apt-get update
sudo apt-get install openjdk-8-jdk-headless
sudo apt-get install zip
sudo apt-get install unzip
sudo apt-get install wget
sudo apt-get install curl
sudo apt-get -y update
sudo apt-get install nginx
sudo apt-get install software-properties-common
sudo apt install mysql-server
```


#### Setting up java

- Java is already installed, but you need to set the `JAVA_HOME` environment variable. To do so:
- `sudo nano /etc/environment`
- Add line like `JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"`
- Run `source /etc/environment`

#### Installing Traccar

- Install the zip file [here](https://github.com/traccar/traccar/releases/download/v4.8/traccar-linux-64-4.8.zip) by running:
```
mkdir traccar
cd traccar
wget https://github.com/traccar/traccar/releases/download/v4.8/traccar-linux-64-4.8.zip
```
- Extract the contents:
```
unzip traccar-linux-64-4.8.zip
```
- Run the executable:
```
sudo ./traccar.run
```
- Start the service:
```
sudo systemctl start traccar.service
```
- Open web interface by navigating to http://localhost:8082/ (on local machine) or databrew.app (if you have already configured the below) or databrew.app:8082
- Log in as `admin` / `admin`


### Setting up https

Please pay special attention to the use of DNS, IP addresses, and emails in this section. You'll need to change for your specific system.

```
sudo apt install nginx
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx
sudo certbot run --nginx --non-interactive --agree-tos -m joebrew@gmail.com --redirect -d databrew.app
```

#### Deal with ports, nginx, etc.

- Run the below:
```
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/databrew.app
sudo nano /etc/nginx/sites-available/databrew.app
```
- Make it as follows:

```
# redirect from http to https for databrew.app
server {
  listen 80;
  listen [::]:80;
   server_name databrew.app www.databrew.app;
   return 301 https://$server_name$request_uri;
}

server {
   listen 443 ssl;
   server_name databrew.app www.databrew.app;
   ssl_certificate /etc/letsencrypt/live/databrew.app/fullchain.pem;
   ssl_certificate_key /etc/letsencrypt/live/databrew.app/privkey.pem;
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
   ssl_prefer_server_ciphers on;
   ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;


   # anything that does not match the above location blocks (if there are any)
   # will get directed to 3838
      location / {
          proxy_pass http://127.0.0.1:8082/;
          proxy_redirect http://127.0.0.1:8082/ https://$host/;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_read_timeout 20d;
      }
   }
```

- Make a symlink as per below:
```
sudo ln -s /etc/nginx/sites-available/databrew.app /etc/nginx/sites-enabled/
```
- Edit a file: `sudo nano /etc/nginx/nginx.conf` and remove the `#` before `server_names_hash_bucket_size 64;`
- Remove the default nginx file: `sudo rm /etc/nginx/sites-enabled/default`
- Check to make sure there are no syntax errors:
```
sudo nginx -t
```
- Restart:
```
sudo systemctl restart nginx
sudo nginx -s reload
sudo systemctl start traccar.service
```

#### Set up mysql database for traccar

- This is the database the traccar server application will use
-Again, pay special attention to the use of passwords and usernames. You'll need to change for your system.

```
sudo mysql
CREATE USER 'traccaruser'@'localhost' IDENTIFIED BY 'traccarpass';
GRANT ALL PRIVILEGES ON * . * TO 'traccaruser'@'localhost';
FLUSH PRIVILEGES;
ctrl + d
mysql -u traccaruser -p
<enter password>
CREATE DATABASE traccardb;
```

#### Set up mysql database for worker IDS

- This is the database we'll use for managing worker IDs

```
sudo mysql
CREATE USER 'bcvuser'@'localhost' IDENTIFIED BY 'bcvpass';
GRANT ALL PRIVILEGES ON * . * TO 'bcvuser'@'localhost';
FLUSH PRIVILEGES;
ctrl + d
mysql -u bcvuser -p
<enter password>
CREATE DATABASE bcvdb;
```

#### Configure Traccar for MySQL

- Edit the [configuration file](https://www.traccar.org/configuration-file/) by running:
```
sudo nano /opt/traccar/conf/traccar.xml
```

Replace the below lines:

```
<entry key='database.driver'>org.h2.Driver</entry>
<entry key='database.url'>jdbc:h2:/home/user/Documents/traccar/target/database</entry>
<entry key='database.user'>sa</entry>
<entry key='database.password'></entry>
```
With:
```
<entry key='database.driver'>com.mysql.jdbc.Driver</entry>
<entry key='database.url'>jdbc:mysql://3.130.255.155:3306/traccardb?serverTimezone=UTC&amp;useSSL=false&amp;allowMultiQueries=true&amp;autoReconnect=true&amp;useUnicode=yes&amp;characterEncoding=UTF-8&amp;sessionVariables=sql_mode=''</entry>
<entry key='database.user'>traccaruser</entry>
<entry key='database.password'>traccarpass</entry>
```

- Note in the above that the `3.130.255.155` is the server IP.

- Also, add some filtering to ensure that we don't capture too much jumpiness:
```
<entry key='distance.enable'>true</entry>

<entry key='filter.enable'>true</entry>
<entry key='filter.distance'>40</entry>
<entry key='filter.maxSpeed'>25000</entry>
<entry key='filter.invalid'>true</entry>
<entry key='filter.accuracy'>40</entry>
<entry key='filter.duplicate'>true</entry>
<entry key='filter.skipLimit'>1800</entry>
<entry key='filter.future'>600</entry>
<entry key='filter.zero'>true</entry>

<entry key='report.trip.minimalTripDuration'>250</entry>
<entry key='report.trip.minimalTripDistance'>100</entry>
<entry key='report.trip.minimalParkingDuration'>300</entry>
<entry key='database.positionsHistoryDays'>60</entry>

```

#### Optimize MySQL

```
sudo nano /etc/mysql/mysql.conf.d/custom.cnf
```
- Add the following lines (adjusting the first line so that it is less than 75% of total memory)

```
[mysqld]
innodb_buffer_pool_size = 2G
innodb_log_file_size = 512M
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 0
```

- Restart stuff:
```
sudo systemctl stop traccar
sudo systemctl restart mysql
sudo systemctl start traccar
sudo systemctl daemon-reload
sudo systemctl start traccar.service

```

#### Allow for remote access to database


```
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```
- Comment out this line
```
bind-address            = 127.0.0.1
```

- Restart mysql:
```
sudo systemctl restart mysql
```
- Create remote user and grant privileges (again, change user/pass as appropriate for your system)
```
sudo mysql
CREATE USER 'traccarremoteuser'@'%' IDENTIFIED BY 'traccarremotepass';
CREATE USER 'traccaruser'@'%' IDENTIFIED BY 'traccarpass';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON traccardb.* TO 'traccarremoteuser'@'%';
GRANT ALL PRIVILEGES ON traccardb.* TO 'traccaruser'@'%';
FLUSH PRIVILEGES;
<ctrl +d>
```

- And for the worker enrollment database

```
sudo mysql
CREATE USER 'bcvremoteuser'@'%' IDENTIFIED BY 'bcvremotepass';
CREATE USER 'bcvuser'@'%' IDENTIFIED BY 'bcvpass';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON bcvdb.* TO 'bcvremoteuser'@'%';
GRANT ALL PRIVILEGES ON bcvdb.* TO 'bcvuser'@'%';
FLUSH PRIVILEGES;
<ctrl +d>
```



- Restart stuff:
```
sudo systemctl stop traccar
sudo systemctl restart mysql
sudo systemctl start traccar
```
- Test the remote connection (from another box):
```
mysql -h 3.130.255.155 -u traccarremoteuser -p
<traccarremotepass>
```

# Set up of shiny app

- We will run a web application on a separate server for both
  - A. Enrolling workers
  - B. Reporting cases
- As with the above, we assume you are using AWS and are purchasing a domain from domains. google.com. This may not be your case.
- In addition, you'll need to replace DNS, IP, keyfile path, and email addresses as appropriate for your case.

## EC2 instance

- Spin up a Ubuntu Server 18.04 LTS (HVM), SSD server
- Instance type: medium
- Configuration
  - Defaults except:
  - Network: use the aggregate-vpc group (see ODK set up guide for details)
  - Auto-assign Public IP: Enable
  - IAM role: aggregate role
- Storage: 100gb
- Tags: none
- Security group: vpc-aggregate group
- Associate the purchased datacat.cc domain with the IP (elastic IP)

## Set up an alias

- Add the following to the end of `~/.bashrc`

```
alias shiny='ssh -i "/home/joebrew/.ssh/odkkey.pem" ubuntu@datacat.cc'
```
- SSH into the server: `shiny`

## Installing R and associated dependencies

```
sudo apt-get update && sudo apt-get upgrade
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
sudo apt update
sudo apt install r-base


sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libxml2-dev
sudo apt install default-jdk
export LD_LIBRARY_PATH=/usr/lib/jvm/java-11-openjdk-amd64/lib/server
sudo R CMD javareconf
```

## Configure R

Change R package directory from user-based to system-wide:
```
sudo nano /usr/lib/R/etc/Renviron
```
Your Renviron file should look like this when you’re done (ie, you'll need to comment out the top line and uncomment the latter)
```
#R_LIBS_USER=${R_LIBS_USER-‘~/R/x86_64-pc-linux-gnu-library/3.0’}
R_LIBS_USER=${R_LIBS_USER-‘~/Library/R/3.0/library’}
```

Check lib paths in R to make sure your package library changed correctly.
R
`.libPaths()`

`/usr/local/lib/R/site-library` should be the first of the library paths.


Make your new package lib readable for Shiny Server.
```
sudo chmod 777 /usr/lib/R/site-library
```


### Install shiny

```
sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
```

### Install shiny server

```
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.5.872-amd64.deb
md5sum shiny-server-1.5.5.872-amd64.deb
sudo apt-get update
sudo apt-get install gdebi-core
sudo gdebi shiny-server-1.5.5.872-amd64.deb
# Check that it's running on port 3838
sudo netstat -plunt | grep -i shiny
sudo ufw allow 3838
```

### Setting up https

```
sudo apt install nginx
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx
sudo certbot run --nginx --non-interactive --agree-tos -m joebrew@gmail.com --redirect -d datacat.cc
sudo certbot run --nginx --non-interactive --agree-tos -m joebrew@gmail.com --redirect -d datacat.cc
```

### Set up proxy, certificate, etc.

```
sudo nano /etc/nginx/nginx.conf
```

Copy the following into the http block of /etc/nginx/nginx.conf

```
http {
    ...
    # Map proxy settings for RStudio
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }
}
```

Now create a new block

```
sudo nano /etc/nginx/sites-available/datacat.cc
```

In /etc/nginx/sites-available/datacat.cc, add the following:

```
# redirect from http to https for datacat.cc
server {
  listen 80;
  listen [::]:80;
   server_name datacat.cc www.datacat.cc;
   return 301 https://$server_name$request_uri;
}

server {
   listen 443 ssl;
   server_name datacat.cc www.datacat.cc;
   ssl_certificate /etc/letsencrypt/live/datacat.cc/fullchain.pem;
   ssl_certificate_key /etc/letsencrypt/live/datacat.cc/privkey.pem;
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
   ssl_prefer_server_ciphers on;
   ssl_ciphers AES256+EECDH:AES256+EDH:!aNULL;


# anything that does not match the above location blocks (if there are any)
# will get directed to 3838
   location / {
       proxy_pass http://18.218.87.64:3838/;
       proxy_redirect http://18.218.87.64:3838/ https://$host/;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection $connection_upgrade;
       proxy_read_timeout 20d;
   }
}
```

#### Enable the new block by creating a symlink

```
sudo ln -s /etc/nginx/sites-available/datacat.cc /etc/nginx/sites-enabled/
```

Disable the default block since our server now handles all incoming traffic
```
sudo rm -f /etc/nginx/sites-enabled/default
```

Test the config:
```
sudo nginx -t
```
Restart nginx
```
sudo systemctl restart nginx
```

### Install latex

- Run the below:

```
sudo su - -c "R -e \"install.packages('tinytex')\""
sudo su - -c "R -e \"tinytex::install_tinytex()\""
#sudo apt-get install texlive-latex-base
# sudo apt install texlive-xetex
sudo su - shiny
R -e 'tinytex::install_tinytex()'
```

- "Fool" apt-get into not installing more latex packages:
```
wget "https://travis-bin.yihui.org/texlive-local.deb"
sudo dpkg -i texlive-local.deb
rm texlive-local.deb
```



### Install more packages

- Install the following:
```
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
```
- Check that it worked at
https://datacat.cc/sample-apps/rmd/

- Intall some additional software:
```
sudo apt-get -y install \
    apache2-utils \
    pandoc \
    pandoc-citeproc \
    libssl-dev \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libxml2-dev \
    libxt-dev \
    libv8-dev
sudo apt-get update
sudo apt-get install libmagick++-dev
```

- Install some R packages

```
sudo add-apt-repository ppa:marutter/c2d4u3.5
sudo apt update
sudo apt install r-cran-dplyr
sudo su - -c "R -e \"install.packages('devtools')\"";
sudo su - -c "R -e \"install.packages('broom')\"";
sudo su - -c "R -e \"install.packages('broomExtra')\"";
sudo su - -c "R -e \"install.packages('dbplyr')\""
sudo su - -c "R -e \"install.packages('DBI')\"";
sudo su - -c "R -e \"install.packages('deldir')\"";
sudo su - -c "R -e \"install.packages('DescTools')\"";
sudo su - -c "R -e \"install.packages('dismo')\"";
sudo su - -c "R -e \"install.packages('dplyr')\"";
sudo su - -c "R -e \"install.packages('DT')\"";
sudo su - -c "R -e \"install.packages('DTedit')\"";
sudo su - -c "R -e \"install.packages('extrafont')\""
sudo su - -c "R -e \"install.packages('geosphere')\"";
sudo su - -c "R -e \"install.packages('gsheet')\""
sudo su - -c "R -e \"install.packages('ggplot2')\"";
sudo su - -c "R -e \"install.packages('ggmap')\""
sudo su - -c "R -e \"install.packages('ggthemes')\""
sudo su - -c "R -e \"install.packages('ggpubr')\"";
sudo su - -c "R -e \"install.packages('graphics')\"";
sudo su - -c "R -e \"install.packages('haven')\""
sudo su - -c "R -e \"install.packages('highcharter')\"";
sudo su - -c "R -e \"install.packages('Hmisc')\"";
sudo su - -c "R -e \"install.packages('htmltools')\"";
sudo su - -c "R -e \"install.packages('htmlwidgets')\"";
sudo su - -c "R -e \"install.packages('jqr')\"";
sudo su - -c "R -e \"install.packages('jsonlite')\"";
sudo su - -c "R -e \"install.packages('leaflet')\"";
sudo su - -c "R -e \"install.packages('leaflet.extras')\"";
sudo su - -c "R -e \"install.packages('lubridate')\""
sudo su - -c "R -e \"install.packages('maps')\""
sudo su - -c "R -e \"install.packages('maptools')\"";
sudo su - -c "R -e \"install.packages('MASS')\"";
sudo su - -c "R -e \"install.packages('methods')\"";
sudo su - -c "R -e \"install.packages('modelr')\""
sudo su - -c "R -e \"devtools::install_github('databrew/nd3')\"";
sudo su - -c "R -e \"install.packages('nlme')\"";
sudo su - -c "R -e \"install.packages('openxlsx')\"";
sudo su - -c "R -e \"install.packages('plotly')\"";
sudo su - -c "R -e \"install.packages('plyr')\"";
sudo su - -c "R -e \"install.packages('prettymapr')\"";
sudo su - -c "R -e \"install.packages('raster')\"";
sudo su - -c "R -e \"install.packages('rCharts')\"";
sudo su - -c "R -e \"install.packages('RCurl')\""
sudo su - -c "R -e \"install.packages('readr')\"";
sudo su - -c "R -e \"install.packages('readxl')\"";
sudo su - -c "R -e \"install.packages('rgeos')\"";
sudo su - -c "R -e \"install.packages('rmarkdown')\"";
sudo su - -c "R -e \"install.packages('RPostgres')\"";
sudo su - -c "R -e \"install.packages('RPostgreSQL')\""
sudo su - -c "R -e \"install.packages('rvest')\"";
sudo su - -c "R -e \"install.packages('scales')\""
sudo su - -c "R -e \"install.packages('sf')\"";
sudo su - -c "R -e \"install.packages('shiny')\"";
sudo su - -c "R -e \"install.packages('shinydashboard')\"";
sudo su - -c "R -e \"install.packages('shinyjqui')\"";
sudo su - -c "R -e \"install.packages('shinyjs')\"";
sudo su - -c "R -e \"install.packages('sp')\"";
sudo su - -c "R -e \"install.packages('spacetime')\"";
sudo su - -c "R -e \"install.packages('spacyr')\"";
sudo su - -c "R -e \"install.packages('survey')\"";
sudo su - -c "R -e \"install.packages('textclean')\"";
sudo su - -c "R -e \"install.packages('tibble')\"";
sudo su - -c "R -e \"install.packages('tidylog')\"";
sudo su - -c "R -e \"install.packages('tidyr')\"";
sudo su - -c "R -e \"install.packages('tidyverse')\""
sudo su - -c "R -e \"install.packages('units')\"";
sudo su - -c "R -e \"install.packages('V8')\"";
sudo su - -c "R -e \"install.packages('VGAM')\"";
sudo su - -c "R -e \"install.packages('xlsx')\"";
sudo su - -c "R -e \"install.packages('xtable')\"";
sudo su - -c "R -e \"install.packages('yaml')\"";
sudo su - -c "R -e \"devtools::install_github('rstudio/DT')\""
sudo su - -c "R -e \"install.packages('gpclib')\"";
sudo su - -c "R -e \"install.packages('qrcode')\"";
sudo su - -c "R -e \"install.packages('rgdal')\"";
sudo su - -c "R -e \"install.packages('kableExtra')\"";
sudo su - -c "R -e \"install.packages('googlesheets')\"";
sudo su - -c "R -e \"devtools::install_github('databrew/bohemia', subdir = 'rpackage/bohemia', dependencies = TRUE, force = TRUE)\""
sudo su - -c "R -e \"install.packages('shinydashboardPlus')\"";
sudo su - -c "R -e \"install.packages('shinyMobile')\"";
sudo su - -c "R -e \"devtools::install_github('aoles/shinyURL')\""
sudo su - -c "R -e \"install.packages('DBI')\"" ;
sudo su - -c "R -e \"install.packages('RMySQL')\"" ;
```

Test:
```
cd /srv/shiny-server
sudo git clone https://github.com/joebrew/minimal
sudo systemctl restart shiny-server
```

Now go to https://datacat.cc/minimal

- Set up permissions

```
sudo groupadd shiny-apps
sudo usermod -aG shiny-apps ubuntu
sudo usermod -aG shiny-apps shiny
cd /srv/shiny-server
sudo chown -R ubuntu:shiny-apps .
sudo chmod g+w .
sudo chmod g+s .
```

## Set up the shiny applicatio

- On the shiny server, run:
```
git clone https://github.com/databrew/bcv
```
- To deploy, go into the shiny server (separate documentation) (`shiny` alias) and run:
```
# only once
mkdir Documents
cd Documents
git clone https://github.com/databrew/bcv
cd bcv/shiny
Rscript set_up_database.R
cd ../..

cd ~/Documents/bcv;
git pull;
cd /srv/shiny-server;
rm -r bcv;
mkdir bcv;
cp ~/Documents/bcv/shiny/app.R bcv/app.R;
sudo chmod -R 777 bcv;
sudo systemctl restart shiny-server;

```

# Syncing between the shiny app and the traccar server

- This line of work is currenly in progress. Anticipated to be finished on Friday March 20th


### Data extraction

- The [API](https://www.traccar.org/api-reference/) should be used for data extraction

- Get a list of devices:
```
https://databrew.app/api/devices
```
etc.

- The database can be accessed directly:
```
mysql traccardb -u traccaruser -p
<traccarpass>
show tables;
select * from tc_positions;
```

- Remotely:

```
mysql -h 3.130.255.155 -u bcvuser -p
<bcvpass>
use bcvdb
```

- Additionally, we are actively developing tools for interfacing with the data at https://github.com/databrew/rtraccar

### Troubleshooting and logs
- See logs at `/opt/traccar/logs/tracker-server.log`
- See more details on the [troubleshooting page](https://www.traccar.org/troubleshooting/)


# Set up phones


Please visit the [GPS tracking phone page](phone_documentation.md) for details on configuring the HCWs' phones.
