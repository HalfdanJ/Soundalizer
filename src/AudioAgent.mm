//
//  AudioAgent.m
//  Soundalizer
//
//  Created by flux on 25/06/2014.
//
//

#import "AudioAgent.h"

@implementation AudioAgent
@synthesize name;
@synthesize processor;
@synthesize outputValue = _outputValue;


-(id)init{
    self = [super init];
    if(self){
        self.processor = new AudioAgentProcessor();

        [NSTimer scheduledTimerWithTimeInterval:1.0/15. target:self selector:@selector(updateValue) userInfo:nil repeats:true];
    }
    return self;
}

-(id)initWithAnalyzer:(AudioAnalyzer *)analyzer{
    self = [self init];
    if(self){
        [self setAnalyzer:analyzer];
    }
    return self;
}

-(void)setAnalyzer:(AudioAnalyzer *)analyzer{
    self.processor->setup(analyzer);
}


-(float)inputFreqMin{
    return processor->freqMin;
}
-(void)setInputFreqMin:(float)inputFreqMin{
    processor->freqMin = MIN(self.inputFreqMax, MAX(10,inputFreqMin));
}

-(float)inputFreqMax{
    return processor->freqMax;
}
-(void)setInputFreqMax:(float)inputFreqMax{
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

-(void)setOutputSpeed:(BOOL)outputSpeed{
    processor->outputSpeed = outputSpeed;
}
-(BOOL)outputSpeed{
    return processor->outputSpeed;
}

-(void) updateValue {
    [self willChangeValueForKey:@"outputValue"];
    _outputValue = processor->value();
    [self didChangeValueForKey:@"outputValue"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];

    [aCoder encodeInteger:self.inputFreqMin forKey:@"inputFreqMin"];
    [aCoder encodeInteger:self.inputFreqMax forKey:@"inputFreqMax"];
    
    [aCoder encodeFloat:self.inputMaxDb forKey:@"inputMaxDb"];
    [aCoder encodeFloat:self.inputMinDb forKey:@"inputMinDb"];
    
    [aCoder encodeFloat:self.inputFilterFc forKey:@"inputFilterFc"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if(self){
        self.name = [aDecoder decodeObjectForKey:@"name"];

        self.inputFreqMin = [aDecoder decodeIntegerForKey:@"inputFreqMin"];
        self.inputFreqMax = [aDecoder decodeIntegerForKey:@"inputFreqMax"];
        
        self.inputMinDb = [aDecoder decodeFloatForKey:@"inputMinDb"];
        self.inputMaxDb = [aDecoder decodeFloatForKey:@"inputMaxDb"];
        
        self.inputFilterFc = [aDecoder decodeFloatForKey:@"inputFilterFc"];
        
    }
    return self;
}

@end
