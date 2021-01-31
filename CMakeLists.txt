# Example Audio Plugin CMakeLists.txt

# To get started on a new plugin, copy this entire folder (containing this file and C++ sources) to
# a convenient location, and then start making modifications.

# The first line of any CMake project should be a call to `cmake_minimum_required`, which checks
# that the installed CMake will be able to understand the following CMakeLists, and ensures that
# CMake's behaviour is compatible with the named version. This is a standard CMake command, so more
# information can be found in the CMake docs.

cmake_minimum_required(VERSION 3.15)

# The top-level CMakeLists.txt file for a project must contain a literal, direct call to the
# `project()` command. `project()` sets up some helpful variables that describe source/binary
# directories, and the current project version. This is a standard CMake command.

project(REPOSTART VERSION 0.0.1)
set(CMAKE_CXX_STANDARD 17)

#if build fail, uncomment these lines 
# set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)
# set_property(GLOBAL PROPERTY USE_FOLDERS YES)
# option(JUCE_ENABLE_MODULE_SOURCE_GROUPS "Enable Module Source Groups" ON)



# If you've installed JUCE somehow (via a package manager, or directly using the CMake install
# target), you'll need to tell this project that it depends on the installed copy of JUCE. If you've
# included JUCE directly in your source tree (perhaps as a submodule), you'll need to tell CMake to
# include that subdirectory as part of the build.

# find_package(JUCE CONFIG REQUIRED)        # If you've installed JUCE to your system
# or

#add_compile_definitions(FACTORY_PRESETS)

add_subdirectory(JUCE)                    # If you've put JUCE in a subdirectory called JUCE
include_directories(Libs/TGMTools)
# this is for the eigen library (https://gitlab.com/libeigen/eigen)
include_directories(Libs/eigen;Libs/eigen/unsupported)


file(GLOB TGMLIBCPPS "Libs/TGMTools/*.cpp")

# if you have access zo the vst2.4 sdk (and the license from Steinberg)
# set the path for JUCE
# juce_set_vst2_sdk_path(Libs/vstsdk2.4)
# and add in juce_add_plugin( FORMATS VST ) there should be VST3 AU and Standalone

# Add your projects
# add_subdirectory(CrossPlugInTest)                  
# add_subdirectory(DebugAudioWriter)
# add_subdirectory(Filtarbor)
# add_subdirectory(AudioDevTemplate)
add_subdirectory(EQoder)
