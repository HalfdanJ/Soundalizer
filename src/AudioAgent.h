#pragma once
#include "ofMain.h"
#include "AudioAgentProcessor.h"
#include "AudioAnalyzer.h"

@interface AudioAgent : NSObject <NSCoding>{
    AudioAgentProcessor * processor;
    NSString * name;
    NSString * oscAddress;
    
    float _outputValue;

}

@property (retain) NSString * name;
@property (retain) NSString * oscAddress;
@property (assign) AudioAgentProcessor * processor;

@property float inputFreqMin;
@property float inputFreqMax;

@property float inputMinDb;
@property float inputMaxDb;

@property float inputFilterFc;

@property (readonly) float outputValue;
@property BOOL outputSpeed;

-(void) setAnalyzer:(AudioAnalyzer*)analyzer;
-(id) initWithAnalyzer:(AudioAnalyzer*)analyzer;

@end
