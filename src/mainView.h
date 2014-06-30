#pragma once

#include "ofMain.h"
#include "ofxCocoaGLView.h"
#include "AudioAnalyzer.h"
#include "AudioAgent.h"
#include "OutputDestination.h"

typedef enum : NSUInteger {
    None = 0x00,
    Top = 0x01,
    Left = 0x02 ,
    Right = 0x04,
    Bottom = 0x08,
} SelectionHook;

@interface mainView : ofxCocoaGLView {
    AudioAnalyzer analyzer;
    
   // AudioAgent agent;
    
    float minFreq, maxFreq;
    
    NSMutableArray * agents;
    NSArrayController * agentsArrayController;
    NSArrayController * destinationsArrayController;
    int selectedHook;
    
    NSPoint lastMousePoint;
    
    NSTimer * outputTimer;
}

@property (retain) IBOutlet NSMutableArray * agents;
@property (assign) IBOutlet NSArrayController * agentsArrayController;
@property (assign) IBOutlet NSArrayController * destinationsArrayController;

- (void) addAgent;
- (void) loadAgents: (NSArray*)agents;

- (void)setup;
- (void)update;
- (void)draw;
- (void)exit;

- (void)keyPressed:(int)key;
- (void)keyReleased:(int)key;
- (void)mouseMoved:(NSPoint)p;
- (void)mouseDragged:(NSPoint)p button:(int)button;
- (void)mousePressed:(NSPoint)p button:(int)button;
- (void)mouseReleased:(NSPoint)p button:(int)button;
- (void)windowResized:(NSSize)size;

- (void)changeColor:(id)sender;

- (float) freqAtX:(float)x;
- (float) dbAtY:(float)y;

- (float) xAtFreq:(float)freq;
- (float) yAtDb:(float)db;

- (AudioAgent*) selectedAgent;


@end
