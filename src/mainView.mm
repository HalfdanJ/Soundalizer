#import "mainView.h"
#include <stdlib.h>

@implementation mainView
@synthesize  agentsArrayController, agents;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    //
    self.agents = [NSMutableArray array];
    
    analyzer.setup();

    
    return self;
}


-(void)addAgent{
    AudioAgent * newAgent = [[AudioAgent alloc] initWithAnalyzer:&analyzer];
    newAgent.name = [NSString stringWithFormat:@"Agent %i", self.agents.count+1];;
    [self.agentsArrayController addObject:newAgent];
}

-(AudioAgent *)selectedAgent{
    return [[agentsArrayController selectedObjects] objectAtIndex:0];
}


- (void) loadAgents: (NSArray*)_agents{
    for(AudioAgent* agent in _agents){
        [agent setAnalyzer:&analyzer];
        [self.agentsArrayController addObject:agent];
    }
}

-(id)init{
    self = [super init];
    return self;
}

- (void)awakeFromNib {
    //[self addAgent];
    //[self addAgent];
}

- (void)setup
{
    
   // agent.setup(&analyzer);
    
    minFreq = 10;
    maxFreq = analyzer.sampleRate*0.5;
    
}

- (void)update
{
   // analyzer.update();
//    agent.freqMin =
    //cout<<self.selectedAgentIndex<<endl;
 //   NSLog(@"%@",[[agentsArrayController selectedObjects] objectAtIndex:0]);
    
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
        ofDrawBitmapString("100", log10(100)*1.005, -5);
        
        ofLine(log10(1000),viewMinDb,log10(1000),viewMaxDb);
        ofDrawBitmapString("1K", log10(1000)*1.005, -5);
        
        ofLine(log10(10000),viewMinDb,log10(10000),viewMaxDb);
        ofDrawBitmapString("10K", log10(10000)*1.005, -5);

        
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
        
        ofPushMatrix();{
            ofScale(1, -100);

            //Agent
            for(int i=0;i<[agents count]; i++){
                ofPushMatrix();{
                    AudioAgent * agent = [agents objectAtIndex:i];
                    ofTranslate(log10(agent.processor->freqMin), -1-agent.inputMinDb/100.0 + 1);
                    ofScale(log10(agent.processor->freqMax)-log10(agent.processor->freqMin),-((agent.inputMaxDb-agent.inputMinDb)/100.));
                    
                    
                    ofSetColor(255,200);
                    ofNoFill();
                    ofRect(0, 0, 1, 1 );
                    
                    ofFill();
                    ofSetColor(255,20);
                    ofRect(0, 0, 1, 1 );
                    
                    ofSetColor(255,255,255,100);
                    ofFill();
                    ofRect(0,0,
                           1,
                           agent.processor->value() );
/*                    ofFill();
                    ofSetColor(255,20);
                    ofRect(log10(agent.processor->freqMin),
                           -agent.inputMinDb/100.0,
                           log10(agent.processor->freqMax)-log10(agent.processor->freqMin),
                           -(agent.inputMaxDb-agent.inputMinDb)/100. );
                    
                    
                    cout<< (agent.inputMaxDb-agent.inputMinDb)/100.<<endl;
                    
                    ofSetColor(255,255,255,100);
                    ofFill();
                    ofRect(log10(agent.processor->freqMin),
                           1,
                           log10(agent.processor->freqMax)-log10(agent.processor->freqMin),
                           -1*agent.processor->value() );*/
                }ofPopMatrix();
            }
            
        } ofPopMatrix();
        
        
    } ofPopMatrix();
}

- (int) freqAtX:(int)x{
    float n = x / (float)ofGetWidth();
    n = n  * (log10(maxFreq) - log10(minFreq));
    n += log10(minFreq);
    float freq = pow(10,n);
    return freq;
}

-(float)dbAtY:(int)y{
    
    float v = y / (float)ofGetHeight();
    v *= -100;

    return v;
    /*
    ofScale(1, 1.0/fabs(viewMaxDb - viewMinDb));
    ofTranslate(0, -viewMinDb);
    
    ofTranslate(0,-100);
    ofScale(1, -1);*/

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
    [self dbAtY:p.y];
}

- (void)mouseDragged:(NSPoint)p button:(int)button
{
    [[self selectedAgent] setInputFreqMax:[self freqAtX:p.x]];
    [[self selectedAgent] setInputMinDb:[self dbAtY:p.y]];
  //  agent.freqMax = [self freqAtX:p.x];

}

- (void)mousePressed:(NSPoint)p button:(int)button
{
    [[self selectedAgent] setInputFreqMin:[self freqAtX:p.x]];
    [[self selectedAgent] setInputMaxDb:[self dbAtY:p.y]];
   // agent.freqMin = [self freqAtX:p.x];

   // cout<<"min "<<agent.freqMin<<endl;
}

- (void)mouseReleased:(NSPoint)p button:(int)button
{
        [[self selectedAgent] setInputFreqMax:[self freqAtX:p.x]];
        [[self selectedAgent] setInputMinDb:[self dbAtY:p.y]];
   // agent.freqMax = [self freqAtX:p.x];
    //cout<<"max "<<agent.freqMax<<endl;
}

- (void)windowResized:(NSSize)size
{
	
}

@end