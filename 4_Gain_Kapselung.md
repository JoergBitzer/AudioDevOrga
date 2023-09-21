# Gain als KLasse

## Warum?
Für ein einfaches Gain eine eigene KLasse zu bauen, bzw. 2 KLassen (AudioProcessing, GUI) ist normalerweise Overkill. 
Hier geht es darum zu lernen, wie wir ab jetzt Audio Plugins programmieren. Dies ist nur eine Möglichkeit von vielen und ich bin sicher, bestimmte Aspekte könnte man noch besser lösen. 

## Anzahl Dateien
Traditionell würde man 4 Dateien aufbauen (2 cpp, 2 header). Für mich hat sich herausgestellt, dass eine cpp Datei und ein Header ausreicht und alles besser zusammenhält. Welchen Weg Ihr gehen wollt, ist Eure Entscheidung.

## Prädefinition der Parameter
Die Rahmenparameter (ID, Namen, Min, Max usw) werden im AudioProcessor und in der GUI gebraucht. Es ist deshalb sinnvoll ein globales 
struct zur Parameterdefinition aufzubauen, zB 
```cpp
const struct
{
	const std::string ID = "Gain";
	std::string name = "Gain";
	std::string unitName = "dB";
	float minValue = -90.f;
	float maxValue = 20.f;
	float defaultValue = 0.f;
}g_paramGain;

```
und dieses im Header zu nutzen
## KLassendefinition und Deklaration

