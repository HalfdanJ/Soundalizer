//
//  AudioAgent.cpp
//  Soundalizer
//
//  Created by flux on 24/06/2014.
//
//

#include "AudioAgentProcessor.h"

AudioAgentProcessor::AudioAgentProcessor(){
    fc = 5000;
    analyzer = nil;
    
    
    freqMin = 1000;
    freqMax = 10000;
    
    minDb = -100;
    maxDb = 0;

}

void AudioAgentProcessor::setup(AudioAnalyzer * _analyzer){
    analyzer = _analyzer;
    ofAddListener(analyzer->onNewAudio,this, &AudioAgentProcessor::onNewAudio);

    setFc(fc);
}

void AudioAgentProcessor::onNewAudio(){
    int bufferSize = analyzer->bufferSize;
    
    int viewMin = analyzer->freqToIndex(freqMin);
    int viewMax = analyzer->freqToIndex(freqMax);
    
    double v = 0;
    for(int i=viewMin; i<viewMax;i++){
        if(!isnan(analyzer->values[i])){
            v += analyzer->values[i];
        }
    }
    v = v / (float)(viewMax-viewMin);
    v = analyzer->toDb(v);
    
    v = MAX(-100,v);
    v = MIN(0,v);
    
    v = ofMap(v, minDb, maxDb, 0, 1);
    
    v = MAX(0,v);
    v = MIN(1,v);
    
    soundMutex.lock();
    lastValue = filter.value();
    filter.update(v);
    soundMutex.unlock();
}

float AudioAgentProcessor::value(){
    soundMutex.lock();
    float v = filter.value();
    
    soundMutex.unlock();

    return v;
}

float AudioAgentProcessor::speedValue(){
    float v = value();
    
    v = v - lastValue;
    v *= 10.;
    
    return v;
}


int AudioAgentProcessor::getFc(){
    return fc;
}

void AudioAgentProcessor::setFc(int _fc){
    fc = _fc;

    if(analyzer)
        filter.setFc(_fc/(float)analyzer->sampleRate);
}