# Add a Console Test Application with JUCE components

Usually you should write test functions (mainly math) in a small test application. Often these test application are simple console programs with a CLI (Command Line Interface)

## Prepare your directory

Assuming you have your top directory AudioDev and in it the top CMakeLists.txt.
For your test routines you should add a new subdirectory tester and in it subdirectories for each test.

AudioDev
    CMakeLists.txt

    | tester

        | myFirstTest

        | mySecondTest

## Simple test or development function without any JUCE specifics

1. Create a file with a main function (e.g. miniTestAppMain.cpp )
2. Create or add your header / function to be testes and use it correctly (miniFunctionToBeTested.cpp and miniFunctionToBeTested.h)
3. Add the necessary files to a small CMakeLists.txt file.

e.g.
```cmake
    cmake_minimum_required (VERSION 3.22)
    project (MiniTestApp)

    add_executable(MiniTestApp miniTestAppMain.cpp miniFunctionToBeTested.cpp)
```
4. Save the file and add the new subdirectory to the top level CMakeLists.txt file (The one in the AudioDev directory)

```cmake
    add_subdirectory(tester/myFirstTest)
```


## and with JUCE specifics

Lets start with a simple Example. We want to test the JUCE AudioBuffer Class in a simple Gain function (I know that AudioBuffer have this functionalty, its just for the demonstration). Our main.cpp would look like this without the JUCE specifics

Add a subfolder in tester with the name gaintester. 

Create an empty main.cpp file

```cpp
#include <iostream>

void changeGain (juce::AudioBuffer<float> &data, float gain_lin)
{
    for (auto cc = 0; cc < data.getNumChannels(); ++cc)   
    {
        float *onechanneldata = data.getWritePointer(cc);
        for (auto kk = 0; kk < data.getNumSamples(); ++kk)
        {
            *onechanneldata *= gain_lin;
            onechanneldata++;
        }
    }
}

int main()
{
    juce::AudioBuffer<float> buffer;
    // set arbitrary size
    buffer.setSize(2,200);
    float gain = 2.f;
    // set all data to 1.f
    for (auto cc = 0; cc < buffer.getNumChannels(); ++cc)   
    {
        float *onechanneldata = buffer.getWritePointer(cc);
        for (auto kk = 0; kk < buffer.getNumSamples(); ++kk)
        {
            *onechanneldata = 1.f;
            onechanneldata++;
        }
    }
    // call function
    changeGain(buffer,gain);
    
    // check result
    bool bOK = true;
    for (auto cc = 0; cc < buffer.getNumChannels(); ++cc)   
    {
        float *onechanneldata = buffer.getWritePointer(cc);
        for (auto kk = 0; kk < buffer.getNumSamples(); ++kk)
        {
            if (*onechanneldata != gain)
            {
                std::cout << "test failed";
                bOK = false;
            }
            onechanneldata++;
        }
    }
    if (bOK)
        std::cout << "Test successful";

    return bOK;
}

```

This code will have a lot o errors or unknown variables, since JUCE is not known at this point.

## Add a new CMakeLists.txt for your new test

JUCE has a mechanism for console applications. You can find examples in the example directory for CMAKE.

For our example , put a new CMakeLists.txt in your new subfolder (e.g /AudioDev/tester/gaintester)

Here is an example for the AudioBufferTest

```cmake
cmake_minimum_required(VERSION 3.22)
project(AudioBufferTest VERSION 0.1.0)

juce_add_console_app(AudioBufferTest
    PRODUCT_NAME "AudioBufferTestName")     

# JuceHeader is to include all the JUCE module headers for a particular target; if you're happy to
# include module headers directly, you probably don't need to call this.
# juce_generate_juce_header(ConsoleAppExample)

# Add the list of your necessary cpp files (Here its just main.cpp)
target_sources(AudioBufferTest
    PRIVATE
        main.cpp)


target_compile_definitions(AudioBufferTest
    PRIVATE
        # JUCE_WEB_BROWSER and JUCE_USE_CURL would be on by default, but you might not need them.
        JUCE_WEB_BROWSER=0  
        JUCE_USE_CURL=0)    

# if you need any modules from JUCE add them here
target_link_libraries(AudioBufferTest
    PRIVATE
        juce::juce_core # e.g. to use jassert
        juce::juce_audio_basics # e.g. to use AudioBuffer
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_warning_flags)

```

Save the file and add the new subdirectory to the top level CMakeLists.txt file (The one in the AudioDev directory)

```cmake
    add_subdirectory(tester/gaintester)
```

Save the file, the new build environment is build.

## add the necessary module header files 

The final step is to add the header files from the necessary JUCE-modules to main.cpp. Of course in real world development, you would start with this step.

```cpp
#include <iostream>
#include <juce_core/juce_core.h>
#include <juce_audio_basics/juce_audio_basics.h>
```

Now you can use all the features from these two JUCE modules. Auto completion should work fine.


