//
//  GameplaySongPlayer.swift
//  GuitarGame
//
//  Created by Mac Macoy on 10/30/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class GameplaySongPlayer: SongPlayer {
    
    private(set) var scoring: Scoring!
    private var chordRecognizer: ChordRecognizer?
    private let chordRecognitionThreadQueue = DispatchQueue(label: "chord-recognition")
    private var startedListening = false
    
    override init(song: Song) {
        super.init(song: song)
        scoring = Scoring(numOfChords: self.song.chords.count, song: song)
        self.chordRecognizer = ChordRecognizer.getChordRecognizer()
    }
    
    override func play() {
        super.play()
        if !startedListening {
            startChordListeningThread()
            startedListening = true
        }
    }
    
    private func startChordListeningThread() {
        chordRecognitionThreadQueue.async {
            self.chordRecognizer!.startListening()
            // still listens if paused
            while(!self.isDone()) {
                let _currentChordIndex = super.currentChordIndex
                if _currentChordIndex == -1 {
                    break
                }
                let chordNow = self.song.chords[_currentChordIndex]
                if self.scoring!.hit[_currentChordIndex] == nil {
                    if chordNow.chord != nil {
                        if chordNow.chord!.isEqual(rootNote: self.chordRecognizer!.now.rootNote,
                                                  quality: self.chordRecognizer!.now.quality,
                                                  intervals: self.chordRecognizer!.now.intervals) {
                            self.scoring!.hit[_currentChordIndex] = self.now() - self.song.chords[_currentChordIndex].time.lowerBound
                        }
//                        print("Current chord: " + self.song.chords[_currentChordIndex].chord!.name)
                    }
                }
            }
            self.chordRecognizer!.stopListening()
        }
    }
    
}
