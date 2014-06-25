//
//  AudioAgent.cpp
//  Soundalizer
//
//  Created by flux on 24/06/2014.
//
//

#include "AudioAgentProcessor.h"

void AudioAgentProcessor::setup(AudioAnalyzer * _analyzer){
    analyzer = _analyzer;
    ofAddListener(analyzer->onNewAudio,this, &AudioAgentProcessor::onNewAudio);

    filter.setFc(0.1);
    
    freqMin = 1000;
    freqMax = 10000;
}

void AudioAgentProcessor::onNewAudio(){
    int bufferSize = analyzer->bufferSize;
    
    int viewMin = analyzer->freqToIndex(freqMin), viewMax = analyzer->freqToIndex(freqMax);
    
    double v = 0;
    float min;
    for(int i=viewMin; i<viewMax;i++){
        if(!isnan(analyzer->values[i])){
            v += analyzer->values[i];
        }
    }
    v = v / (float)(viewMax-viewMin);
    soundMutex.lock();
    filter.update(v);
    soundMutex.unlock();
}

float AudioAgentProcessor::value(){
    soundMutex.lock();
    float v = filter.value();
    soundMutex.unlock();
    
    return v;
}


int AudioAgentProcessor::getFc(){
    return fc;
}

void AudioAgentProcessor::setFc(int _fc){
    filter.setFc(_fc/(float)analyzer->sampleRate);
    fc = _fc;
    return fc;
}