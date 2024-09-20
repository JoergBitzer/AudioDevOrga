# Tutorial: Ein simples Gain PLugin
Ziele dieses Tutorials:
1. Juce kennenlernen (mit CMake)
2. Erste Schritte AudioPlugIns
3. Parameter-Handling und Parameter-Smoothing

Wichtige Anmerkungen: 
Dieses Tutorial hat nur das Ziel bestimmte Konzepte zu verdeutlichen. Wir werden die eigentlichen Plug-Ins mit anderen JUCE Werkzeugen und mit Hilfe von Templates erstellen. Alles was hier gemacht wird, wird also anschließend verworfen. Dies ist ein wichtiger Punkt. Lernt man neue bessere Wege, muss man sich von alten Dingen trennen.

## Vorbereitungen
1. Anlegen eines Unterverzeichnis: Zum Bsp GainPlugin in unserem Unterordner AudioDev.
2. Kopieren des Bsps (alle 5 Dateien) aus dem Unterordner AudioDev/JUCE/examples/CMake/AudioPlugin/ in unser neues Unterverzeichnis

## Analyse was vorliegt.

### CMakeLists.txt 
Dies ist die Datei, die CMake zur Erzeugung der Projekte nutzt. 
Diese Datei ist gut kommentiert aber es sind einige Anpassungen notwendig, vor allem, da JUCE in einem Parallelordner liegt.

Wenn man vorher nicht InstallReadMe.md durchgeführt hat. 
1. Die Datei CMakeLists.txt einmal in den höheren Ordner (AudioDev) kopieren (wir brauchen die Datei zweimal)
2. Diese Datei öffnen und alles ab Zeile 27 löschen
3. Die Zeile 17 ändern in (Ist eigentlich irrelevant): project(JUCEDEVREPO VERSION 0.0.1)
4. Kommentierung löschen/Aktivieren von Zeile 26: add_subdirectory(JUCE)

Ab hier weiter für alle: 
5. Den neuen Projektordner als subdirectory hinzufügen: add_subdirectory(GainPlugIn)
6. Datei speichern und so lassen.

7. Die CMakeLists.txt im Unterordner GainPlugIn öffnen und die folgenden Änderungen vornehmen:

* Zeile 17 ändern: project(AUDIO_PLUGIN_EXAMPLE VERSION 0.0.1) zu
                   project(AUDIO_PLUGIN_GAIN VERSION 0.1.0)
* Tip: Bei der Versionierung sollte man sich an das Semantic Versioning halten https://semver.org/lang/de/
* Die Zeilen 40-55 anpassen: zB so: 

