//
//  AudioAnalyzer.cpp
//  Soundalizer
//
//  Created by Jonas Jongejan    Firma HalfdanJ on 24/06/14.
//
//

#include "AudioAnalyzer.h"
void AudioAnalyzer::setup(int _bufferSize, fftWindowType windowType, fftImplementation implementation, int audioBufferSize, int audioSampleRate) {
    ofxEasyFft::setup(_bufferSize, windowType, implementation, audioBufferSize, audioSampleRate);
    
    sampleRate = audioSampleRate;
    bufferSize = audioBufferSize;
    
    filters.resize(_bufferSize);
    filtederValues.resize(_bufferSize);
    dbValues.resize(_bufferSize);
    values.resize(_bufferSize);
    maxValues.resize(_bufferSize);
    
    for(int i=0;i<bufferSize;i++){
        filters[i].setFc(0.20);
    }
    
    
    setUseNormalization(false);
}


void AudioAnalyzer::audioReceived(float* input, int bufferSize, int nChannels) {
   // cout<<"A"<<endl;
    clock_t start = clock() ;

    
    ofxEasyFft::audioReceived(input, bufferSize, nChannels);
    
    
    
    update();

    for(int i=0;i<getBins().size();i++){
        if(!isnan(getBins()[i])){
            filtederValues[i] = filters[i].update(getBins()[i]);
            dbValues[i] = toDb( getBins()[i]);
            values[i] = getBins()[i];

            if(maxValues[i] < values[i]){
                maxValues[i] = values[i];
            } else {
                maxValues[i] *= 0.95;
            }
        }
    }
    

    ofNotifyEvent(onNewAudio);

    clock_t end = clock() ;
    double elapsed_time = (end-start)/(double)CLOCKS_PER_SEC ;
   // cout<<elapsed_time*sampleRate<<endl;
  //          cout<<"B"<<endl;
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


int AudioAnalyzer::freqToIndex(int freq){
    return 1 + 2. * bufferSize * freq / (float)sampleRate;
}
int AudioAnalyzer::indexToFreq(int index){
    return 0.5 * sampleRate * (float)index/bufferSize;
}

float AudioAnalyzer::toDb(float val){
    return 20*log10(val);
}