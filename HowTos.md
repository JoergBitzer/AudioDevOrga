

### How to build installer

??? CPack??
 https://docs.juce.com/master/tutorial_app_plugin_packaging.html

 
 ### How to have preprocessor defines 

 https://cmake.org/cmake/help/latest/command/add_compile_definitions.html#command:add_compile_definitions

### How to add OpenGL 

You have to add  juce::juce_opengl  in 
target_link_libraries( ) im Projekt CMakeLists.txt File

Dies scheint immer zu gelten (Die richtige Lib dazu packen), wenn man nicht nur die Standard JUCE Sachen verwendet. 


### How to make plattform spefic code (file names for example)

from https://stackoverflow.com/questions/5919996/how-to-detect-reliably-mac-os-x-ios-linux-windows-in-c-preprocessor

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
   //define something for Windows (32-bit and 64-bit, this part is common)
   #ifdef _WIN64
      //define something for Windows (64-bit only)
   #else
      //define something for Windows (32-bit only)
   #endif
#elif __APPLE__
    #include <TargetConditionals.h>
    #if TARGET_IPHONE_SIMULATOR
         // iOS Simulator
    #elif TARGET_OS_IPHONE
        // iOS device
    #elif TARGET_OS_MAC
        // Other kinds of Mac OS
    #else
    #   error "Unknown Apple platform"
    #endif
#elif __linux__
    // linux
#elif __unix__ // all unices not caught above
    // Unix
#elif defined(_POSIX_VERSION)
    // POSIX
#else
    #error "Unknown compiler"
#endif



### More CMAKE
https://mirkokiefer.com/cmake-by-example-f95eb47d45b1

präprozessor definitions
https://cmake.org/cmake/help/latest/command/add_compile_definitions.html#command:add_compile_definitions



### Additional things:

    JUCE_DISPLAY_SPLASH_SCREEN=0
    JUCE_REPORT_APP_USAGE=0

    in 

    target_compile_definitions(tuning-workbench-synth PUBLIC



    VST3_CATEGORIES "Fx" 
    AU_MAIN_TYPE "kAudioUnitType_Effect"

    in

    juce_add_plugin


    How to use VSCode

    https://github.com/tomoyanonymous/juce_cmake_vscode_example

    Testing in Github

    https://github.com/sudara/pamplejuce


