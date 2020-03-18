# BCV: Busca y captura el virus (Search and arrest the virus)

_A tool for GPS tracking of healthcare workers so as to empower and automated epidemiological contact-tracing_

## Quick-links

- To register as a participant: [REGISTRATION INSTRUCTIONS](https://datacat.cc/bcv/)
- Instructions for setting up phone after regisration: [PHONE INSTRUCTIONS](guias/phone_documentation.md)

## Overview

Healthcare workers are especially high-risk for COVID-19 infection. By extension, their contacts (including those they live with, those they treat, those from whom they shop, etc.) are also at high-risk of infection. Protecting healthcare workers’ contacts is vital to supporting their work, as well as to preventing largespread disease transmission from HCWs to society. We will passively track healthcare workers’ locations via smartphone so that when a healthcare worker tests positive, retrospective epidemiological investigation (contact-tracing) can be rapid, accurate, and automated.

## Steps / Protocol

- All healthcare workers of a facility/district are asked to voluntarily install a simple smartphone application.
- The application sends their GPS location to a secure server every 60 seconds.
- When a HCW tests positive, the HCW’s ID number is flagged as positive.
- Once a HCW is flagged as positive, the following 3 at-risk groups are automatically identified and reports are automatically generated:
  - Geographic risk group: The server automatically generates a report (with maps) outlining the geographical itinerary of the HCW during his/her hypothetically infectious period. This serves to identify/screen people potentially infected by the HCW (ie, neighbors, household members, etc.).
  - Occupational risk: The server automatically identifies “crossover” between the infected HCW and other HCWs who also have the smartphone app. That is, it identifies those who worked the same shifts, or who were in close proximity despite not formally sharing shifts.
  - Incidental risk: The server automatically identifies the “stops” in the HCS’s geographical itinerary: ie, gas-stations, grocery stores, visits to a relative, etc. People at the “stop” locations can be screened, since they may have become infected.

## Data protection

- Participation is voluntary.
- Participants can easily turn off tracking at any time by simply pressing a button.
- Data is only used if a HCW tests positive.
- All data is automatically deleted after 14 days.
- Reports only available to relevant health authorities.
- No direct access to server to anyone except server manager.

## Timeline

- Start: Both the front-end (smart phone application) and back-end (server data management system) already exist and are ready to deploy now.
- Reports: The three aforementioned reports can be developed in < 5 days.
- Scale: Having demonstrated feasibility, we will propose large-scale implementation in < 1 week.

## Details

- Company to manage data, reports generation, security: Databrew LLC
- Smartphone / server-side application to be used: Traccar
- Contact: Joe Brew | joe@databrew.cc | +34 666 66 80 86
