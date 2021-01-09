## Todo Liste fuer Audio Dev

### Vorbereitung

1. Done : GitHUb Projekt für DemoProjekt (copy von JUCE Example)
2. Vernünftigen VST3 Host unter Linux finden (Native LinuxVST3) (Reaper??)
3. Kompilieren mit CMAKE unter allen drei PLattformen 
    * Linux (Done)
    * Win (Done)
    * MacOS (Done)
4. Erweitern mit Kopie zu einem anderen Ort (alle Plattformen) (more or less done)
5. Test mit internen Juce Tools (PLugInTester) (Done for Linux, Windows, Apple)


### Lernen bez CMAKE 
1. Done Wie kopiert man die fertige dll zu einem fixen Ordner, damit man mit einem anderen Host testen kann
 Test mit /home/bitzer/AudioDev/PlugIns/ VST3 hat festen Ordner somit DONE 
 Noch ungeklärt wäre ein eigener Post_build copy Befehl





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
1. Wie debugging? (Done, easy mit CmakeTools und lldb)
2. Workflow allgemein mit VisualCode (Done, easy mit CMakeTools)

### Projekte
0. Alte Projekte zum laufen bringen (Filtarbor wegen eigen und JadeLookAndFeel (Also Frembibliothek und unserer eigenen Lib))
1. Projekt zPlane Viever fertig stellen (als Übungsprojekt)
2. Projekt EQ Synth starten (HIer über konstante Videoaufzeichnung nachdenken)

### Git Subprojects lernen
EIgen https://gitlab.com/libeigen/eigen
git@gitlab.com:libeigen/eigen.git 

Wie funktionieren in git submodule. Notwendig, um die gesamte Entwicklngsumgebung richtig zu konfigurieren

### Static Libs for DSP only Code


# Tell CMake to add a static library target
add_library(TGMTools_lib STATIC)
# Add sources to the target
target_sources(TGMTools_lib PRIVATE
    Libs/TGMTools/FreeOrderLowHighpassFilter.cpp
    Libs/TGMTools/GeneralIR.cpp
    Libs/TGMTools/JadeLookAndFeel.cpp) # etc.
# Tell CMake where our library's headers are located
#target_include_directories(TGMTools_lib PUBLIC
#Libs/eigen;Libs/eigen/unsupported;Libs/TGMTools)

set_target_properties(TGMTools_lib PROPERTIES
    POSITION_INDEPENDENT_CODE TRUE
    VISIBILITY_INLINES_HIDDEN TRUE
    C_VISIBILITY_PRESET hidden
    CXX_VISIBILITY_PRESET hidden)

