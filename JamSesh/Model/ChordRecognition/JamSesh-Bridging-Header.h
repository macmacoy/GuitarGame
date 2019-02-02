//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

struct chord {
    int rootNote;
    int quality;
    int intervals;
};

struct chord getChordFromAudioFrame(int frameSize, int sampleRate, float* frame);
