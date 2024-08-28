# Plugin (VST/AU with JUCE) Development with CMAKE for all platforms (install help)

This file will help you:
1. set up your development toolchain
2. test the toolchain
3. build a first helper plugin

## Requirements: 
1. Basic understanding of git (clone, staging (add), commit ,etc) and cmake (what is cmake?). Visual Studio Code (The Editor, not the IDE (that is Visual Studio)) will help to use CMake and Git.
2. Some basic knowledge of C++ or at least Java for OOP concepts

## install the basic tools

* Windows:
    0. Install compiler (I would use Visual Studio 2019 or later. The free version (community edition) is OK)
    1. Install git (e.g. use gitbash)
    2. Install CMAKE (don't forget to select option use/change PATH for all users)
    3. Install Editor (Visual Studio Code works on all platforms)

* Apple:
    0. Install compiler (I would use Xcode)
    1. Install git (if not installed)
    2. Install CMAKE (don't forget to add the path to terminal, e.g 
    ```console 
    sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install
    ```
    3. Install Editor (Visual Studio Code works on all platforms)

* Linux:
    0. Check installed compiler version (gcc -v should be > 9.0), if not installed,  install it
        (e.g. sudo apt install g++ build-essential gdb)
    1. check if git is available (git --version), if not install it
    2. check if CMAKE is available (cmake --version should be > 3.15), if not install it
    3. Install Editor (Visual Studio Code works on all platforms)

## install audio plugin development framework

Several platform independent frameworks are available (JUCE, IPlug, VSTGUI)
Only JUCE (www.juce.com) is described here. 

To prevent to many files cluttering around, start with e new subdirectory
e.g. AudioDev 

Inside AudioDev. clone JUCE (V8 stable is the current one) from https://github.com/juce-framework/JUCE
Your directory structure should look like that
AudioDev
    | AudioDevOrga
    | JUCE

## (Linux only) install dependencies for Linux
read https://github.com/juce-framework/JUCE/blob/master/docs/Linux%20Dependencies.md

## Prepare Visual Studio Code part 1

### add Tools/Extensions
* cpptools (basic language supports for C++ development)
* CMake (CMake language supports)
* CMake Tools (Advanced Integration for using CMake in VScode with GUI). Afterwards configure CMake (Crtl+Shift+P (Command Palette))
* if you have access (student), add CoPilot from GitHub/Microsoft
* Apple: 
    CodeLLDB (better debugger than built-in gdb) (for Apple only)

## Test the toolchain so far

Build the Juce tools (From JUCE Readme.md). DemoRunner is a nice demo of several Juce possibilities, AudioPluginHost is a simple but very useful debugging host for AU and VST. Using Projucer is the alternative way to manage JUCE projects. If you stay with me and CMake, you don't have to build Projucer.

* Change to the JUCE path: cd /path/to/JUCE (e.g C:\AudioDev\Juce in Windows) (in a terminal window (to open a terminal in VSCODE: Crtl+Shift+p and enter 'new terminal', the command 'Create new terminal' should be available in the given list of commands))
* Build Debug versions 
```console 
    cmake . -B build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON 
    cmake --build build --target DemoRunner 
    cmake --build build --target AudioPluginHost
    cmake --build build --target Projucer
```

* or build Release versions
```console 
    cmake . -B build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON -DCMAKE_BUILD_TYPE:STRING=Release
    cmake --build build --target DemoRunner
    cmake --build build --target AudioPluginHost
    cmake --build build --target Projucer
```
if you have time (I would recommend that, it takes 1-2h based on your system) build all tools 
```console 
    cmake --build build
```

* Decide if you want to use Projucer ==> if yes, you have to switch to other tutorials. Here, we will stay with CMake.

* Decide if you want to use the provided templates for plug-in development. I will use it for all my plug-in developments. (However, some basic tutorials (videos) in German will be given without using the templates).

##  Use AudioDev Directory as SuperProject for all Audio Dev 

Copy CMakeList.txt from this git project to the AudioDev Directory

## Test the toolchain so far with an example

Clone 
```console
git@github.com:JoergBitzer/CrossDevPlugInTest.git
```
or
```console
https://github.com/JoergBitzer/CrossDevPlugInTest.git
```
into AudioDev directory

1. Change CMakeFile.txt in the AudioDev Directory by adding (or uncomment)
```console 
   add_subdirectory(CrossDevPlugInTest)                  
```
2. Build the SuperProject or use the cmake tools (perhaps you have to restart VSC to get the cmake tools visible) given in VS Code (see next section, how to install and use VSC)
```console 
    cmake -B build
    cmake --build build
```
3. Search in build for CrossDevPlugInTest.artefacts (Standalone) and test the CrossDevPugInTest
(e.g  C:\AudioDev\build\CrossDevPlugInTest\CrossDevPluginExample_artefacts\
  Debug\Standalone\CrossDevPluginExample.exe)

## Prepare Visual Studio Code part 2

### Change Settings 
If no ``c_cpp_properties.json`` is in your .vscode hidden directory, use Crtl+Shift+p and search for c/c++ Edit configuration(JSON). This command creates ``c_cpp_properties.json``
* change (if set otherwise) to ``c++17`` in cpp setting  ``cppStandard``

* Look at for some tips (especially for Apple users)

https://github.com/tomoyanonymous/juce_cmake_vscode_example und use the tips for MacOS

* Apple: 
Be careful if bash or zsh is your default console in VS (usually its is bash). change in settings for zsh

After install Xcode and type xcode-select --install and in terminal. open ~/.zshrc and add export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)" in the last line of the file.

* Apple (still unclear for me, it works now without, but I changed and rechanged a lot):
At some point it seems cmake needs a special hint where to find the OSX specifics (which is at SDKROOT)
You can set the CMAKE_OSX_??? = $SDKROOT

* Linux:
    increase file watchers (if to small) (seems to be necessary for Ubuntu <= 18.04):
    1. test for the current setting 
    ```console 
            cat /proc/sys/fs/inotify/max_user_watches
    ```
    if this number is smaller than 100000 do the following steps, else ignore
    
    2. a) change settings (with an editor like vim or nano)
    ```console 
            sudo vim /etc/sysctl.conf
    ```
    2. b) add at last line 
    ```console 
        fs.inotify.max_user_watches=131072
    ```
    2. c) start the service again
    ```console 
        sudo sysctl -p
    ```
