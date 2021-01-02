# Plugin Development with CMAKE for all plattforms (install help)

## installing the basic tools

* Windows:
    0. Install compiler (I would use Visual Studio 2019)
    1. Install git (use gitbash)
    2. Install CMAKE (dont forget to select option use PATH for alle users)

* Apple:
    0. Install compiler (I would use Xcode)
    1. Install git (if not installed)
    2. Install CMAKE (dont forget to add the path to terminal, e.g 
    ```console 
    ```
    sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install

* Linux:
    0. Check installed compiler version (gcc -v should be > 9.0), if not install it
    1. check if git is available (git --version), if not install it
    2. check if CMAKE is avaliable (cmake --version should be > 3.15), if not install it
    3. install editor (I suggest Visual Studio Code)

## install audio plugin development framework

Several plattform independent frameworks are available
I would use JUCE (www.juce.com)

To prevent to many files cluttering around, start with e new subdirectory
e.g. AudioDev 

Inside AudioDev. clone JUCE from https://github.com/juce-framework/JUCE


## Test the toolchain so far
    From JUCE REadme.md
    cd /path/to/JUCE
    cmake . -B cmake-build -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON
    cmake --build cmake-build --target DemoRunner
    cmake --build cmake-build --target AudioPluginHost
    cmake --build cmake-build --target Projucer



## Find a plugin host

1. You can build the pluginhost from JUCE (or did it already in the test)
2. Find other suitable hosts:
    * Windows: 
        * Reaper (cost 60$)
        * Cubase SE (cost 50$)
    * Linux: 
        * Reaper (cost 60$)
    * Apple:
        * Reaper (cost 60$)








## copy the vst to the right directory

* Linux: home/.vst/
* Windows: prgram Files/VST (???)
* Apple: ???

