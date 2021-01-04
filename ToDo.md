## Todo Liste fuer Audio Dev

### Vorbereitung

1. Done : GitHUb Projekt für DemoProjekt (copy von JUCE Example)
2. Vernünftigen VST3 Host unter Linux finden (Native LinuxVST3) (Reaper??)
3. Kompilieren mit CMAKE unter allen drei PLattformen 
    * Linux (Done)
    * Win (Done)
    * MacOS (Done)
4. Erweitern mit Kopie zu einem anderen Ort (alle Plattformen) (more or less done)
5. Test mit internen Juce Tools (PLugInTester) (Done for Linux, Windows)


### Lernen bez CMAKE 
1. Done Wie kopiert man die fertige dll zu einem fixen Ordner, damit man mit einem anderen Host testen kann
 Test mit /home/bitzer/AudioDev/PlugIns/ VST3 hat festen Ordner somit DONE




2. Wie inkludiert man Resourcen (BItmaps) : Laut JUCE CMake API geht dass einfach

von https://github.com/baconpaul/tuning-workbench-synth/blob/master/CMakeLists.txt

file(GLOB TWS_RESOURCES_GLOB
  Resources/*.ttf 
  Resources/*.png 
  Resources/*.svg
  Resources/factory_patches/*.twsxml
  )

juce_add_binary_data( tuning-workbench-synth-binary
  SOURCES ${TWS_RESOURCES_GLOB}
)

3. Wie bindet man andere Libs ein (Eigen und eigene Common Libs)

target_include_directories(tuning-workbench-synth 
  PRIVATE
  Source
  lib/tuning-library/include
)


### Lernen bez AudioDev (Weiterentwicklung PresetHandler)
1. FactoryPresets mit XML und Resourceneinbindung 
2. Presets unter Linux / MacOS 

### Lernen Entwicklung unter Linux
1. Wie debugging?
2. Workflow allgemein mit VisualCode

### Projekte
1. Projekt zPlane Viever fertig stellen (als Übungsprojekt)
2. Projekt EQ Synth starten (HIer über konstante Videoaufzeichnung nachdenken)

### Mehr zu CMAKE
https://mirkokiefer.com/cmake-by-example-f95eb47d45b1

präprozessor definitions
https://cmake.org/cmake/help/latest/command/add_compile_definitions.html#command:add_compile_definitions



### Sonstige Ergänzungen

Moegliche sinnvolle Erweiterungen
    JUCE_DISPLAY_SPLASH_SCREEN=0
    JUCE_REPORT_APP_USAGE=0

    in 

    target_compile_definitions(tuning-workbench-synth PUBLIC



    VST3_CATEGORIES "Fx" 
    AU_MAIN_TYPE "kAudioUnitType_Effect"

    in

    juce_add_plugin


    Fuer VS Code Nutzung

    https://github.com/tomoyanonymous/juce_cmake_vscode_example

    Fuer Testuung in Github

    https://github.com/sudara/pamplejuce


