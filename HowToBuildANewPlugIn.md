# How to build a new plugin
(Second Read after installReadMe)
## Prerequisites
* think about what you want to achieve (effect, instrument, GUI draft, Name)
* (Without GitHub) Create a new subdirectory with the name of your new plugin
* (With Github) Create a new Repository and clone this repository into the directory AudioDev

## Start
* Copy *.cpp *.h and CMakeLists.txt from the Template into the newly created directory
* Change CMakeLists.txt file accordingly (set Name, kind of effect etc.)
* rename all instances of AudioTemplate***** in processor und Editor cpp and h file into your Pluginname
* Add your new subdirectory to the CMakeLists.txt in AudioDev

## Coding
* Solve your real problems first (Do you understand the math and concepts of your idea? Are you able to implement that? Build prototypes in Matlab/Python if necessary)
* Divide and Conquer (Build sub-problems) 
* Think about testing (Do you need small test applications (small command line programs))
* Make your feature list (What are the core features? How do you want to start?) Get a working system early on and redesign (if necessary) later. Don't be shy to throw away everything, if you find a better idea to implement things.
* Build your plugin often and test every new feature extensively.
