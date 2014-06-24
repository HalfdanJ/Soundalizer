#pragma once

#include "ofMain.h"
#include "ofxCocoaGLView.h"
#include "AudioAnalyzer.h"

@interface mainView : ofxCocoaGLView {
    int r, g, b;
    AudioAnalyzer analyzer;

}

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

@end
