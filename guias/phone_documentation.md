# GPS tracking

## Context

- You are a healthcare professional. Therefore, your risk of infection with COVID-19 is high.
- Collecting your location data serves two purposes:
  1. If one of your colleagues becomes ill, we will know if/when you had contact with them (and therefore, if you are at risk) and can therefore perform screening on you.
  2. If you yourself become ill, we will know who you might have infected, and can therefore perform screening.


## Steps

### Registration

- Before you install anything, we need to know who you are and that you are participating.
- Please go to datacat.cc/register and fill out the form
- Please take note of the ID number you are assigned. You will need to put this into your phone (next step).

### Installation

- *ANDROID*: Install Traccar client via the [Google Play Store](https://play.google.com/store/apps/details?id=org.traccar.client)
- *APPLE*:Install Traccar client via the [Apple App Store](https://apps.apple.com/us/app/traccar-client/id843156974)

### Configuration

- On the phone, make sure location (in settings > privacy) is enabled, AND that the locating method is as high as possible (GPS and Wi-Fi)
- Open the Traccar app
- Set the address of the server URL: `http://databrew.app`
- Set the Frequency field to: `60`
- Set location accuracy to: `high`
- Do not change the Distance or Angles fields
- At the top set "Service status" to on/running

### Use

- The Traccar app should be running ("Service status" set to on) at all times during operations
- The app will automatically initialize upon device reboot
- If for some reason the app is turned off, please turn it back on
- We have tested the app on many devices. At the 60 second recording interval, it has only minimal effect on battery life.
- When the device is offline, GPS coordinates are stored locally; when an internet connection is found, GPS coordinates are sent to the server.
