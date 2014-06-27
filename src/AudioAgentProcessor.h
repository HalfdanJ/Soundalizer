#pragma once

#include "AudioAnalyzer.h"

class AudioAgentProcessor {
public:
    
    AudioAgentProcessor();
    
    void setup(AudioAnalyzer * analyzer);
    
    float value();
    float speedValue();
    
    int getFc();
    void setFc(int fc);
    
    int freqMin, freqMax;
    float minDb, maxDb;
    
    bool outputSpeed;
    
    ofxBiquadFilter1f filter;
    AudioAnalyzer * analyzer;


protected:
    
    void onNewAudio();
    
    ofMutex soundMutex;
    
    int fc;
    
    float lastValue;

};