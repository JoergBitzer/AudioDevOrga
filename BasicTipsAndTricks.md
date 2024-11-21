# Audio Thread

## Avoid

* mutex/criticalSections 
* allocation of memory
* network or disk usage

Why?: Because you may introduce audio glitches 


## Think about

### Independence of sampling rate and block size

Your goal is that your plugin will sound equal on all plattforms, independent of the audio blocksize or the sampling rate.

Unfortunately the input blocksize of one audio block can vary from 1 Sample to Max Sample, where Max is set in PrepareToPlay. Think about your own synchronous block of a fix length.


# GUI

As usual: form follows function

## Use the JUCE forum
I found this useful for Choice Parameter
https://forum.juce.com/t/mapping-a-audioparameterchoice-to-a-radio-button-group-sensecheck/18760

and
https://forum.juce.com/t/parameterchoicecombobox-implementation/16470/7


# Development

## math problems 

solve your math problems before you start development. Use Python/Matlab for rapid prototyping.

