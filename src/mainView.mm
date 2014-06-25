#import "mainView.h"
#include <stdlib.h>

@implementation mainView

- (void)setup
{
    analyzer.setup();
    
    agent.setup(&analyzer);
    
    minFreq = 10;
    maxFreq = analyzer.sampleRate*0.5;
    
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

    
    int sampleRate = analyzer.sampleRate;
    int bufferSize = analyzer.getBins().size();
    
    float viewMinFreq = minFreq, viewMaxFreq = maxFreq;
    float viewMaxDb = 0;
    float viewMinDb = -100;
    
    ofPushMatrix();{
        ofScale(ofGetWidth(),ofGetHeight());

        //Scale x
        float diff = 1. / (log10(viewMaxFreq) - log10(viewMinFreq)) ;
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
        
        
        //Waves
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
        
        
        //Agent
        ofSetColor(255,255,255,200);
        ofNoFill();
        ofRect(log10(agent.freqMin),0,log10(agent.freqMax)-log10(agent.freqMin), -100 );

        ofSetColor(255,255,255,100);
        ofFill();
        ofRect(log10(agent.freqMin),20*log10(agent.value()),log10(agent.freqMax)-log10(agent.freqMin), -100 );

        

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
    float n = x / (float)ofGetWidth();
    n = n  * (log10(maxFreq) - log10(minFreq));
    n += log10(minFreq);
    float freq = pow(10,n);
    return freq;
}

- (void)setFc:(NSNumber*)fc{
    agent.filter.setFc([fc floatValue]);
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
    agent.freqMax = [self freqAtX:p.x];

}

- (void)mousePressed:(NSPoint)p button:(int)button
{
    agent.freqMin = [self freqAtX:p.x];

    cout<<"min "<<agent.freqMin<<endl;
}

- (void)mouseReleased:(NSPoint)p button:(int)button
{
    agent.freqMax = [self freqAtX:p.x];
    cout<<"max "<<agent.freqMax<<endl;
}

- (void)windowResized:(NSSize)size
{
	
}

@end