#pragma once
#include "ofxEasyFFT.h"
#include "ofxBiquadFilter.h"

class AudioAnalyzer : public ofxEasyFft {
public:
    
    void setup(int bufferSize = 512,
               fftWindowType windowType = OF_FFT_WINDOW_HAMMING,
               fftImplementation implementation = OF_FFT_FFTW,
               int audioBufferSize = 256,
               int audioSampleRate = 48000);
    
    void audioReceived(float* input, int bufferSize, int nChannels);
    
    vector<ofxBiquadFilter1f> filters;
    vector<float>  filtederValues;


private:
    void normalize(vector<float>& data);

};