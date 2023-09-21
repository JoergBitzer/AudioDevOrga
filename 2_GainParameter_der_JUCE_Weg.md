# Gain Plugin mit JUCE Parametern

## Echte Parameter
Parameter-Handling ist eins der komplexesten Probleme bei der Audio Plugin Programmierung. Vor allem bei vielen Parametern verliert man leicht den Überblick und es führt eigentlich immer zu Spaghetti-Code (Schaut Euch einfach einige der frei zugänglichen Repositories an. Parameter sind fast immer schwer zu verfolgen.).
Zusätzlich haben Parameteränderungen mindestens zwei Quellen, den User durch die GUI und den Host/DAW durch die Automation. Zusätzlich kann man auch noch eine Midi-Steuerung über CC einbauen. Die GUI muss immer den aktuellen Wert anzeigen und die eigentliche Audioberechnung sollte auch immer mit den aktuell gültigen Parametern arbeiten. 

### Lösung in JUCE
JUCE bietet für dieses Problem und noch einige mehr (Undo/Redo, Speicherung im Host) eine gute Lösung, die aber in der Bedienung etwas komplizierter ist: AudioProcessorValueTreeState. Diese Struktur kann alle Parameter aufnehmen und automatisiert die Datenweitergabe.

### Speichern und Lesens des Plugin Zustandes.
Der AudioProcessor hat für die Herstellung und Speicherung des Zustandes zwei Funktionen:
```cpp
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;
```

Wenn alle Daten in einem ValueTree gespeichert sind, muss nur dieser gespeichert werden. ZUr Umwandlung in ein speicherbares Format und zurück, sind Funktionen vorhanden. Somit reicht folgendes aus. 
Im Header den AudioProcessorValueTree als Zeiger einführen, damit wir beim Layout etwas flexibler sind. Muss public sein, damit wir darauf auch im Editor zugreifen können (Es gäbe auch alternative Wege). 
```cpp
    std::unique_ptr<juce::AudioProcessorValueTreeState> m_parameterVTS;
```

und dann die folgenden Funktionen füllen: (aus JUCE Tutorien)
```cpp
void TemplateAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
	auto state = m_parameterVTS->copyState();
	std::unique_ptr<juce::XmlElement> xml(state.createXml());
	copyXmlToBinary(*xml, destData);

}
void TemplateAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
 	std::unique_ptr<juce::XmlElement> xmlState(getXmlFromBinary(data, sizeInBytes));

	if (xmlState.get() != nullptr)
		if (xmlState->hasTagName(m_parameterVTS->state.getType()))
        {
            juce::ValueTree vt = juce::ValueTree::fromXml(*xmlState);
			m_parameterVTS->replaceState(vt);
        }
}
```

Der Vorteil dieser Lösung ist, das wirklich alle Parameter immer gespeichert sind. Diesen Code werden wir in einem zukünftigen Template übernehmen.

## Aufbau der Parameter in APVTS 

Jeder Parameter hat eine Vielzahl von notwendigen Informationen. Diese können direkt übergeben werden (So oft in den Tutorien zu sehen, zb Hier: https://docs.juce.com/master/tutorial_audio_processor_value_tree_state.html)

Der flexiblere Weg ist aber zunächst einen Vector mit juce::RangedAudioParameter zu füllen und anschließend den Konstruktor des APVTS aufzurufen.
RangedAudioParameter können AudioParameterFloat, AudioParameterBool, AudioParameterInt, AudioParameterChoice sein. Am Häufigsten benötigt man floats.

Für unser Gain wäre dies:
```cpp
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;

    params.push_back(std::make_unique<juce::AudioParameterFloat>("gain",            // parameterID
                                                        "Gain",            // parameter name
                                                         -80.0f,              // minimum value
                                                         20.0f,              // maximum value
                                                         0.f));              // default value
    m_parameterVTS = std::make_unique<juce::AudioProcessorValueTreeState>(*this, nullptr, juce::Identifier("GainVTS"),
                                                            juce::AudioProcessorValueTreeState::ParameterLayout(params.begin(), params.end()));
```

## Datenaustausch zwischen APVTS und Plugin

Es gibt jetzt einen Container mit den Parameters, aber in ProcessBlock darf man keinen Zugriff darauf machen (APVTS ist Thread-safe, aber nicht
Real-time safe). Aus diesem Grund gibt es die Möglichkeit einen Zeiger auf die interne Variable zu bekommen. 
Dazu definieren wir uns diesen Zeiger im Header:
```cpp
    std::atomic<float>* m_gainParam = nullptr; 
```
und holen uns diesen Pointer vom APVTS

```cpp
    m_gainParam = m_parameterVTS->getRawParameterValue("gain");
```

Unser Parameter muss abschließend noch umgerechnet werden in den linearen Wert. Damit wir das nicht immer machen müssen, lohnt es sich abzufragen, ob es überhaupt eine Änderung gegeben hat.

in der processBlock Methode nutzen wir also, vorher aber im header eine Variable für den alten Wert angeben
```cpp
    std::atomic<float>* m_gainParam = nullptr; 
    float m_gainParamOld = std::numeric_limits<float>::min(); //smallest possible number, will change in the first block
```
und diesen nutzen
```cpp
    if (*m_gainParam != m_gainParamOld)
    {
        m_gainParamOld = *m_gainParam;
        m_gain = powf(10.f,m_gainParamOld/20.f);
    }
```

## Datenaustausch zwischen APVTS und GUI
Für den Editor hat JUCE nun eine perfekt einfache Verbindung, die sog Attachments. Im Header vom Editor fügen wir hinzu
```cpp
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> m_gainSLiderAttachment;
```

und im cpp file

```cpp
	m_gainSLiderAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(*processorRef.m_parameterVTS, "gain", m_gainSlider);
```

Das ist alles. JUCE kümmert sich nun darum, dass Änderungen von außen durch Automation die GUI ändert und in processBlock bekommt der eigentliche Prozessor das mit. Und Total Recall funktioniert ab jetzt auch.

## nächste Schritte, verbleibende Probleme
1. Gain knackt, crackelt
2. Gain-Funktion ist nicht gekapselt, sondern in der JUCE Schnittstelle implementiert. Das sollte man vermeiden. Dies gilt für das Audio-Processing, wie auch für die GUI.









