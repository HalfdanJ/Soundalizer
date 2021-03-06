#pragma once
#include "ofxEasyFFT.h"
#include "ofxBiquadFilter.h"

class AudioAnalyzer : public ofxEasyFft {
public:
    
    void setup(int bufferSize = 2048,
               fftWindowType windowType = OF_FFT_WINDOW_HAMMING,
               fftImplementation implementation = OF_FFT_FFTW,
               int audioBufferSize = 2048/2,
               int audioSampleRate = 44100);
    
    void audioReceived(float* input, int bufferSize, int nChannels);
    
    vector<ofxBiquadFilter1f> filters;
    vector<float>  filtederValues;
    vector<float>  dbValues, values;
    vector<float>  maxValues;
    
    int sampleRate, bufferSize;
    
    ofEvent<void> onNewAudio;
    
    int freqToIndex(int freq);
    int indexToFreq(int index);
    
    float toDb(float val);

private:
    void normalize(vector<float>& data);

};