```console
juce_add_plugin(AudioPluginGain
    # VERSION ...                               # Set this if the plugin version is different to the project version
    # ICON_BIG ...                              # ICON_* arguments specify a path to an image file to use as an icon for the Standalone
    # ICON_SMALL ...
    COMPANY_NAME "Jade Hochschule"                          # Specify the name of the plugin's author
    IS_SYNTH FALSE                       # Is this a synth or an effect?
    NEEDS_MIDI_INPUT FALSE               # Does the plugin need midi input?
    NEEDS_MIDI_OUTPUT FALSE              # Does the plugin need midi output?
    IS_MIDI_EFFECT FALSE                 # Is this plugin a MIDI effect?
    # EDITOR_WANTS_KEYBOARD_FOCUS TRUE/FALSE    # Does the editor need keyboard focus?
    COPY_PLUGIN_AFTER_BUILD FALSE        # Should the plugin be installed to a default location after building?
    PLUGIN_MANUFACTURER_CODE IHAJ               # A four-character manufacturer id with at least one upper-case character
    PLUGIN_CODE Gai0                            # A unique four-character plugin id with exactly one upper-case character
                                                # GarageBand 10.3 requires the first letter to be upper-case, and the remaining letters to be lower-case
    FORMATS AU VST3 Standalone                  # The formats to build. Other valid formats are: AAX Unity VST AU AUv3
    PRODUCT_NAME "ASimpleGain")        # The name of the final executable, which can differ from the target name
```
* Auskommentieren/Aktivieren von Zeile: juce_generate_juce_header(AudioPluginGain) (Achtung Name muss zum plugin namen (Zeile 40) passen ) (ca bei Zeile 60)
* Anpassen mit dem richtigen Namen (Zeile 40):  target_sources(AudioPluginGain (ca Zeile 70)
* Anpassen mit dem richtigen Namen (Zeile 40): target_compile_definitions(AudioPluginGain (ca Zeile 82)
* Anpassen mit dem richtigen Namen (Zeile 40): target_link_libraries(AudioPluginGain (ca Zeile 104)

Natürlich kann man auch replace (Crtl + H) von AudioPluginExample für alle Instanzen ausführen. Dies ist der sicherere Weg.

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
In einer Konsole im Unterordner AudioDev oder über die CMAKE Tools von VSCode 

```console 
    cmake . -B build 
    cmake --build build
```
ausführen.

2. Testen:
    1. Finden des Hosts. Ist gut versteckt:
    /AudioDev/JUCE/build/extras/AudioPluginHost/AudioPluginHost_artefacts/Release/AudioPluginHost/AudioPluginHost oder im neuen Unterordner Tools zu finden.
    2. Starten 
    3. Unter Optionen, Edit the List of ... wählen
    4. Options aufrufen
    5. Scan for new and updated VST plugins auswählen
    6. Ein weiteres Verzeichnis hinzufügen (+)
    7. Plugin suchen (ist gut versteckt): AudioDev/build/GainPlugIn/AudioPluginGain_artefacts/Debug/VST3/
    8. Das neue Plugin (a simple gain) sollte in der Liste der Available Plugin auftauchen.
    9. Das plugin im Hauptfenster laden im Menupunkt Plugins CreatePLugins beim Vendor (hier Jade) schauen.
    10. GUI öffnen. Rechte Maustaste Show plugin GUI ==> Ein graues Fenster mit Hello World erscheint.
    11. AudioPluginHost schließen (vlt vorher den Filtergraph unter Save speichern.).

3. Erste Änderung durchführen, um zu testen, ob wirklich alles funktioniert.

In PLuginEditor.cpp die Zeilen 24-26 nach Geschmack ändern und speichern nicht vergessen: Bsp

```cpp 
    g.setColour (juce::Colours::red);
    g.setFont (18.0f);
    g.drawFittedText ("Welcome to my World!", getLocalBounds(), juce::Justification::centred, 1);
```
Neu kompilieren mit cmake --build build

PluginHost neu starten. 

## Gain V1
Nur zur Erinnerung: Dies ist nicht der Weg, wie man ihn für Steuerungs-Parameter nutzt. Trotzdem ist es ein Weg für die GUI-Plugin Kommunikation (also für nicht automatisierbare oder speicherbare Veränderung der GUI). Ob man das will oder braucht, hängt vom Ziel und der eigenen Präferenz ab.

### Gain in PluginProcessor.h/cpp (Version 1)

Ein Gain ist zunächst nicht weiter als eine Multiplikation aller Eingangswerte (Oft Samples genannt, Ein Frame ist of ein Sample über mehrere Kanäle, Ein Block sind mehrere Frames) mit einem konstanten Wert, der zum leiser werden kleiner eins und zum verstärken größer 1 sein sollte. Nun ist das Ohr in der Wahrnehmung nicht so aufgebaut, dass es die Änderung der Multiplikation von 0.1 auf 0.2 genau so wahrnimmt wie von 0.9 auf 1.0. Statt dessen ist das Gehör ansatzweise logarithmisch. Deshalb gibt man Gains in dB an und der Referenzwert ist 1.
Also 0dB = 1. Die Umrechnung erfolgt über gain = 10^(gain_log/20). 

### Programmierung in PluginProcessor.h/cpp:
1. Interne (private) Variable für den Gain anlegen (Unten im Header private suchen). zB m_gain (m_ für Membervariable, dies ist Geschmackssache.Einige nutzen oft nur _gain, andere machen diese Unterscheidung nicht. Ich empfehle es aber sehr.) und initialisieren.

```cpp
private: 
    float m_gain = 1.f;
```
2. Methode zur Umrechnung als setter im Header schreiben (public Methode)

```cpp
    //========== Eigene Erweiterung =====================
    void setGain(const float gain_dB){m_gain = pow(10.0,gain_dB/20.0);};
private:
    float m_gain  = 1.f;
```
3. Multiplikation in processBlock einbauen (ab Zeile 147).
```cpp
    int NrOfSamples = buffer.getNumSamples();
    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer (channel);
        juce::ignoreUnused (channelData);
        // ..do something to the data...
        for (int kk = 0; kk < NrOfSamples; ++kk)
        {
            channelData[kk] *= m_gain;
        }
    }
```
4. Test 
    1. Filtergraph im AudioPlugInHost aufbauen (Quelle zB Surge, dann unser ASimpleGain und Out.) und speichern
    2. Output anhören und AudioPlugInHost beenden
    3. Initialisierungswert auf 0.1 setzen und anschließend auf 5.0. Immer wieder den Host dazwischen beenden und natürlich neu kompilieren.

WICHTIG: Immer wenn man ein neues Feature einbaut, das Ergebnis testen. (Profis schreiben für so etwas UnitTests, das kommt vlt. später.).

### Programmierung in PluginEditor.h/cpp:
Ziel ist ein Slider im Wertebereich von -80 bis +10 dB aufzubauen und damit den Gain des Audiosignals zu ändern.

GUI Programmierung ist in JUCE auf der einen Seite einfach aber auch sehr mächtig (viele Details). Dies ist nur ein Anriss.


1. Hinzufügen des Sliders im Header (private)
```cpp
    juce::Slider m_gainSlider;
```

2. In der cpp Datei den Slider definieren und die Größe des Plugins anpassen. Wichtig ist hier die lambda-Funktion, die onValueChange zugeordnet wird (Zeigt die enorme Nützlichkeit von lambda Funktionen).
Achtung: Wir übertreten hier die Thread-Grenzen von GUI zu Audio. Dies darf man nur bei int und float machen. Vorsicht, wenn aus den gesetzten Werten andere zunächst berechnet werden. Hier gibt es andere und bessere Lösungen über Block-free FiFos (brauchen wir später).

```cpp
   setSize (100, 300);
    addAndMakeVisible (m_gainSlider);
    m_gainSlider.setRange (-80, 10.0);          // [1]
    m_gainSlider.setTextValueSuffix (" dB");     // [2]
    m_gainSlider.setSliderStyle(juce::Slider::LinearVertical);
    m_gainSlider.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxAbove, true, 60, 20);
    m_gainSlider.onValueChange = [this]{processorRef.setGain(m_gainSlider.getValue());}; 
    m_gainSlider.setValue(0.0);
```

3. In der resized Methode den Slider bezogen auf die Größe des PlugIns zeichnen. Dies macht man in der Profi-Version relativ, um eine stufenloses vergrößern/verkleinern zuzulassen.
```cpp
    m_gainSlider.setBounds (20, 20, getWidth() - 40, getHeight()-40);
```

4. paint aufräumen: Also nur die FillAll Routine stehen lassen. Alles andere löschen.

5. Testen.

## Probleme

* Gain wird nicht als Parameter im Host gespeichert. Das PLugin startet immer wieder mit 0dB
* Bei schnellen Bewegungen des Gain kanckt es. (Test mit tieffrequenten Sinus (100Hz))

## Take-Home Message:

* Es gibt genau einen Start (Einsprung) für jedes Plugin ==> Processor
* Hier findet die Audioverarbeitung statt
* Der Processor ruft den Editor auf (und übergibt eine Adresse auf sich selbst, so dass der Editor den Processor kennt)
* Der Editor ist selbstständig und läuft in einem eigenen Thread (GUI Thread)
* Der Processor darf NIEMALS auf den Editor zugreifen (Die GUI könnte ja nicht da sein). Umgekehrt ja.

## Nächste Schritte:

1. Wie verhindert man Clicks und Crackles beim regeln von Parametern. (Das unterscheidet gute von schlechten PlugIns) ==> Viele Lösungen, von denen wir im Laufe der Zeit einige kennen lernen. Für Gains spezielle Lösungen in JUCE.
2. Wie baut man richtige Parameter und speichert diese auch im Host. ==> Viele Lösungen, wir gehen den JUCE Weg

Nächstes File: 2_GainParameter_der_JUCE_Weg.md












