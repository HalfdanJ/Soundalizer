#import "mainView.h"
#include <stdlib.h>

@implementation mainView

- (void)setup
{
    analyzer.setup();
    
    agent.setup(&analyzer);
    
}

- (void)update
{
   // analyzer.update();
//    agent.freqMin =
}

- (void)draw
{

    ofBackgroundGradient(ofColor(30), ofColor(50));
	   
    
    ofDrawBitmapString("FPS: "+ofToString(ofGetFrameRate())+" buffer size: "+ofToString(analyzer.getBins().size()), ofPoint(30,30));
    
    ofEnableAlphaBlending();

    
    ofSetColor(255,255,255,100);
    //cout<<agent.value()<<endl;
    ofRect(0,ofGetHeight(),ofGetWidth(),-agent.value()*100000 );
    
    int sampleRate = analyzer.sampleRate;
    int bufferSize = analyzer.getBins().size();
    
    float viewMinFreq = 10, viewMaxFreq = 25000;;//sampleRate*0.5;
    float viewMaxDb = 0;
    float viewMinDb = -100;
    
    ofPushMatrix();{
        ofScale(ofGetWidth(),ofGetHeight());

        //Scale x
        ofScale(1.0/log10(viewMaxFreq),1);
        
        float diff = log10(viewMaxFreq) / (log10(viewMaxFreq) - log10(viewMinFreq));
        ofScale(diff,1);
        ofTranslate(-log10(viewMinFreq), 0);
        
        //Scale y
        ofScale(1, 1.0/fabs(viewMaxDb - viewMinDb));
        ofTranslate(0, -viewMinDb);
        
        ofTranslate(0,-100);
        ofScale(1, -1);
        
        ofSetColor(255, 50);

        for(int db = 0; db >= -100; db -= 10){
            ofLine(0,db,log10(viewMaxFreq),db);
            ofDrawBitmapString(ofToString(db)+"db", ofPoint(log10(viewMinFreq*1.05), db+1));
        }
        
        ofLine(log10(100),viewMinDb,log10(100),viewMaxDb);
        ofDrawBitmapString("100", log10(100), -10);
        
        ofLine(log10(1000),viewMinDb,log10(1000),viewMaxDb);
        ofDrawBitmapString("1K", log10(1000), -10);
        
        ofLine(log10(10000),viewMinDb,log10(10000),viewMaxDb);
        
        ofSetColor(255, 100, 0);
        float max = 0;
        for(int i=0;i<bufferSize;i++){
            float frequency = analyzer.indexToFreq(i);
            float x = log10(frequency) ;
            float db = 20*log10(analyzer.filtederValues[i]);
            
            if(max < analyzer.filtederValues[i])
                max = analyzer.filtederValues[i];
            
            ofLine(x, -100, x, db);

        }

    } ofPopMatrix();
/*    float s = analyzer.getBins().size()/(float)ofGetWidth();
    
    ofSetColor(255,255,255,150);
    for(int i=0;i<ofGetWidth();i++){
        ofLine(i, ofGetHeight(), i, ofGetHeight()-analyzer.getBins()[i*s]*100000);
    }
    
    ofSetColor(255,255,255,150);

    for(int i=0;i<ofGetWidth();i++){
        ofLine(i, ofGetHeight(), i, ofGetHeight()-analyzer.filtederValues[i*s]*100000);
    }*/
}

- (int) freqAtX:(int)x{
    
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