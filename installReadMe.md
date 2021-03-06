# Plugin (VST/AU with JUCE) Development with CMAKE for all plattforms (install help)

## Requirements: 
1. Basic understanding of git (clone, staging, commit etc) and cmake (what is cmake?)
2. Some knowledge in C++ or at least Java for OOP concepts

## install the basic tools

* Windows:
    0. Install compiler (I would use Visual Studio 2019 the free version (community edition) is OK)
    1. Install git (use gitbash)
    2. Install CMAKE (dont forget to select option use/change PATH for alle users)
    3. Install Editor (Visual Studio Code works on all plattforms)

* Apple:
    0. Install compiler (I would use Xcode)
    1. Install git (if not installed)
    2. Install CMAKE (dont forget to add the path to terminal, e.g 
    ```console 
    sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install
    ```
    3. Install Editor (Visual Studio Code works on all plattforms)

* Linux:
    0. Check installed compiler version (gcc -v should be > 9.0), if not installed,  install it
    1. check if git is available (git --version), if not install it
    2. check if CMAKE is avaliable (cmake --version should be > 3.15), if not install it
    3. Install Editor (Visual Studio Code works on all plattforms)

## install audio plugin development framework

Several plattform independent frameworks are available (JUCE, IPlug, VSTGUI)
Only JUCE (www.juce.com) is described here. 

To prevent to many files cluttering around, start with e new subdirectory
e.g. AudioDev 

Inside AudioDev. clone JUCE (at least Version 6.0.8) from https://github.com/juce-framework/JUCE
Your directory structure should look like that
AudioDev
    | AudioDevOrga
    | JUCE


## Test the toolchain so far

From JUCE REadme.md
    cd /path/to/JUCE
* Debug Versions
```console 
    cmake . -B build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON 
    cmake --build build --target DemoRunner
    cmake --build build --target AudioPluginHost
    cmake --build build --target Projucer
```

* Release
```console 
    cmake . -B build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON -DCMAKE_BUILD_TYPE:STRING=Release
    cmake --build build --target DemoRunner
    cmake --build build --target AudioPluginHost
    cmake --build build --target Projucer
```
if you have time (I would recommend that, it takes 1-2h based on your system) just 
```console 
    cmake --build build
```

##  Use AudioDev Directory as SuperProject for all Audio Dev 

Copy CMakeList.txt from this git projekt to the AudioDev Directory

## Test the toolchain so far with an example

Clone https://github.com/JoergBitzer/CrossPlugInTest into AudioDev directory

1. Change CMakeFile.txt in the AudioDev Directory by adding (or uncomment)
```console 
   add_subdirectory(CrossPlugInTest)                  
```
2. Build the SuperProject or use the cmake tools given in VS Code
```console 
    cmake -B build
    cmake --build build
```
3. Search in build for CrossPugin.artefacts (Standalone) and test the CrossPlugIn


## Prepare Visual Studio Code

### add Tools/Extensions
* cpptools (basic language supports for C++ development)
* CMake (CMake language supports)
* CMake Tools (Advanced Integration for using CMake in VScode with GUI)
* Apple: 
    CodeLLDB (better debugger than built-in gdb) (for Apple only)


### Change Settings 
If no ``c_cpp_properties.json`` is in your .vscode hidden directory, use Crtl+Shift+P and search for c/c++ Edit configuration. This command creates ``c_cpp_properties.json``
* change (if set otherwise) to ``c++17`` in cpp setting  ``cppStandard``

* Look at for some tips (especially for Apple users)

https://github.com/tomoyanonymous/juce_cmake_vscode_example und die Apple Sachen übernehmen

* Apple: 
Be careful if bash or zsh is your default console in VS (usually its is bash). change in settings for zsh

After install Xcode and type xcode-select --install and in terminal. open ~/.zshrc and add export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)" in the last line of the file.

* Apple (still unclear for me, it works now without, but I changed and rechanged a lot):
At some point it seems cmake needs a special hint where to find the OSX specifics (which is at SDKROOT)
You cn set the CMAKE_OSX_??? = $SDKROOT

* Linux:
    increase file watchers:
    1. test for the current setting 
    ```console 
            cat /proc/sys/fs/inotify/max_user_watches
    ```
    2. a) change settings
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

1. one points to the the generated standaloe plugin
2. one points to the AudioPluginHost (so you need to find your build in the build artifacts directories)

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


### Debug Release Builds
   
in VS use Ctrl+Shift+P (Command Palette) -> CMake Select Variant -> Choose Release or Debug

For Windows check if the MSVC Redistributables (2015-2019) are installed.

### Find a plugin host (You should test your plugin with as many hosts as possible)

1. You can build the pluginhost from JUCE (or did it already in the test)
2. Find other suitable hosts:
    * Windows: 
        * Reaper (cost 60$ as a private user, you can use it on all plattforms, but not simultaneously)
        * Cubase SE (cost 50$)
    * Linux: 
        * Reaper (cost 60$)
    * Apple:
        * Reaper (cost 60$)

3. For effects find a nice Synth as Source
        Free and very good: https://surge-synthesizer.github.io     
        and for all plattforms (including Linux)


### platform dependent code in cmake (usually not necessary)
check with IF(CMAKE_SYSTEM_NAME STREQUAL Linux)

and ENDIF()

possible CMAKE_SYSTEM values
Windows   Windows (Visual Studio, MinGW GCC)
Darwin    macOS/OS X (Clang, GCC)
Linux     Linux (GCC, Intel, PGI)


### copy the plugin to the right directory 

* Linux: home/.vst/
* Windows: C:\Program Files\Common Files\VST3 ; (32 Bit, obsolete) C:\Program Files (x86)\Common Files\VST3
* Apple (VST3): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > VST3
* Apple (AU): Macintosh HD > Users->UserName->Library > Audio > Plug-Ins > Components

this step can be automated by using the JUCE settings (CMakeLists.txt of the plugin) in
juce_add_plugin add 
COPY_PLUGIN_AFTER_BUILD TRUE               # Should the plugin be installed to a default location after building?

This flag is already set in most examples

#### Access rights for the final copy step (Windows only)

in Windows the console (for cmake) needs Admin rights. 
In Windows Visual Studio Code needs Admin rights for the same reason if cmake is used in VS.

### Prevent the splash screen (see license, if you are allowed to do this)

in target_compile_definitions 

JUCE_DISPLAY_SPLASH_SCREEN=0
JUCE_REPORT_APP_USAGE=0
  
## Add some necessary libraries (at least for the next examples)

### Add eigen (a linear algebra header-based lib, e.g, to compute eigen-values) in a subdirectory Libs

git clone https://gitlab.com/libeigen/eigen.git

### Add TGM Tools (some common files e.g. dsp code or LookAndFeel)

git clone git@github.com:JoergBitzer/TGMTools.git

Your directory structure should look like this

AudioDev
    | AudioDevOrga
    | CrossPlugInTest
    | JUCE
    | Libs
    | ----| Eigen
    | ----| TGMTools



## More examples (one tool and one real plugin)

* Clone two example projects in AudioDev directory (good for testing)

git clone git@github.com:JoergBitzer/Filtarbor.git
git clone git@github.com:JoergBitzer/DebugAudioWriter.git

All new plugins have their own sub_dir

AudioDev
    | AudioDevOrga
    | CrossPlugInTest
    | DebugAudioWriter
    | Filtabor
    | JUCE
    | Libs
    | ----| eigen
    | ----| TGMTools
    CMakeLists.txt

* change CMakeLists.txt (add add_subdirectory)
* build everything with cmake toolchain

