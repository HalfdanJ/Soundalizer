#pragma once
#include "ofMain.h"
#include "ofxOsc.h"

@interface OutputDestination : NSObject <NSCoding>  {
    NSString * hostname;
    int port;
    
    ofxOscSender osc;
}

@property (retain) NSString * hostname;
@property int port;

-(void) update:(NSArray*)agents;

@end
