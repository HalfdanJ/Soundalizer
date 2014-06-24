#pragma once

#include "AudioAnalyzer.h"

class AudioAgent {
public:
    
    void setup(AudioAnalyzer * analyzer);
    
    float value();
    
    int freqMin, freqMax;
    
protected:
    
    void onNewAudio();
    
    AudioAnalyzer * analyzer;
    ofMutex soundMutex;

    ofxBiquadFilter1f filter;
};