# BCV: Busca y Captura para el Virus (Search and arrest the virus)

_A tool for GPS tracking of healthcare workers so as to empower and automated epidemiological contact-tracing_

[THIS PAGE IN ENGLISH](README.md)


## Enlaces rápidos

- Para registrarse como participante: [REGISTRATION LINK](https://datacat.cc/bcv/)
- Instrucciones para configurar el teléfono después del registro: [PHONE INSTRUCTIONS](guias/phone_documentation_es.md)


## Visión general

Los trabajadores sanitarios tienen un riesgo especialmente alto de infección por COVID-19. Por extensión, sus contactos (incluidos los que viven con ellos, los que tratan, de los que compran, etc.) también tienen un alto riesgo de infección. Proteger los contactos de los trabajadores sanitarios es vital para apoyar su trabajo, así como para prevenir la transmisión de enfermedades de gran envergadura de los trabajadroes sanitarios a la sociedad. Realizaremos un seguimiento pasivo de las ubicaciones de los trabajadores sanitarios a través de un teléfono inteligente para que cuando un trabajador sanitario dé un resultado positivo, la investigación epidemiológica retrospectiva (seguimiento de contactos) pueda ser rápida, precisa y automatizada.


- La recopilación de datos de ubicación de trabajadores de la salud tiene dos propósitos:
  1. **Para proteger el personal sanitario**: Si uno de sus colegas se enferma, sabremos si/cuando el TS tuvo contacto con ellos (y por lo tanto, si el TS está en riesgo y requiere detección o confinamiento)
  2. **Para proteger los contactos de los TS**: Si usted mismo se enferma, sabremos a quién podría haber infectado y, por lo tanto, podemos realizar la detección.


## Pasos / Protocolo

- Se solicita a todos los trabajadores de la salud de una ubicación/distrito que instalen voluntariamente una aplicación simple para teléfonos móvil.
- La aplicación envía su ubicación GPS a un servidor seguro cada 60 segundos.
- Cuando un TS da positivo, el número de identificación del TS se marca como positivo.
- Una vez que un TS se marca como positivo, los siguientes 3 grupos en riesgo se identifican automáticamente y se generan informes automáticamente:
  - Grupo de riesgo geográfico: el servidor genera automáticamente un informe (con mapas) que describe el itinerario geográfico del TS durante su período hipotéticamente infeccioso. Esto sirve para identificar/detectar personas potencialmente infectadas por el TS (es decir, vecinos, miembros del hogar, etc.).
  - Riesgo laboral: el servidor identifica automáticamente el "cruce" entre el TS infectado y otros TS que también tienen 	la aplicación para teléfonos móviles. Es decir, identifica a aquellos que trabajaron los mismos turnos, o que 	estuvieron muy cerca a pesar de no compartir formalmente los turnos.
  - Riesgo incidental: el servidor identifica automáticamente las "paradas" en el itinerario geográfico del TS: es decir, estaciones de servicio, supermercados, visitas a un pariente, etc. Las personas en las ubicaciones de "paradas" pueden ser examinadas, ya que pueden haberse infectado.


## Protección de Datos

- La participación es voluntaria.
- Los participantes pueden desactivar fácilmente el seguimiento en cualquier momento simplemente presionando un botón.
- Los datos solo se usan si un TS da positivo.
- Todos los datos se eliminan automáticamente después de 14 días.
- Informes solo disponibles para las autoridades sanitarias pertinentes.
- No hay acceso directo al servidor para nadie, excepto el administrador del servidor.


## Timeline

- Inicio: tanto el front-end (aplicación de teléfono) como el back-end (sistema de administración de datos del servidor) ya existen y están listos para implementarse ahora.
- Informes: los tres informes antes mencionados se pueden desarrollar en <5 días.
- Escala: habiendo demostrado la viabilidad, propondremos una implementación a gran escala en <1 semana.

## Detalles

- Empresa para gestionar datos, generación de informes, seguridad: Databrew LLC
- Aplicación de teléfono móvil/servidor que se utilizará: Traccar
- Contacto: Joe Brew | joe@databrew.cc | +34666 66 80 86