#### Debugging in VS 
Add in launch.json two debug entries:
If you do not have a launch.json file: 

1. load a cpp-file
2. click on the debug menu (on the left) and click "create a launch.json file"
3. change the file for two starting point for the debugger, one points to the the generated standaloe plugin, the second points to the AudioPluginHost (so you need to find your build in the build artifacts directories)

Examples:
* linux:
```console
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${command:cmake.launchTargetPath}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        },
        {
            "name": "(gdb) Launch PLuginHost",
            "type": "cppdbg",
            "request": "launch",
            "program": "/home/bitzer/AudioDev/JUCE/build/extras/AudioPluginHost/AudioPluginHost_artefacts/Release/AudioPluginHost",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
```

* Windows (Use the Visual studio debugger):

Tips: Look if the path is correct and change accordingly

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
            "name": "PluginHost Release VS",
            "type": "cppvsdbg",
            "request": "launch",
            "program": "C:/AudioDev/JUCE/build/extras/AudioPluginHost/AudioPluginHost_artefacts/Release/AudioPluginHost.exe",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        },
    ]
```     

* Apple (add just the .app for the AudioPluginHost)
```console
   "configurations": [
        {
            "type": "lldb",
            "request": "launch",
            "name": "PluginHost",
            "program": "/Users/bitzer/AudioDev/JUCE/cmake-build/extras/AudioPluginHost/AudioPluginHost_artefacts/AudioPluginHost.app",
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

## Additional things
### Debug or Release Builds
   
in VS use Ctrl+Shift+P (Command Palette) -> CMake Select Variant -> Choose Release or Debug

### Windows MSVC Redristibutables

For Windows check if the MSVC Redistributables (2015-2022) are installed. If not, install.
https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170


### Find a plugin host (You should test your plugin with as many hosts as possible)

1. You can build the pluginhost from JUCE (or did it already in the test)
2. Find other suitable hosts (several are free (see for example here https://www.musicradar.com/news/best-free-daws-music-production-software or here (https://midination.com/daw/free-daw/best-free-daw/)), other costs less than 100$, some are very expensive). 

3. For the development of VST-effects find a synthesizer (here some free and open source examples, mostly for all platforms)
    * SurgeXT: https://surge-synthesizer.github.io     
    * Vital: https://vital.audio/ 
    * Dexed (FM Synthesis) https://asb2m10.github.io/dexed/
    * OBxd https://github.com/reales/OB-Xd
    * Odin2 https://thewavewarden.com/pages/odin-2
  and audio samples (e.g. Music-Radar free samples (https://www.musicradar.com/news/tech/free-music-samples-royalty-free-loops-hits-and-multis-to-download-sampleradar)) as source signal:


### copy the plugin to the right directory 

* Linux: home/.vst/
* Windows: C:\Program Files\Common Files\VST3 ; (32 Bit, obsolete) C:\Program Files (x86)\Common Files\VST3
* Apple (VST3): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > VST3
* Apple (AU): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > Components

this step can be automated by using the JUCE settings (CMakeLists.txt of the plugin) in
juce_add_plugin add 
COPY_PLUGIN_AFTER_BUILD TRUE               # Should the plugin be installed to a default location after building?

This flag is already set in most examples. For Windows admin privileges (for Visual Code) are necessary.

#### Access rights for the final copy step (Windows only)

in Windows the console (for cmake) needs Admin rights. 
In Windows Visual Studio Code needs Admin rights for the same reason if cmake is used in VS.

### Platform dependent code in cmake (usually not necessary)
check with IF(CMAKE_SYSTEM_NAME STREQUAL Linux)

and ENDIF()

possible CMAKE_SYSTEM values
Windows   Windows (Visual Studio, MinGW GCC)
Darwin    macOS/OS X (Clang, GCC)
Linux     Linux (GCC, Intel, PGI)

help: (https://cmake.org/cmake/help/latest/variable/CMAKE_SYSTEM_NAME.html)

## Another example (a debug tool to write audio bits)

* Clone the following project in the AudioDev directory

git clone git@github.com:JoergBitzer/DebugAudioWriter.git

All new plugins have their own sub_dir
    
    AudioDev
    | AudioDevOrga
    | CrossDevPlugInTest
    | DebugAudioWriter
    | JUCE
    CMakeLists.txt

* change CMakeLists.txt (e.g. add add_subdirectory (DebugAudioWriter) )
* build everything with the cmake toolchain

