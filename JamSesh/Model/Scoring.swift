//
//  Scoring.swift
//  GuitarGame
//
//  Created by Mac Macoy on 10/16/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class Scoring {
    
    var hit = [Double?](repeating: nil, count: 1)
    private var song: Song!
    
    init(numOfChords: Int, song: Song) {
        self.hit = [Double?](repeating: nil, count: numOfChords)
        self.song = song
    }
    
    init(hit: [Double?]) {
        self.hit = hit
    }
    
    var finalScore: Double {
        var chordsHit = 0.0
        for chord in hit {
            if chord != nil {
                chordsHit += 1.0
            }
        }
        print((chordsHit/Double(hit.count-song.numberOfNullChords))*100)
        return (chordsHit/Double(hit.count-song.numberOfNullChords))*100
    }
    
    func getChordScore(chord: String) -> Double{
        var totalHit = 0.0
        var totalPossible = 0.0
        for i in 0..<song.chords.count {
            if song.chords[i].chord != nil {
                if song.chords[i].chord!.name == chord {
                    totalPossible += 1
                    if hit[i] != nil {
                        totalHit += 1
                    }
                }
            }
        }
        return (totalHit/totalPossible)*100
    }
    
    static let mastered = 93.0
    static let gettingBetter = 80.0
}
