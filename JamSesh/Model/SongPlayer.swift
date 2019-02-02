//
//  SongPlayer.swift
//  GuitarGame
//
//  Created by Mac Macoy on 10/16/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class SongPlayer {
    
    private(set) var song: Song
    private(set) var started = false
    private var start = Date()
    private(set) var paused = false
    private var pausedAt = Date()
    private(set) var metronone: Metronome!
    
    internal init(song: Song) {
        self.song = song
        self.metronone = Metronome(beats: song.beats)
    }
    
    func play() {
        if !started {
            start = Date()
            started = true
        }
        else if paused {
            start = start + (-pausedAt.timeIntervalSince(Date()))
            paused = false
        }
        self.metronone.start()
    }
    
    func pause() {
        if started && !paused {
            pausedAt = Date()
            paused = true
        }
        self.metronone.pause()
    }
    
    func getCurrentChord() -> (chord: Chord?, chordIndex: Int) {
        let c = currentChordIndex
        if c == -1 {
            return (chord: nil, chordIndex: c)
        }
        else {
            return (chord: self.song.chords[c].chord, c)
        }
    }
    
    func getAllChords() -> [(timeToNow: ClosedRange<Double>, chord: Chord?, chordIndex: Int)] {
        let now = self.now()
        var allChords = [(timeToNow: ClosedRange<Double>, chord: Chord?, chordIndex: Int)]()
        for i in 0..<self.song.chords.count {
            let lowerBound = self.song.chords[i].time.lowerBound - now
            let upperBound = self.song.chords[i].time.upperBound - now
            allChords.append((lowerBound...upperBound, self.song.chords[i].chord, i))
        }
        return allChords
    }
    
    func getLyric() -> (now: String?, next: String?) {
        let now = self.now()
        var lyricNow: String? = nil
        var lyricNext: String? = nil
        for i in 0..<self.song.lyrics.count {
            if self.song.lyrics[i].time.contains(now) {
                lyricNow = self.song.lyrics[i].lyric
                if i+1 < self.song.lyrics.count {
                    lyricNext = self.song.lyrics[i+1].lyric
                }
            }
        }
        return (now: lyricNow, next: lyricNext)
    }
    
    func isDone() -> Bool {
        if !paused {
            return now() > self.song.duration
        }
        else {
            return false
        }
    }
    
    var currentChordIndex: Int {
        if !started {
            return 0
        }
        let timeNow = now()
        for i in 0..<self.song.chords.count {
            if self.song.chords[i].time.contains(timeNow) {
                return i
            }
        }
        return -1 // song is over
        assert(false, "bad logic in SongPlayer.currentChordIndex")
    }
    
    var currentLyricIndex: Int {
        if !started {
            return 0
        }
        let timeNow = now()
        for i in 0..<self.song.lyrics.count {
            if self.song.lyrics[i].time.contains(timeNow) {
                return i
            }
            else if i < self.song.lyrics.count - 1 {
                if timeNow > self.song.lyrics[i].time.upperBound && timeNow < self.song.lyrics[i+1].time.lowerBound {
                    return i-1
                }
            }
        }
        assert(false, "bad logic in SongPlayer.currentLyricIndex")
    }
    
    func now() -> Double {
        if !paused {
            return -start.timeIntervalSince(Date())
        }
        else {
            return -start.timeIntervalSince(pausedAt)
        }
    }
    
    
    
}
