//
//  Chord.swift
//  GuitarGame
//
//  Created by Mac Macoy on 9/29/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class Chord {
    
    // name
    private(set) var name = String()
    private var trueNoteName = String()
    
    // describes the sound
    private var rootNote = [Int]()
    private var quality = [Int]()
    private var intervals = [Int]()
    
    // changes the chord name and trueNoteName
    private(set) var capo = 0
    private(set) var transpose = 0
    
    static private let rootNotes = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]
    
    init(name: String, capo: Int) {
        self.name = name
        setCapo(capo: capo)
    }
    
    private func setSoundData() {
        let fileURL = Bundle.main.url(forResource: "chords", withExtension: "json")
        let chords = Utils.getDictionary(forResource: fileURL!)!["chords"] as! [String:Any]
        if chords[self.trueNoteName] != nil {
            let chord = chords[self.trueNoteName] as! [[String: Int]]
            for combo in chord {
                self.rootNote.append(combo["rootNote"]!)
                self.quality.append(combo["quality"]!)
                self.intervals.append(combo["intervals"]!)
            }
        }
        else {
            assert(false, "no chord in list called " + name)
        }
    }
    
    func setCapo(capo: Int) {
        assert(capo >= 0 && capo <= 12, "Capo must be between 0 and 12")
        // only changing the trueNoteName, not the name the user sees
        let rootNote = getRootNoteName(name: self.name)
        var rootNoteIndex = Chord.rootNotes.index(of: rootNote.root)!
        rootNoteIndex += Int(capo)
        if rootNoteIndex > 11 {
            rootNoteIndex = rootNoteIndex%12
        }
        if rootNoteIndex < 0 {
            rootNoteIndex = 12 + rootNoteIndex
        }
        trueNoteName = Chord.rootNotes[rootNoteIndex] + rootNote.rest
        self.capo = capo
        
        // set sound data based on the true note
        setSoundData()
    }
    
    func transpose(transpose: Int) {
        // change the name the user sees
        var rootNote = getRootNoteName(name: self.name)
        var rootNoteIndex = Chord.rootNotes.index(of: rootNote.root)!
        rootNoteIndex += Int(transpose) - self.transpose
        if rootNoteIndex > 11 {
            rootNoteIndex = rootNoteIndex%12
        }
        if rootNoteIndex < 0 {
            rootNoteIndex = 12 + rootNoteIndex
        }
        name = Chord.rootNotes[rootNoteIndex] + rootNote.rest
        
        // change the trueNoteName
        rootNote = getRootNoteName(name: self.trueNoteName)
        rootNoteIndex = Chord.rootNotes.index(of: rootNote.root)!
        rootNoteIndex += Int(transpose) - self.transpose
        if rootNoteIndex > 11 {
            rootNoteIndex = rootNoteIndex%12
        }
        if rootNoteIndex < 0 {
            rootNoteIndex = 12 + rootNoteIndex
        }
        trueNoteName = Chord.rootNotes[rootNoteIndex] + rootNote.rest
        self.transpose = transpose
        
        // set the sound data because the true note changed
        setSoundData()
    }
    
    private func getRootNoteName(name: String) -> (root: String, rest: String) {
        var rootNote = String()
        var restOfNote = ""
        if name.contains("b") || name.contains("#")  {
            rootNote = String(name[..<name.index(name.startIndex, offsetBy: 2)])
            if name.count > 2 {
                restOfNote = String(name[name.index(name.startIndex, offsetBy: 2)..<name.index(name.startIndex, offsetBy: name.count)])
            }
        }
        else {
            rootNote = String(name[..<name.index(name.startIndex, offsetBy: 1)])
            if name.count > 1 {
                restOfNote = String(name[name.index(name.startIndex, offsetBy: 1)..<name.index(name.startIndex, offsetBy: name.count)])
            }
        }
        return (root: rootNote, rest: restOfNote)
    }
    
    func isEqual(rootNote: Int, quality: Int, intervals: Int) -> Bool {
        for i in 0..<self.rootNote.count {
            if self.rootNote[i] == rootNote && self.quality[i] == quality && self.intervals[i] == intervals {
                return true
            }
        }
        return false
    }
    
}
