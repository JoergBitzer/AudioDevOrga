# Tutorial: Ein simples Gain PLugin
Ziele dieses Tutorials:
1. Juce kennenlernen (mit CMake)
2. Erste Schritte AudioPlugIns
3. Parameter-Handling und Parameter-Smoothing

Wichtige Anmerkungen: 
Dieses Tutorial hat nur das Ziel bestimmte Konzepte zu verdeutlichen. Wir werden die eigentlichen Plug-Ins anders und mit Hilfe von Templates erstellen. Alles was hier gemacht wird, wird also anschließend weg geschmissen. Dies ist ein wichtiger Punkt. Lernt man neue bessere Wege, muss man sich von alten Dingen trennen.

## Vorbereitungen
1. Anlegen eines Unterverzeichnis: Zum Bsp GainPlugin in unserem Unterordner AudioDev.
2. Kopieren des Bsps (alle 5 Dateien) aus dem Unterordner JuceDev/JUCE/examples/CMake/AudioPlugin/ in unser neues Unterverzeichnis

## Analyse was vorliegt.

### CMakeLists.txt 
Dies ist die Datei, die CMake zur Erzeugung der Projekte nutzt. 
Diese Datei ist gut kommentiert aber es sind einige Anpassungen notwendig, vor allem, da JUCE in einem Parallelordner liegt.

1. Die Datei CMakeLists.txt einmal in den höheren Ordner (JuceDev) kopieren (wir brauchen die Datei zweimal)
2. Diese Datei öffnen und alles ab Zeile 27 löschen
3. Die Zeile 17 ändern in (Ist eigentlich irrelevant): project(JUCEDEVREPO VERSION 0.0.1)
4. Kommentierung löschen/Aktivieren von Zeile 26: add_subdirectory(JUCE)
5. Unser Projektordner als subdirectory hinzufügen (neue Zeile 27): add_subdirectory(GainPlugIn)
6. Datei speichern und so lassen.

7. Die CMakeLists.txt im Unterordner GainPlugIn öffnen und die folgenden Änderungen vornehmen:

* Zeile 17 ändern: project(AUDIO_PLUGIN_EXAMPLE VERSION 0.0.1) zu
                   project(AUDIO_PLUGIN_GAIN VERSION 0.1.0)
* Tip: Bei der Versionierung sollte man sich an das Semantic Versioning halten https://semver.org/lang/de/
* Zeile 40 ändern: juce_add_plugin(AudioPluginGain
* Die Zeilen 41-55 anpassen: zB so: 

```console
juce_add_plugin(AudioPluginGain
    # VERSION ...                               # Set this if the plugin version is different to the project version
    # ICON_BIG ...                              # ICON_* arguments specify a path to an image file to use as an icon for the Standalone
    # ICON_SMALL ...
    COMPANY_NAME "Jade"                          # Specify the name of the plugin's author
    IS_SYNTH FALSE                       # Is this a synth or an effect?
    NEEDS_MIDI_INPUT FALSE               # Does the plugin need midi input?
    NEEDS_MIDI_OUTPUT FALSE              # Does the plugin need midi output?
    IS_MIDI_EFFECT FALSE                 # Is this plugin a MIDI effect?
    # EDITOR_WANTS_KEYBOARD_FOCUS TRUE/FALSE    # Does the editor need keyboard focus?
    COPY_PLUGIN_AFTER_BUILD FALSE        # Should the plugin be installed to a default location after building?
    PLUGIN_MANUFACTURER_CODE Jade               # A four-character manufacturer id with at least one upper-case character
    PLUGIN_CODE gai0                            # A unique four-character plugin id with exactly one upper-case character
                                                # GarageBand 10.3 requires the first letter to be upper-case, and the remaining letters to be lower-case
    FORMATS AU VST3 Standalone                  # The formats to build. Other valid formats are: AAX Unity VST AU AUv3
    PRODUCT_NAME "ASimpleGain")        # The name of the final executable, which can differ from the target name
```
* Auskommentieren/Aktivieren von Zeile 60 (Achtung Name muss zum plugin namen (Zeile 40) passen ): juce_generate_juce_header(AudioPluginGain)
* Anpassen Zeile 70 mit dem richtigen Namen (Zeile 40):  target_sources(AudioPluginGain
* Anpassen Zeile 82 mit dem richtigen Namen (Zeile 40): target_compile_definitions(AudioPluginGain
* Anpassen Zeile 104 mit dem richtigen Namen (Zeile 40): target_link_libraries(AudioPluginGain

Natürlich kann man auch replace von AudioPluginExample für alle Instanzen ausführen. Dies ist der sicherere Weg.

* Wichtig sind noch die Zeilen 70-73. Hier müssen die Source-Files auftauchen, die in das Projekt sollen. Für dieses Beispiel passt es.

### PluginProcessor.cpp/h

Diese Dateien sind das Interface zur eigentlichen Audioverarbeitung.
Wichtig sind zum Anfang die Methoden:
* Initialisierung: void prepareToPlay (double sampleRate, int samplesPerBlock) override;
* Processing / Signalverarbeitung: void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

Der Editor (die Bedienoberfläche/GUI) wird in der Methode juce::AudioProcessorEditor* createEditor() override;
aufgebaut.

Alles andere ist im Moment und für ein so einfaches Plugin irrelevant.

### PluginEditor.cpp/h
Diese Dateien definieren die GUI 
Wichtig sind zum Anfang die Methoden:
* Konstruktor: Aufbau der GUI Elemente
* paint: zum Zeichnen der Elemente.


## Kompilieren und Testen / Orientierung

1. Kompilieren ob alles geht.
In einer Konsole im Unterordner JuceDev 

```console 
    cmake . -B build 
    cmake --build build
```
ausführen.

2. Testen:
    1. Finden des Hosts. Ist gut versteckt:
    /JuceDev/JUCE/build/extras/AudioPluginHost/AudioPluginHost_artefacts/Release/AudioPluginHost/AudioPluginHost
    2. Starten 
    3. Unter Optionen, Edit the List of ... wählen
    4. Options aufrufen
    5. Scan for new and updated VST plugins auswählen
    6. Ein weiteres Verzeichnis hinzufügen (+)
    7. Plugin suchen (ist gut versteckt): JuceDev/build/GainPlugIn/AudioPluginGain_artefacts/Debug/VST3/
    8. Das neue Plugin (a simple gain) sollte in der Liste der Available Plugin auftauchen.
    9. Das plugin im Hauptfenster laden im Menupunkt Plugins CreatePLugins beim Vendor (hier Jade) schauen.
    10. GUI öffnen. Rechte Maustaste Show plugin GUI ==> Ein graues Fenster mit Hello World erscheint.
    11. AudioPluginHost schließen (vlt vorher den Filtergraph unter Save speichern.).

3. Erste Änderung durchführen, um zu testen, ob wirklich alles funktioniert.

In PLuginEditor.cpp die Zeilen 24-26 nach Geschmack ändern und speichern nicht vergessen: Bsp

```console 
    g.setColour (juce::Colours::red);
    g.setFont (18.0f);
    g.drawFittedText ("Welcome to my World!", getLocalBounds(), juce::Justification::centred, 1);
```
Neu kompilierenmit cmake --build build

PluginHost neu starten. 











