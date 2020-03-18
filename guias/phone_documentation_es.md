[THIS PAGE IN ENGLISH](phone_documentation.md)


### 1. Registro

- Antes de instalar cualquier cosa, necesitamos saber quién es usted y si está participando.
- Por favor ve a [REGISTRATION PAGE](https://datacat.cc/bcv) y rellena el formulario
- Tome nota del número de identificación asignado. Deberá ponerlo en su teléfono (siguiente paso).

### 2. Instalación

- *ANDROID*: Instala Traccar client via [Google Play Store](https://play.google.com/store/apps/details?id=org.traccar.client)
- *APPLE*:Instala Traccar client via [Apple App Store](https://apps.apple.com/us/app/traccar-client/id843156974)

### 3. Configuración

- En el teléfono, asegúrese de que la ubicación (en configuración> privacidad) esté habilitada, Y que el método de localización sea lo más alto posible (GPS y Wi-Fi)
- Abra la aplicación Traccar
- Configure el Identificador de dispositivo en _your Identification number_ (consulte la sección "Registro" más arriba para obtener una ID de dispositivo)
- Establezca la dirección de la URL del servidor: `https://databrew.app`
- Establezca el campo Frecuencia a: `60`
- Establezca la precisión de la ubicación en: `high`
- No cambie los campos Distancia o Ángulos
- En la parte superior establezca "Estado del servicio" en on/running


### 4. Utilizar

- La aplicación Traccar debe estar ejecutándose ("Estado del servicio" activado) en todo momento durante las operaciones
- La aplicación se iniciará automáticamente al reiniciar el dispositivo
- Si por alguna razón la aplicación está apagada, vuelva a encenderla
- Hemos probado la aplicación en muchos dispositivos. En el intervalo de grabación de 60 segundos, solo tiene un efecto mínimo en la duración de la batería.
- Cuando el dispositivo está fuera de cobertura, las coordenadas GPS se almacenan localmente; Cuando se encuentra una conexión a Internet, las coordenadas GPS se envían al servidor.