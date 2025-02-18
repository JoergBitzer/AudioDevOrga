# AudioDevOrga
This repository is the starting point to learn plugin development with JUCE.
It is still subject to change (developing phase).

So far:
1. the installation process for the toolchain is described
2. a template is provided (resizable plugin-window and with a preset handler)
3. several examples are provided
4. a tutorial, how to start a new plugin is provided

Missing:
1. improved HowTo.md
2. Some basic DSP tutorials.

# Requirements to learn plugin development

1. Have some basic understanding of C++ (you will learn more during the development process)
2. Have some basic understanding of your tools (compiler (gcc, xCode or VS), git, cmake, editor (e.g. VS Code))
3. Have some basic understanding of the underlying math (digital signal processing).  
4. Understand the legal aspects, if you develop with JUCE

# Start

1. make a new directory (I would recommend just below home (~) or c:/d: ). I usually use AudioDev
2. cd into this directory and clone this repository with (To use this command you need a GitHub Account and SSH connection).:
```console
git clone git@github.com:JoergBitzer/AudioDevOrga.git
```
Alternatevely you can use the http version:
```console 
 git clone https://github.com/JoergBitzer/AudioDevOrga.git
```
3. read ``installReadMe.md``
4. read ``HowToBuildANewPlugIn.md`` if you want to start with your own idea
   or read ``DerStartMitJUCE_Gain1.md`` (German only) to get an idea, how to start with a simple gain plugin.


# Some remarks

1. I am not a professional c++ developer (I was, a long time ago with a focus on signal processing). So, please forgive me, if I am at some points not at the edge of c++ development. My code is developed for learning purposes not optimality. However, the final plugins will be close to a professional level (the audio part, not the GUI). I looked at several books (old and new ones) for audio plugin development. The code style and the algorithms I use, are of better quality and will help you much more.
2. I am sure, lots of people will show you the development process in a different and perhaps better way. However, I assure you, my way will give you some help at the beginning and navigate around some pitfalls on the way, especially if you are interested in platform independent design.
3. Find your own way, how to use tools and how to develop things, but keep an open mind. There is so much to learn.
4. No strings, no costs and no responsibility attached from my side.



