#import "mainView.h"
#include <stdlib.h>

@implementation mainView

- (void)setup
{
    analyzer.setup(1024, OF_FFT_WINDOW_HAMMING, OF_FFT_FFTW, 512);
    
}

- (void)update
{
   // analyzer.update();

}

- (void)draw
{

    ofBackgroundGradient(ofColor(30), ofColor(50));
	
	ofNoFill();
	ofSetColor(0,255,0);
	ofCircle(self.mouseX, self.mouseY, 100);
    
    
    ofDrawBitmapString("FPS: "+ofToString(analyzer.getBins().size()), ofPoint(30,30));
    
    ofEnableAlphaBlending();

    


        float s = analyzer.getBins().size()/(float)ofGetWidth();
    
    ofSetColor(255,255,255,150);
    for(int i=0;i<ofGetWidth();i++){
        ofLine(i, ofGetHeight(), i, ofGetHeight()-analyzer.getBins()[i*s]*100000);
    }
    
    ofSetColor(255,255,255,150);

    for(int i=0;i<ofGetWidth();i++){
        ofLine(i, ofGetHeight(), i, ofGetHeight()-analyzer.filtederValues[i*s]*100000);
    }
}

- (void)exit
{
	
}

-(void)changeColor:(id)sender
{
}

- (void)keyPressed:(int)key
{
	
}

- (void)keyReleased:(int)key
{
	
}

- (void)mouseMoved:(NSPoint)p
{
	
}

- (void)mouseDragged:(NSPoint)p button:(int)button
{
	
}

- (void)mousePressed:(NSPoint)p button:(int)button
{
	
}

- (void)mouseReleased:(NSPoint)p button:(int)button
{
	
}

- (void)windowResized:(NSSize)size
{
	
}

@end