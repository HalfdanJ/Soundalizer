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


-(float)inputFreqMin{
    return processor->freqMin;
}
-(void)setInputFreqMin:(float)inputFreqMin{
    processor->freqMin = inputFreqMin;
}

-(float)inputFreqMax{
    return processor->freqMax;
}
-(void)setInputFreqMax:(float)inputFreqMax{
    processor->freqMax = inputFreqMax;
}


-(float)inputFilterFc {
    return processor->getFc();
}
-(void)setInputFilterFc:(float)inputFilterFc{
    processor->setFc(inputFilterFc);
}

@end
