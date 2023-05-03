# How to build a new plugin
(Second Read after installReadMe)
## Prerequisites
* think about what you want to achieve (effect, instrument, GUI draft, Name)
* (Without GitHub) Create a new subdirectory with the name of your new plugin
* (With Github) Create a new Repository and clone this repository into the directory AudioDev

## Start
* Copy *.cpp *.h and CMakeLists.txt from the Template (https://github.com/JoergBitzer/AudioDevTemplate) into the newly created directory
* rename all instances of Template***** in CMakeLists.txt, processor und Editor cpp and h file into your Pluginname (e.g. with (linux) sed -i 's/Template/YourPlugInName/g' *.* ). You can use Visual Studio Code for this as an alternative. (Only open the five files, and use Crtl+Shift+h (replace in files). The option search in open files only should be on.)
* Change CMakeLists.txt file accordingly (set Name, kind of effect etc.)
* Add your new subdirectory to the CMakeLists.txt in AudioDev (add_subdirectory(YourNewDirectory))

## Coding
* Solve your real problems first (Do you understand the math and concepts of your idea? Are you able to implement that? Build prototypes in Matlab/Python if necessary)
* Divide and Conquer (Build sub-problems) 
* Think about testing (Do you need small test applications (small command line programs))
* Make your feature list (What are the core features? How do you want to start?) Get a working system early on and redesign (if necessary) later. Don't be shy to throw away everything, if you find a better idea to implement things.
* Build your plugin often and test every new feature extensively.
* Don't forget to commit often.
