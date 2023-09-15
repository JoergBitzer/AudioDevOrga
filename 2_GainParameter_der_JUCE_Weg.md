# Gain Plugin mit JUCE Parametern

## Echte Parameter
Paramter-Handling ist eins der komplexesten Probleme bei der Audio Plugin Programmierung. Vor allem bei vielen Parametern verliert man leicht den Überblick und es führt eigentlich immer zu Spaghetti-Code (Schaut Euch einfach einige der frei zugänglichen Repositories an. Parameter sind fast immer schwer zu verfolgen.).
Zusätzlich haben Parameteränderungen mindestens zwei Quellen, den User durch die GUI und den Host/DAW durch die Automation. Zusätzlich kann man auch noch eine Midi-Steuerung über CC einbauen. Die GUI muss immer den aktuellen Wert anzeigen und die eigentliche Audioberechnung sollte auch immer mit den aktuell gültigen Parametern arbeiten. 

### Lösung in JUCE
JUCE bietet für dieses Problem und noch einige mehr (Undo/Redo, Speicherung im Host) eine gute Lösung, die aber in der Bedienung etwas komplizierter ist: AudioProcessorValueTreeState.

### Speichern und Lesens des Plugin Zustandes.
Der AudioProcessor hat für die Herstellung und Speicherung des Zustandes zwei Funtionen:
```cpp
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;
```

Wenn alle Daten in einem ValueTree gespeichert sind, muss nur dieser gespeichert werden. ZUr Umwandlung in ein speicherbares Format und zurück, sind Funktionen vorhanden. Somit reicht folgendes aus. 
Im Header den AudioProcessorValueTree als Zeiger einführen, damit wir beim Layout etwas flexibler sind.
```cpp
std::unique_ptr<AudioProcessorValueTreeState> m_parameterVTS;
```

und dann die folgenden Funktionen füllen: (aus JUCE Tutorien)
```cpp
void TemplateAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
	auto state = m_parameterVTS->copyState();
	std::unique_ptr<XmlElement> xml(state.createXml());
	copyXmlToBinary(*xml, destData);

}
void TemplateAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
 	std::unique_ptr<XmlElement> xmlState(getXmlFromBinary(data, sizeInBytes));

	if (xmlState.get() != nullptr)
		if (xmlState->hasTagName(m_parameterVTS->state.getType()))
        {
            ValueTree vt = ValueTree::fromXml(*xmlState);
			m_parameterVTS->replaceState(vt);
        }
}
```

Der Vorteil dieser Lösung ist, das wirklich alle Parameter immer gespeichert sind. 

## Aufbau der Parameter in APVTS 

Jeder Parameter hat eine Vielzahl von notwendigen Informationen. Diese können direkt übergeben werden (So oft in den Tutorien zu sehen, zb Hier: https://docs.juce.com/master/tutorial_audio_processor_value_tree_state.html)

Der flexiblere Weg ist aber zunächst ein AudioProcessorValueTreeState::ParameterLayout zu füllen und anschließend den Konstruktor des APVTS aufzurufen. Für unser Gain wäre dies:
```cpp




```



