#pragma once
#include "ofMain.h"
#include "AudioAgentProcessor.h"
#include "AudioAnalyzer.h"

@interface AudioAgent : NSObject{
    AudioAgentProcessor * processor;
    NSString * name;

    
}

@property (retain) NSString * name;
@property (assign) AudioAgentProcessor * processor;

@property int inputFreqMin;
@property int inputFreqMax;

@property float inputMinDb;
@property float inputMaxDb;

@property float inputFilterFc;

-(id) initWithAnalyzer:(AudioAnalyzer*)analyzer;

@end
