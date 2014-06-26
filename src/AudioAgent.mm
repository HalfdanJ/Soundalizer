//
//  AudioAgent.m
//  Soundalizer
//
//  Created by flux on 25/06/2014.
//
//

#import "AudioAgent.h"

@implementation AudioAgent
@synthesize name, processor;

-(id)initWithAnalyzer:(AudioAnalyzer *)analyzer{
    self = [super init];
    if(self){
        processor = new AudioAgentProcessor();
        processor->setup(analyzer);
        
    }
    return self;
}


-(int)inputFreqMin{
    return processor->freqMin;
}
-(void)setInputFreqMin:(int)inputFreqMin{
    processor->freqMin = inputFreqMin;
}

-(int)inputFreqMax{
    return processor->freqMax;
}
-(void)setInputFreqMax:(int)inputFreqMax{
    processor->freqMax = inputFreqMax;
}

-(void)setInputMinDb:(float)inputMinDb{
    processor->minDb = inputMinDb;
}

-(float)inputMinDb{
    return processor->minDb;
}

-(void)setInputMaxDb:(float)inputMaxDb{
    processor->maxDb = inputMaxDb;
}

-(float)inputMaxDb{
    return processor->maxDb;
}


-(float)inputFilterFc {
    return processor->getFc();
}
-(void)setInputFilterFc:(float)inputFilterFc{
    processor->setFc(inputFilterFc);
}

@end
