//
//  ChordRecognizer.swift
//  GuitarGame
//
//  Created by Mac Macoy on 10/10/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import AVFoundation

class ChordRecognizer {
    
    private var audioEngine = AVAudioEngineSingleton.get()
    private var audioInputNode: AVAudioInputNode? = nil
    private let bufferSize = 5000
    private var on = false
    private(set) var now = (rootNote: 0, quality: 0, intervals: 0)
    
    private static var singleton: ChordRecognizer? = nil
    
    static func getChordRecognizer() -> ChordRecognizer {
        if singleton == nil {
            singleton = ChordRecognizer()
        }
        return singleton!
    }
    
    private init() {
        audioInputNode = audioEngine.inputNode
    }
    
    func startListening() {
        if on == true {
            stopListening()
        }
        on = true
        let sampleRate = self.audioInputNode!.inputFormat(forBus: 0).sampleRate
        self.audioInputNode!.installTap( onBus: 50,         // mono input
            bufferSize: AVAudioFrameCount(bufferSize), // a request, not a guarantee
            format: nil,      // no format translation
            block: { buffer, when in
                
                // This block will be called over and over for successive buffers
                // of microphone data until you stop() AVAudioEngine
                let actualSampleCount = Int(buffer.frameLength)
                var audioFrame = [Float](repeating: 0, count: actualSampleCount)
                
                for i in 0...actualSampleCount-1 {
                    audioFrame[i] = buffer.floatChannelData!.pointee[i]
                }
                
                let audioFramePointer: UnsafeMutablePointer<Float> = UnsafeMutablePointer(mutating: audioFrame)
                let chordCpp = getChordFromAudioFrame(Int32(audioFrame.count), Int32(sampleRate), audioFramePointer)
                
                self.now.rootNote = Int(chordCpp.rootNote)
                self.now.quality = Int(chordCpp.quality)
                self.now.intervals = Int(chordCpp.intervals)
//                print(String(self.now.rootNote) + String(self.now.quality) + String(self.now.intervals))
        })
        do {
            try audioEngine.start()
        } catch let error as NSError {
            print("Got an error starting audioEngine: \(error.domain), \(error)")
        }
    }
    
    func stopListening() {
        self.audioInputNode!.removeTap(onBus: 0)
        now = (rootNote: 0, quality: 0, intervals: 0)
        on = false
    }
    
}