Zunächst werden 2 KLassen benötigt. Diese definieren wir im Header. Dieser beginnt immer mit einem [include-guard](https://en.wikipedia.org/wiki/Include_guard). Wir nutzen hier die Erweiterung mit pragma, die auch von anderen Compilern verstanden wird. Die GUI KLasse sollte als [Juce Component] (https://docs.juce.com/master/tutorial_main_component.html) aufgebaut werden.
```cpp
#pragma once  //include guard

class GainAudioProcessor
{

};
class GainEditor : public juce::Component
{

};
```

Wann immer wir etwas mit Audiosignalverarbeitung programmieren, benötigen wir typischerweise mindestens 3 Funktionen + Konstruktor. Im Konstruktor setzen wir alle Variablen. Weiterhin brauchen wir eine Funktion die alles vorbereitet (diese Funktion kennt die sampling rate, die maximale Blockgröße und die Anzahl der Kanäle). Dies ist der letzte Moment zu dem wir noch Speicher allokieren dürfen. In Juce heißt diese Funktion prepareToPlay und das übernehmen wir. Dann muss es eine Funktion geben, die das eigentliche Processing übernimmt. In Juce ist das processBlock. Zusätzlich, also optional, sollte es eine Funktion geben, die das Processing abschließt. in Juce ist das die Funktion releaseResources. Und ich empfehle immer eine reset() - Funktion zu implementieren. 
Damit das Juce-Parameterhanding funktioniert, braucht die Klasse zusätzlich zwei Funktionen um den Parameter zu der Parameterliste hinzuzufügen und eine Referenz auf den AudioProcessorValueTreeState.

Somit ergibt sich für eine einfache Gain Klasse.
```cpp
#pragma once
#include <vector>
#include <juce_audio_processors/juce_audio_processors.h>

class GainAudioProcessor
{
public:
    GainAudioProcessor();
    void prepareToPlay(float sampleRate);
    void processBlock(juce::AudioBuffer<float>& data);
  	void addParameter(std::vector < std::unique_ptr<juce::RangedAudioParameter>>& paramVector);
    void prepareParameter(std::unique_ptr<juce::AudioProcessorValueTreeState>&  vts);

```
Als interne Parameter benötigen wir (siehe vorherige Lösung)

```cpp
private:
    float m_gain = 1.f;
    std::atomic<float>* m_gainParam = nullptr; 
    float m_gainParamOld = std::numeric_limits<float>::min(); //smallest possible number, will change in the first block
    juce::SmoothedValue<float,juce::ValueSmoothingTypes::Multiplicative> m_smoothedGain;

```

Die Implementierung im cpp file sieht dann folgendermaßen aus und ist im Grunde Copy und Paste aus dem alten PluginProcessor.cpp

```cpp

GainAudioProcessor::GainAudioProcessor()
{

}
void GainAudioProcessor::prepareToPlay(float sampleRate)
{
    m_smoothedGain.reset(sampleRate,0.01); // 100ms is enough for a smooth gain, 

}
void GainAudioProcessor::processBlock(juce::AudioBuffer<float>& data)
{
    // check parameter update
    if (*m_gainParam != m_gainParamOld)
    {
        m_gainParamOld = *m_gainParam;
        m_gain = powf(10.f,m_gainParamOld/20.f);
    }

    juce::ScopedNoDenormals noDenormals;
    
    int NrOfSamples = data.getNumSamples();
    int chns = data.getNumChannels();

    m_smoothedGain.setTargetValue(m_gain);
    float curGain;
    for (int channel = 0; channel < chns; ++channel)
    {
        auto* channelData = data.getWritePointer (channel);
        // ..do something to the data...
        for (int kk = 0; kk < NrOfSamples; ++kk)
        {
            if (channel == 0)
                curGain = m_smoothedGain.getNextValue();
            channelData[kk] *= curGain;
        }
    }

}
void GainAudioProcessor::addParameter(std::vector < std::unique_ptr<juce::RangedAudioParameter>>& paramVector)
{
    paramVector.push_back(std::make_unique<juce::AudioParameterFloat>(g_paramGain.ID,            // parameterID
                                                        g_paramGain.name,            // parameter name
                                                        g_paramGain.minValue,              // minimum value
                                                        g_paramGain.maxValue,              // maximum value
                                                        g_paramGain.defaultValue));

}
void GainAudioProcessor::prepareParameter(std::unique_ptr<juce::AudioProcessorValueTreeState>&  vts)
{
    m_gainParam = vts->getRawParameterValue(g_paramGain.ID);
}
```
## Umbau PluginProcessror.cpp

Das sollte man nun testen, indem wir diese KLasse nun im PluginProcessor.h/cpp nutzen.

Im Header heißt das viel löschen und oben die neue KLasse includen. Achtung hier sind viele Zeilen ausgelassen

```cpp
#include "GainAudioProcessor.h"

und 

private:
    GainAudioProcessor m_gain;

```
Die Änderungen in der cpp Datei sind etwas umfangreicher:

Im Konstruktor
```cpp
{
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;

    m_gain.addParameter(params);

    m_parameterVTS = std::make_unique<juce::AudioProcessorValueTreeState>(*this, nullptr, juce::Identifier("GainVTS"),
                                                            juce::AudioProcessorValueTreeState::ParameterLayout(params.begin(), params.end()));

    m_gain.prepareParameter(m_parameterVTS);

}
```

In prepareToPlay


```cpp
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..
    juce::ignoreUnused (samplesPerBlock);
    m_gain.prepareToPlay(sampleRate);
}

```

und in processBlock
```cpp
{
    juce::ignoreUnused (midiMessages);

    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    m_gain.processBlock(buffer);
}
```

## Aufbau Component
Für ein neues Component müssen nur wenige Funktionen implementiert werden. Die KLassendeklaration könnte folgendermaßen aussehen:
Wichtig ist dass die Methden paint und resized überladen werden. Der Rest ist mehr oder minder aus dem Editor für das letzte Gain Projekt übernommen. 
```cpp
class GainComponent : public juce::Component
{
public:
	GainComponent(juce::AudioProcessorValueTreeState& apvts);

	void paint(juce::Graphics& g) override;
	void resized() override;
private:
    //juce::Label m_GainLabel;
    juce::Slider m_GainSlider;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> m_GainAttachment;
};
```
Die cpp Datei sieht wie folgt aus: 
```cpp
GainComponent::GainComponent(juce::AudioProcessorValueTreeState& apvts)
{
	// m_GainLabel.setText(g_paramGain.name, juce::NotificationType::dontSendNotification);
	// m_GainLabel.setJustificationType(juce::Justification::centred);
	// m_GainLabel.attachToComponent (&m_GainSlider, false);
	// addAndMakeVisible(m_GainLabel);

    m_GainSlider.setRange (g_paramGain.minValue, g_paramGain.maxValue);         
    m_GainSlider.setTextValueSuffix (g_paramGain.unitName);    
    m_GainSlider.setSliderStyle(juce::Slider::LinearVertical);
    m_GainSlider.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxAbove, true, 60, 20);
    m_GainSlider.setValue(g_paramGain.defaultValue);
	m_GainAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(apvts, g_paramGain.ID, m_GainSlider);
	addAndMakeVisible(m_GainSlider);
}

void GainComponent::paint(juce::Graphics& g)
{
	g.fillAll(juce::Colour::fromRGB(50,50,50).brighter(0.2));
}
void GainComponent::resized()
{
	auto r = getLocalBounds();
	m_GainSlider.setBounds(r);
	//m_GainSlider.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true,);

}
```
Der Konstruktor wird fast vollständig übernommen und nur bezüglich der Nutzung des g_paramGain Structs angepasst. Die paint Funktion zeichnet den Hintergrund nur etwas heller als beim Editor. Im Editor werden wir das neue Gain GUI-Element etwas kleiner einblenden und so den Effekt davon sehen. Die Größe des Elements soll vollständig durch den Editor bestimmt sein, also wird die gesamte zur Verfügung stehende Fläche verwendet. Hätte man mehrere Parameter könnte man hier das Layout gestalten (z.B. bei einer ADSR-Envelope mit den vier typischen Parametern).

## Anpassung im Editor

Im Header muss das neue Element als Member-Element definiert werden. Achtung: Die Reihenfolge ist hier wichtig.
```cpp
private:
    AudioPluginAudioProcessor& processorRef;
    GainComponent m_gainslider;
```

im Konstruktor erfolgt die Initialisierung des GUI Elements in der Prä-ambel. ZUsätzlich muss das neue Element zum Editor hinzugefügt werden.
```cpp
AudioPluginAudioProcessorEditor::AudioPluginAudioProcessorEditor (AudioPluginAudioProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p), m_gainslider(*processorRef.m_parameterVTS)
{
    setSize (150, 300);
    addAndMakeVisible(m_gainslider);
}
```
Wichtig ist nun noch in der resized Funktion das neue Element zu platzieren. In diesem Fall mit einem Rand von 5 Pixeln.
```cpp
void AudioPluginAudioProcessorEditor::resized()
{
    auto r = getLocalBounds();
    int border_reduction = 5;
	m_gainslider.setBounds(r.getX() + border_reduction, r.getY() + border_reduction, 
                            getWidth()-2*border_reduction, getHeight()-2*border_reduction);
}
```


