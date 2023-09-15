# A simpe Gain Plugin: Zweiter Teil 

## Glättung (Smoothing) von Parametern
Das Glätten von Parametern ist notwendig um Clicks und Glitches zu vermeiden. Auf welcher Ebene und in welchem Interval man dies tut, hängt nur vom Problem ab und muss immer wieder ausprobiert werden. 

### Ursache und Lösungen:

Das Problem ist, dass ein abruptes Umschalten (zB Automation) zu Diskontinuitäten im Audio-Ausgang führen kann. Es entstehen Sprünge, die als Clicks hörbar sind. Aber auch ein sanftes Faden von Hand der Parameter kann zu Clicks führen. Hier ist das Problem die interne Blockverarbeitung. Die Parameter werden oft nur an den Blockgrenzen erneuert. Dies führt dann an den Blockgrenzen (gegeben vom Host/DAW) zu kleineren Sprüngen, die oft als leises Kratzen/Crackles wahrgenommen werden. Um dies zu verhindern, kann man die interne Blockgrößen verkleinern, zB auf 16 Samples oder man interpoliert die Parameter pro Sample (oder alle 2,4,8 usw). 

### Lösung in Juce
Das gute ist, Juce bietet für die Glättung eines Einzahlparameters bereits eine Lösung an. Hierbei ist ein lineares und logarithmisches Glätten möglich. Dies ist nicht für alle Probleme eine Lösung und kann auch im Sinne der Rechenleistung zu teuer sein. Die benötigten Klassen sind
```cpp
juce::SmoothedValue<float,juce::ValueSmoothingTypes::Linear>  //linear
juce::SmoothedValue<float,juce::ValueSmoothingTypes::Multiplicative>   //log (muss immer groesser Null sein)
```

### Programmierung in Processor.h/cpp

1. Im Header die Smoothing Klasse hinzufügen. 
```cpp
#include "JuceHeader.h" // muss nach ganz oben ins File

// unten bei private    
    float m_gain = 1.f;
    // juce::LinearSmoothedValue <float> m_smoothedGain;
    juce::SmoothedValue<float,juce::ValueSmoothingTypes::Multiplicative> m_smoothedGain;
```

2. Reset und richtig initialisieren
Erst ab prepareToPLay (Wird immer zum Start von Audio vom Host/DAW aufgerufen) ist die Samplingrate und die maximale Blockgröße bekannt (Diese kann auch kleiner sein, zB wenn die DAW im Loop Modus ist. Es gibt hier keine Grenzen. Eine DAW könnte auch processBlock pro Sample aufrufen). Zum testen setzen wir die Smoothingzeit extrem hoch auf 2.050 Sekunden. 50ms (Also ohne die 2 vorne) sind eigentlich genug. 
```cpp
void AudioPluginAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    m_smoothedGain.reset(sampleRate,2.05); // 50ms is enough for a smooth gain, 
```

3. In der processBlock Routine das Smoothing auf Sample-Ebene ermöglichen
Zunächst wird der Zielwert pro Block (Aufruf von processBlock) gesetzt. Anschließend pro Sample geglättet.
Das Problem ist, dass es mehrere Kanäle geben kann. Der Gain darf aber nur einmal erneuert (getNextValue) werden.
```cpp
    m_smoothedGain.setTargetValue(m_gain);
    float curGain;
    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer (channel);
        // ..do something to the data...
        for (int kk = 0; kk < NrOfSamples; ++kk)
        {
            if (channel == 0)
                curGain = m_smoothedGain.getNextValue();
            channelData[kk] *= curGain;
        }
    }
```
4. ACHTUNG: Dies ist eine teure Art der Glättung (pro Sample) und ist meist nicht notwendig (für Gains schon). Man sollte immer über Alternativen nachdenken. Manchmal ist es notwendig, das Ausgangs-Audiosignale überzublenden, also das Audio vor uns nach dem Parameterwechsel zu berechnen und dann ein Crossfade durchführen. Auch teuer, aber immer Clickfrei, wenn die Crossfadezeit groß genu gewählt wird (zB 50-100 ms)

5. Wir werden hierzu noch Alternativen kennenlernen, wenn wir auf die Template Lösung wechseln. Diese basiert auf eine Zerlegung der Eingangsblöcke in definierte gleich große Audioblöcke (zb 32 Samples) und dann der Nutzung der Funktionen des AudioBuffers von JUCE (applyRamp ist eine gute Idee hier).









