//
//  ABSpeechSynth
//
//  Created by Adrian Bolinger on 3/7/18.
//
//  Copyright 2018 Adrian Bolinger
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom
//  the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
//  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import AVFoundation

class ABSpeechSynth: NSObject {
  
  override init() {
    super.init()
    synthesizer.delegate = self
    // speaks a blank phrase to fire up buffers, etc. after initialization
    self.speak(" ")
  }
  
  /*
   All utterances get funneled to speak(), before speaking runs, check that synthesizer is not speaking. If it is, appends the utterance to the utterance array. Then, with the delegate method, get the first utterance, drop it from the array and speak it.
   */
  
  private let synthesizer = AVSpeechSynthesizer()
  private let audioSession = AVAudioSession.sharedInstance()
  
  private var utteranceBacklogArray: [AVSpeechUtterance] = []
  
  func speak(_ phrase: String) {
    
    let speechQueue = DispatchQueue(label: "speak", qos: .userInteractive, attributes: [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
    speechQueue.sync {
      do {
        try audioSession.setCategory(AVAudioSessionCategoryAmbient)
      } catch {
        print("speak() \(error): \(error.localizedDescription)")
      }

      let utterance = AVSpeechUtterance(string: phrase)
      utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoiceIdentifierAlex)
      
      if synthesizer.isSpeaking {
        self.utteranceBacklogArray.append(utterance)
        return // exit early, delegate will empty out the array
      }
      
      synthesizer.speak(utterance)
    }
  }

  /// Stops speaking. 
  func stop(when: AVSpeechBoundary) {
    guard synthesizer.isSpeaking else { return }
    synthesizer.stopSpeaking(at: when)
  }
}

extension ABSpeechSynth: AVSpeechSynthesizerDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    if utteranceBacklogArray.isEmpty {
      return
    } else {
      let backloggedUtterance = utteranceBacklogArray.first!
      utteranceBacklogArray = utteranceBacklogArray.dropFirst().flatMap{$0}
      synthesizer.speak(backloggedUtterance)
    }
    
  }
}

