#pragma once

#include "AudioAnalyzer.h"

class AudioAgentProcessor {
public:
    
    void setup(AudioAnalyzer * analyzer);
    
    float value();
    
    int getFc();
    void setFc(int fc);
    
    int freqMin, freqMax;
    
    ofxBiquadFilter1f filter;
    AudioAnalyzer * analyzer;


protected:
    
    void onNewAudio();
    
    ofMutex soundMutex;
    
    int fc;

};