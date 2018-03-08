# ABSpeechSynth ReadMe

## Usage
Declaration:

    let synth = ABSpeechSynth()

Say an utterance:

    synth.speak("Hello World")

## Handling multiple requests

Let's say you've got a bunch of utterances you feed `ABSpeechSynth` and it doesn't have time to read them all off. 'ABSpeechSynth' will dump the utterances it can't handle into an array and speak them when it can.

Here's an example you can try in a Playground:

    // You'll need these to be able to run the code in a Playground
    import PlaygroundSupport
    PlaygroundPage.current.needsIndefiniteExecution = true

    // ABSpeechSynth code

    let synth = ABSpeechSynth()

    // Creates an array from 1 to 10
    let numbers = Array(1...10)
    numbers.forEach{synth.speak(String($0))}
