//
//  Song.swift
//  GuitarGame
//
//  Created by Mac Macoy on 9/29/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class Song {
    
    private(set) var title = String()
    private(set) var artist = String()
    private(set) var duration = Double()
    private(set) var capo = Int()
    private(set) var chords = [(time: ClosedRange<Double>, chord: Chord?)]()
    private(set) var lyrics = [(time: ClosedRange<Double>, lyric: String)]()
    private(set) var beats = [Double]()
    
    static let walkUpTime = 6.0
    static let walkAwayTime = 3.0
    
    init(songDict: Dictionary<String, Any>) {
        // title
        title = songDict["title"] as! String
        
        // artist
        artist = songDict["artist"] as! String
        
        // song duration
        duration = songDict["duration"] as! Double
        
        // initial capo
        capo = songDict["capo"] as! Int
        
        // chords
        var chordsList = songDict["chords"] as! [Dictionary<String, Any>]
        chords.append((time: 0...Song.walkUpTime, chord: nil))
        if chordsList[0]["timestamp"] as! Double != 0.0 {
            let lowerBound = 0.0
            let upperBound = (chordsList[0]["timestamp"] as! Double)
            chords.append((time: lowerBound+Song.walkUpTime...upperBound+Song.walkUpTime, chord: nil))
        }
        for i in 0..<chordsList.count {
            let lowerBound = chordsList[i]["timestamp"] as! Double
            var upperBound = Double()
            if i < chordsList.count - 1 {
                upperBound = chordsList[i+1]["timestamp"] as! Double
            }
            else {
                upperBound = duration
            }
            let chordName = chordsList[i]["chord"] as! String
            if chordName == "" {
                chords.append((time: lowerBound+Song.walkUpTime...upperBound+Song.walkUpTime, chord: nil))
            }
            else {
                chords.append((time: lowerBound+Song.walkUpTime...upperBound+Song.walkUpTime, chord: Chord(name: chordName, capo: capo)))
            }
        }
        chords.append((time: chords[chords.count-1].time.upperBound...chords[chords.count-1].time.upperBound+Song.walkAwayTime, chord: nil))
        
        // lyrics
        var lyricsList = songDict["lyrics"] as! [Dictionary<String, Any>]
        lyrics.append((time: 0...Song.walkUpTime/3, lyric: title))
        lyrics.append((time: Song.walkUpTime/3...2*Song.walkUpTime/3, lyric: artist))
        lyrics.append((time: 2*Song.walkUpTime/3...Song.walkUpTime, lyric: ""))
        if lyricsList[0]["timestamp"] as! Double != 0.0 {
            let lowerBound = 0.0
            let upperBound = (lyricsList[0]["timestamp"] as! Double)
            lyrics.append((time: lowerBound+Song.walkUpTime...upperBound+Song.walkUpTime, lyric: ""))
        }
        for i in 0..<lyricsList.count {
            let lowerBound = lyricsList[i]["timestamp"] as! Double
            var upperBound = Double()
            if i < lyricsList.count - 1 {
                upperBound = lyricsList[i+1]["timestamp"] as! Double
            }
            else {
                upperBound = duration
            }
            let lyric = lyricsList[i]["lyric"] as! String
            lyrics.append((time: lowerBound+Song.walkUpTime...upperBound+Song.walkUpTime, lyric: lyric))
        }
        lyrics.append((time: lyrics[lyrics.count-1].time.upperBound...lyrics[lyrics.count-1].time.upperBound+Song.walkAwayTime, lyric: ""))

        // beats
        beats = songDict["beats"] as! [Double]
        for i in 0..<beats.count {
            beats[i] = beats[i] + Song.walkUpTime
        }
        
        // adjust duration
        duration = duration + Song.walkUpTime + Song.walkAwayTime
    }
    
    func incrementCapo() {
        setCapo(capo: self.capo + 1)
    }
    
    func decrementCapo() {
        setCapo(capo: self.capo - 1)
    }
    
    func setCapo(capo: Int) {
        assert(capo >= 0 && capo <= 12, "Capo must stay between 0 and 12")
        for chord in chords {
            if chord.chord != nil {
                chord.chord!.setCapo(capo: capo)
            }
        }
        self.capo = capo
    }
    
    func transpose(transpose: Int) {
        for chord in chords {
            if chord.chord != nil {
                chord.chord!.transpose(transpose: transpose)
            }
        }
    }
    
    var numberOfNullChords: Int {
        var count = 0
        for chord in chords {
            if chord.chord == nil {
                count += 1
            }
        }
        if Song.walkUpTime > 0 {
            count -= 1
        }
        if Song.walkAwayTime > 0 {
            count -= 1
        }
        return count
    }
    
}
