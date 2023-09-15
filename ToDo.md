# Umbau Template bez Parameter

## Mini KLasse (header only) bauen zur Kapselung von Atmic float Zeigern

KLasse bekommt den AudioProcessorValueTree und die ID
Checkt ob ID vorhanden ist
Holt sich den RawZeiger auf die Daten
baut OldVal auf
Testet auf neue Werte, checkt und gibt den neuen Wert zurück.

## Umbau der Parameter von vector Parameter zu ParameterLayout. 

AudioProcessorValueTreeState::ParameterLayout
hat eine add Funktion. 

## UI Groesse in ValueTree dex APVT nutzen
Man kann auf den zugrunde liegenden ValueTree zugreifen und diesen erweitern
für Informationen die keine Parameter sind.




