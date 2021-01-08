# Plugin Development with CMAKE for all plattforms (install help)

## installing the basic tools

* Windows:
    0. Install compiler (I would use Visual Studio 2019)
    1. Install git (use gitbash)
    2. Install CMAKE (dont forget to select option use PATH for alle users)
    3. Install Editor (Visual Studio works on all plattforms)

* Apple:
    0. Install compiler (I would use Xcode)
    1. Install git (if not installed)
    2. Install CMAKE (dont forget to add the path to terminal, e.g 
    ```console 
    sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install
    ```
    3. Install Editor (Visual Studio works on all plattforms)

* Linux:
    0. Check installed compiler version (gcc -v should be > 9.0), if not install it
    1. check if git is available (git --version), if not install it
    2. check if CMAKE is avaliable (cmake --version should be > 3.15), if not install it
    3. Install Editor (Visual Studio works on all plattforms)

## install audio plugin development framework

Several plattform independent frameworks are available (JUCE, IPlug, VSTGUI)
I would use JUCE (www.juce.com)

To prevent to many files cluttering around, start with e new subdirectory
e.g. AudioDev 

Inside AudioDev. clone JUCE from https://github.com/juce-framework/JUCE


## Test the toolchain so far
    From JUCE REadme.md
    cd /path/to/JUCE
    cmake . -B cmake-build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON
    cmake --build cmake-build --target DemoRunner
    cmake --build cmake-build --target AudioPluginHost
    cmake --build cmake-build --target Projucer

## Alternative 1: Setup JUCE for CMAKE globally (see "/home/bitzer/AudioDev/JUCE/docs/CMake API.md")
Bsp hier
    Go to JUCE directory
    cd /path/to/clone/JUCE
    
    * Linux:
    ```console 
    cmake -B cmake-build-install -DCMAKE_INSTALL_PREFIX=/home/bitzer/AudioDev/JUCE/install/
    cmake --build cmake-build-install --target install
    ```
    * Windows:
    ```console 
    cmake -B cmake-build-install -DCMAKE_INSTALL_PREFIX=C:/AudioDevNew/JUCE/install
    cmake --build cmake-build-install --target install
    ```
    * Apple:
    ```console 
    cmake -B cmake-build-install -DCMAKE_INSTALL_PREFIX=/Users/bitzer/AudioDev/JUCE/install
    cmake --build cmake-build-install --target install
    ```

## Alternative 2 (recommended): Use AudioDev Directory as SuperProject for all Audio Dev (this seems the better way)
    1. Copy CMakeList.txt from this git projekt to the AudioDev Directory

## Test mit der Kopie von examples AudioPlugin
 Clone https://github.com/JoergBitzer/CrossPlugInTest

* Using Alternative 1:
    * Linux:
        cmake -B build -DCMAKE_PREFIX_PATH=/home/bitzer/AudioDev/JUCE/install/
        cmake --build build
    * Windows:
        cmake -B build -DCMAKE_PREFIX_PATH=C:/AudioDevNew/JUCE/install
        cmake --build build
    * Apple:
        cmake -B build -DCMAKE_PREFIX_PATH=/Users/bitzer/AudioDev/JUCE/install
        cmake --build build

* Using Alternative 2 (recommended):
    1. Change the CMakeListFile.txt by using the alternative File AltMakeLists.txt
    2. Change CMakeFile.txt in dthe AudioDev Directory by adding 
    ```console 
    add_subdirectory(CrossPlugInTest)                  
    ```
    3. Build the SuperProject
    ```console 
    cmake -B build
    cmake --build build
    ```
## Prepare Visual Studio Code

### add Tools/Extensions
cpptools (basic language supports for C++ development)
CMake (CMake language supports)
CMake Tools (Advanced Integration for using CMake in VScode with GUI)
CodeLLDB (better debugger than built-in gdb)


### Change Settings 
Look for files.watcherExclude und add
**/JUCE/** 

und ähnliches, dass sich VSCOde nicht ansehen soll (Sonst überwacht VSC zu viele Dateien)

Debugging
Add in launch.json. Das erste muss zum AudioPlugINHOst leiten, das zweite ermöglich die StandAlone VErsionen zu öffnen.
```console
    "configurations": [
        {
            "type": "lldb",
            "request": "launch",
            "name": "PluginHost",
            "program": "/home/bitzer/AudioDev/JUCE/cmake-build/extras/AudioPluginHost/AudioPluginHost_artefacts/AudioPluginHost",
            "args": [],
            "cwd": "${workspaceFolder}"
        },
        {
            "type": "lldb",
            "request": "launch",
            "name": "CMaKe Debug",
            "program": "${command:cmake.launchTargetPath}",
            "args": [],
            "cwd": "${workspaceFolder}"
        }
    ]
```
* Windows:

```console
    "configurations": [
        {
            "name": "Debug VS",
            "type": "cppvsdbg",
            "request": "launch",
            "program": "${command:cmake.launchTargetPath}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        },
 
        {
            "name": "PluginHost Debug VS",
            "type": "cppvsdbg",
            "request": "launch",
            "program": "C:/AudioDevNew/JUCE/build/extras/AudioPluginHost/AudioPluginHost_artefacts/Release/AudioPluginHost.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        },
```     


## Additinal things

### Access rights for the final copy step

in Windows the console (for cmake) needs Admin rights 

### Debug Release Builds
   
To choose between Debug und Release add in the cmake command cmake ein --config Debug/Release

### Find a plugin host

1. You can build the pluginhost from JUCE (or did it already in the test)
2. Find other suitable hosts:
    * Windows: 
        * Reaper (cost 60$)
        * Cubase SE (cost 50$)
    * Linux: 
        * Reaper (cost 60$)
    * Apple:
        * Reaper (cost 60$)

### plattform independent code
check with IF(CMAKE_SYSTEM_NAME STREQUAL Linux)

und ENDIF()


CMAKE_SYSTEM 
Windows   Windows (Visual Studio, MinGW GCC)
Darwin    macOS/OS X (Clang, GCC)
Linux     Linux (GCC, Intel, PGI)


### copy the vst to the right directory

* Linux: home/.vst/
* Windows: C:\Program Files\Common Files\VST3 ; (32 Bit, obsolete) C:\Program Files (x86)\Common Files\VST3
* Apple (VST3): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > VST3
* Apple (AU): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > Components

