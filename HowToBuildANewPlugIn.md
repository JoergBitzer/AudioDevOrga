# How to build a new plugin
(Second Read after installReadMe)
## Prerequisites
* think about what you want to achieve (effect, instrument, GUI draft, Name)
* (With Github, recommended) Create a new Repository and clone this repository into the directory AudioDev
* (Without GitHub) Create a new subdirectory with the name of your new plugin

## Start (OldTemplate)
* Copy *.cpp *.h and CMakeLists.txt from the Template (https://github.com/JoergBitzer/AudioDevTemplate) into the newly created directory
* rename all instances of Template***** in CMakeLists.txt, processor und Editor cpp and h file into your Pluginname (e.g. with (linux) sed -i 's/Template/YourPlugInName/g' *.* ). You can use Visual Studio Code for this as an alternative. (Only open the five files, and use Crtl+Shift+h (replace in files). The option search in open files only should be on.)
* Change CMakeLists.txt file accordingly (set Name, kind of effect etc.)
* Add your new subdirectory to the CMakeLists.txt in AudioDev (add_subdirectory(YourNewDirectory))

## Start (AdvancedAudioTemplate)
1. Create a new directory (better create a new repository in GitHub)
2. (if Github): Checkout your new project
3. copy template files (https://github.com/JoergBitzer/AdvancedAudioTemplate)
4. rename all instances of "YourPluginName" in the Files with something appropriate 
    use a renaming-tool like   
```console    
    sed -i 's/YourPluginName/YourNewProjectName/g' *.*
```    
for MacOS (https://stackoverflow.com/questions/4247068/sed-command-with-i-option-failing-on-mac-but-works-on-linux)
for Windows: (https://stackoverflow.com/questions/17144355/how-can-i-replace-every-occurrence-of-a-string-in-a-file-with-powershell)  (for multiple files the solution is further down) or start the windows subsystem for linux

5. Rename YourPluginName.cpp and YourPluginName.h into YourNewProjectName.cpp and YourNewProjectName.h (e.g. Linux: 
```console    
    rename 's/YourPluginName/YourNewProjectName/' *.*     
```    
6. Add your new subdiretory to the main CMakeLists.txt (in main directory AudioDev) file
7. Change CMakeLists.txt file accordingly (set Name, kind of effect etc.)
8. add or remove add_compile_definitions to your intention (Do you need a preset manager (default is yes), 
                                                            Do you need a midi-keyboard display (default is no)) 
10. Start coding your plugin (have the solution (math) before that) 


## Coding
* Solve your real problems first (Do you understand the math and concepts of your idea? Are you able to implement that? Build prototypes in Matlab/Python if necessary)
* Divide and Conquer (Build sub-problems) 
* Think about testing (Do you need small test applications (small command line programs))
* Make your feature list (What are the core features? How do you want to start?) Get a working system early on and redesign (if necessary) later. Don't be shy to throw away everything, if you find a better idea to implement things.
* Build your plugin often and test every new feature extensively.
* Don't forget to commit often.
