//
//  Metronome.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/16/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation
import AVFoundation

class Metronome {
    
    private(set) var beats = [Double]()
    private(set) var beatDeadlines: [DispatchTime]!
    private(set) var beatTasks: [DispatchWorkItem]!
    
    public init(beats: [Double]) {
        self.beats = beats
        beatDeadlines = [DispatchTime](repeating: DispatchTime(uptimeNanoseconds: 0), count: beats.count)
        beatTasks = [DispatchWorkItem](repeating: DispatchWorkItem(block: {}), count: beats.count)
        initAudioPlayer()
    }
    
    private var startTime: DispatchTime!
    private var lastBeatIndex = -1
    
    public func start() {
        let now = DispatchTime.now()
        startTime = now
        for i in lastBeatIndex+1..<beats.count {
            let beatTask = DispatchWorkItem {
                self.beat(index: i)
            }
            beatDeadlines[i] = now + beats[i]
            beatTasks[i] = beatTask
            DispatchQueue.main.asyncAfter(deadline: beatDeadlines[i], execute: beatTasks[i])
        }
    }
    
    public func pause() {
        if lastBeatIndex < beats.count - 1 {
            var timeDiff = 0.0
            if lastBeatIndex >= 0 {
                timeDiff = Double(Int64(bitPattern: DispatchTime.now().uptimeNanoseconds - beatDeadlines[lastBeatIndex].uptimeNanoseconds))
            }
            else {
                timeDiff = Double(Int64(bitPattern: DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds))
            }
            timeDiff = timeDiff/1000000000 // convert to seconds
            for i in lastBeatIndex+1..<beats.count {
                beatTasks[i].cancel()
                if lastBeatIndex >= 0 {
                    beats[i] = beats[i] - beats[lastBeatIndex] - timeDiff
                }
                else {
                    beats[i] =  beats[i] - timeDiff
                }
            }
        }
    }
    
    private func beat(index: Int) {
        lastBeatIndex = index
        playBeatSound()
    }
    
    var player: AVAudioPlayer?
    var beatSoundUrl = Bundle.main.url(forResource: "drum_trimmed", withExtension: "mp3")!
    
    private func initAudioPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
            
            let availableInputs = AVAudioSession.sharedInstance().availableInputs!
            for input in availableInputs {
                if input.portName == "iPhone Microphone" {
                    try AVAudioSession.sharedInstance().setPreferredInput(input)
                }
            }
            
            ChordRecognizer.getChordRecognizer().startListening()
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: beatSoundUrl, fileTypeHint: AVFileType.mp3.rawValue)
            player?.volume = 1.0
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func playBeatSound() {
        do {
            player!.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
