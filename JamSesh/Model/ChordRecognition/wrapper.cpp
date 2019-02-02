//
//  wrapper.cpp
//  ChordRecognition
//
//  Created by Mac Macoy on 9/8/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

#include <stdio.h>

#include "Chromagram.h"
#include "ChordDetector.h"

// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).

struct chord {
    int rootNote;
    int quality;
    int intervals;
};

extern "C" struct chord getChordFromAudioFrame(int frameSize, int sampleRate, float* frame)
{
    // convert to array of doubles
    std::vector<double> double_frame;
    for (int i=0; i<frameSize; i++){
        double_frame.push_back((double)(frame[i]));
    }
    
    Chromagram c(frameSize,sampleRate);
    
    c.processAudioFrame(double_frame);
    
    std::vector<double> chromaVector;
    if (c.isReady()){
        chromaVector = c.getChromagram();
    }
    
    // get the chord
    ChordDetector chordDetector;
    chordDetector.detectChord(chromaVector);
    chord chord;
    chord.rootNote = chordDetector.rootNote;
    chord.quality = chordDetector.quality;
    chord.intervals = chordDetector.intervals;
    return chord;
}
