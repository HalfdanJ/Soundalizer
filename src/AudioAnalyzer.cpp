//
//  AudioAnalyzer.cpp
//  Soundalizer
//
//  Created by Jonas Jongejan    Firma HalfdanJ on 24/06/14.
//
//

#include "AudioAnalyzer.h"
void AudioAnalyzer::setup(int bufferSize, fftWindowType windowType, fftImplementation implementation, int audioBufferSize, int audioSampleRate) {
    ofxEasyFft::setup(bufferSize, windowType, implementation, audioBufferSize, audioSampleRate);
    
    filters.resize(bufferSize);
    filtederValues.resize(bufferSize);
    
    for(int i=0;i<bufferSize;i++){
        filters[i].setFc(0.05);
    }
    
    
    setUseNormalization(false);
}


void AudioAnalyzer::audioReceived(float* input, int bufferSize, int nChannels) {
    ofxEasyFft::audioReceived(input, bufferSize, nChannels);
    
    update();

    for(int i=0;i<bufferSize;i++){
        if(!isnan(getBins()[i])){

            filtederValues[i] = filters[i].update(getBins()[i]);
        }
    }
    
    
}


void AudioAnalyzer::normalize(vector<float>& data) {
    float maxValue = 0;
    for(int i = 0; i < data.size(); i++) {
        if(abs(data[i]) > maxValue) {
            maxValue = abs(data[i]);
        }
    }
    for(int i = 0; i < data.size(); i++) {
        data[i] /= maxValue;
    }
}
