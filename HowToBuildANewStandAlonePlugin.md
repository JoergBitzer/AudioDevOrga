# How to build a new plugin that is independent from the structure so far

The goal of this tutorial is to build plugins that will be published in open source form. In contrast to the sources so far, this plugin should be self-contained and therefore a simple clone and build should be enough to get exactly the plugin, you want to have. 
This leads to some differences in the directory structure and how to develop things.

You should use this tutorial after you had at least some ideas how git, c++ and vst plugin development work. I recommenned that you have at least build some EQs and / or one or two other plugins with my standard way to things (See HowToBuildANewPlugin.md). 

## Prerequisites
* think about what you want to achieve (effect, instrument, GUI draft, Name). Thinkk before you code is always a good idea,
* (With Github, recommended) Create a new Repository (with ReadMe, LICENSE and .gitignore for C++) (That is why you should have a name) and clone this repository into a new directory for example AudioDev2
* Change to this directory and add JUCE as a submodule
``` bash
    git submodule add https://github.com/juce-framework/JUCE.git
```
* (Without GitHub) Create a new subdirectory with the name of your new plugin
* Add *build* as a directory to .gitignore (cmake will build now in your plugin subdiretory) 
* Copy the CMakeLists.txt from this directory to this directory. Your directory structure should look like this
  
  AudioDev2
    MyBombastPLugin
        MyBombastPLugin (empty dir)
        JUCE (as a submodule)
        .gitignore (from your repo build in Github)
        .gitmodules (from you git submodule add)
        CMakeLists.txt (the file you just copied from here)
        LICENSE (from your repo build in Github)
        ReadMe.md (from your repo build in Github)

* Add your plugin directory to the CMakeLists.txt file (e.g. add_subdirectory(MyBombastPLugin))
* commit your changes and push. (You are ready to start your new plugin)

## Start the new plugin using the tools we provide (easier start) (AdvancedAudioTemplate (AAT))
1. copy the AAT template files, after cloning the git repository (https://github.com/JoergBitzer/AdvancedAudioTemplate) to some other directory (perhaps you have this repo already in AudioDev)
(This contains the diretory tools, CMakeLists.txt and all *.cpp and *.h files. You should ignore the ReadMe.md, the .gitignore and the LICENSE file)

2. rename all instances of "YourPluginName" in the Files with something appropriate. 
    The easiest way is to use Visual Studio Code for this  (Click on the new directory and press Crtl+Shift+h (replace in files). Search for *YourPluginName* and replace it with YourNewProjectName (e.g. Bombast). You can check all renamed instances before you press replace all (this is not necessary, but perhaps instructive) )
    As an alternative use a renaming-tool like (Linux only)   
```console    
    sed -i 's/YourPluginName/YourNewProjectName/g' *.*
```    
for MacOS (https://stackoverflow.com/questions/4247068/sed-command-with-i-option-failing-on-mac-but-works-on-linux)
for Windows: (https://stackoverflow.com/questions/17144355/how-can-i-replace-every-occurrence-of-a-string-in-a-file-with-powershell)  (for multiple files the solution is further down) or start the windows subsystem for linux

1. Rename YourPluginName.cpp and YourPluginName.h into YourNewProjectName.cpp and YourNewProjectName.h (e.g. Bombast.cpp and Bombast.h) (press F2 in the Explorer Window of Visual Studio Code and do it per hand) or use a file renaming tool (e.g. Linux: 
```console    
    rename 's/YourPluginName/YourNewProjectName/' *.*     
```    
1. Change CMakeLists.txt file accordingly (set Name, kind of effect etc.)
2. add or remove add_compile_definitions to your intention (Do you need a preset manager (default is yes), 
                                                            Do you need a midi-keyboard display (default is no)) 
3.  Start coding your plugin (have the solution (math) or main idea solved before that, e.g. using python as a prototype language) 


## Coding
* Solve your real problems first (Do you understand the math and concepts of your idea? Are you able to implement that? Build prototypes in Matlab/Python if necessary)
* Divide and Conquer (Build sub-problems) 
* Think about testing (Do you need small test applications (small command line programs))
* Make your feature list (What are the core features? How do you want to start?) Get a working system early on and redesign (if necessary) later. Don't be shy to throw away everything, if you find a better idea to implement things.
* Build your plugin often and test every new feature extensively (Think about UnitTests).
* Don't forget to commit often. If you collaberate or you try something slightly dangerous (in the sense, bigger changes in your code base), use git branches for developing new features (perhaps a good idea in general).
