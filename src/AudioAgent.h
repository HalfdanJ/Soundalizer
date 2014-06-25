#pragma once

#include "AudioAnalyzer.h"

class AudioAgent {
public:
    
    void setup(AudioAnalyzer * analyzer);
    
    float value();
    
    int freqMin, freqMax;
    
    ofxBiquadFilter1f filter;

protected:
    
    void onNewAudio();
    
    AudioAnalyzer * analyzer;
    ofMutex soundMutex;

};