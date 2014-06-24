//
//  AudioAgent.cpp
//  Soundalizer
//
//  Created by flux on 24/06/2014.
//
//

#include "AudioAgent.h"

void AudioAgent::setup(AudioAnalyzer * _analyzer){
    analyzer = _analyzer;
    ofAddListener(analyzer->onNewAudio,this, &AudioAgent::onNewAudio);

    filter.setFc(0.1);
    filter.setType(OFX_BIQUAD_TYPE_BANDPASS);
    
    freqMin = 1000;
    freqMax = 10000;
}

void AudioAgent::onNewAudio(){
      //      cout<<"C"<<endl;
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
    
    cout<<v<<"  "<<filter.value()<<"  "<<analyzer->values[500]<<endl;
      //      cout<<"D"<<endl;
}

float AudioAgent::value(){
    soundMutex.lock();
    float v = filter.value();
    soundMutex.unlock();
    
    return v;
}
