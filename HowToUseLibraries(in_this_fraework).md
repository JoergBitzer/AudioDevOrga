# Work in progress

## Add some necessary libraries (at least for the next examples)

add a subdirectory Libs 


### Add eigen for linear algebra support

1. cd Libs

2. git clone https://gitlab.com/libeigen/eigen.git

### Add TGM Tools (some common files e.g. dsp code or LookAndFeel)

1. cd Libs 

2. git clone git@github.com:JoergBitzer/TGMTools.git

### Change CMakeLists.txt (the one in AudioDev)

uncomment the following lines to include eigen and tgmtools in the build process

include_directories(Libs/TGMTools)
file(GLOB TGMLIBCPPS "Libs/TGMTools/*.cpp")

include_directories(Libs/eigen;Libs/eigen/unsupported)

Your directory structure should look like this


    AudioDev
    | AudioDevOrga
    | CrossDevPlugInTest
    | JUCE
    | Libs
    | ----| Eigen
    | ----| TGMTools


git clone git@github.com:JoergBitzer/Filtarbor.git


