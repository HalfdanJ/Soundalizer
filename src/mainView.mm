#import "mainView.h"
#include <stdlib.h>

@implementation mainView
@synthesize  agentsArrayController, agents, destinationsArrayController, addressesArrayController;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    //
    self.agents = [NSMutableArray array];
    
    analyzer.setup();
    
    outputTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.
                                                      target:self selector:@selector(updateOutputs)
                                                    userInfo:nil repeats:YES];
    
    return self;
}


-(void)addAgent{
    AudioAgent * newAgent = [[AudioAgent alloc] initWithAnalyzer:&analyzer];
    newAgent.name = [NSString stringWithFormat:@"Agent %i", self.agents.count+1];;
    newAgent.oscAddress = [NSString stringWithFormat:@"/soundalizer/output%i",self.agents.count+1];
    [self.agentsArrayController addObject:newAgent];
}

-(AudioAgent *)selectedAgent{
    if([agentsArrayController selectedObjects].count == 0){
        return nil;
    }
    return [[agentsArrayController selectedObjects] objectAtIndex:0];
}


- (void) loadAgents: (NSArray*)_agents{
    for(AudioAgent* agent in _agents){
        [agent setAnalyzer:&analyzer];
        [self.agentsArrayController addObject:agent];
    }
}

- (NSArray*) outputs{
    return self.destinationsArrayController.content;
}



- (void) loadAddresses: (NSArray*)_addresses{
    NSRange range = NSMakeRange(0, [[self.addressesArrayController arrangedObjects] count]);
    [self.addressesArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    for(NSDictionary * adr in _addresses){
        [self.addressesArrayController addObject:adr];
    }}

- (NSArray*) addresses{
    return self.addressesArrayController.content;
}

- (void) loadOutputs: (NSArray*)outputs{
    NSRange range = NSMakeRange(0, [[self.destinationsArrayController arrangedObjects] count]);
    [self.destinationsArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    for(OutputDestination * dest in outputs){
        [self.destinationsArrayController addObject:dest];
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


- (void) updateOutputs {
    for(OutputDestination * dest in self.destinationsArrayController.content){
        [dest update:self.agents];
    }
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

        ofSetColor(255,10);
        for(int i=10;i<100;i+=10){
            ofLine(log10(i),viewMinDb,log10(i),viewMaxDb);
        }
        for(int i=100;i<1000;i+=100){
            ofLine(log10(i),viewMinDb,log10(i),viewMaxDb);
        }
        for(int i=1000;i<10000;i+=1000){
            ofLine(log10(i),viewMinDb,log10(i),viewMaxDb);
        }
        for(int i=10000;i<30000;i+=10000){
            ofLine(log10(i),viewMinDb,log10(i),viewMaxDb);
        }
        
       
        //Max values
        ofSetColor(ofColor().fromHex(0x555555));
        for(int i=0;i<bufferSize;i++){
            float frequency = analyzer.indexToFreq(i);
            float x = log10(frequency) ;
            float db = 20*log10(analyzer.maxValues[i]);
            
            ofLine(x, -100, x, db);
        }

        glLineWidth(2.0);
  
        //Waves
        ofSetColor(ofColor().fromHex(0xFF3D00));
        float max = 0;
        for(int i=0;i<bufferSize;i++){
            float frequency = analyzer.indexToFreq(i);
            float x = log10(frequency) ;
            float db = 20*log10(analyzer.filtederValues[i]);
            
            if(max < analyzer.filtederValues[i])
                max = analyzer.filtederValues[i];
            
            ofLine(x, -100, x, db);
            
        }
        
               glLineWidth(1.0);

        
        ofPushMatrix();{
            ofScale(1, -100);

            //Agent
            for(int i=0;i<[agents count]; i++){
                AudioAgent * agent = [agents objectAtIndex:i];
                bool selected = false;
                if([self selectedAgent] == agent){
                    selected = true;
                }
                ofPushMatrix();{
                    ofTranslate(log10(agent.processor->freqMin), -1-agent.inputMinDb/100.0 + 1);
                    ofScale(log10(agent.processor->freqMax)-log10(agent.processor->freqMin),-((agent.inputMaxDb-agent.inputMinDb)/100.));
                    
                    //Bounds
                    ofNoFill();
                    ofSetColor(255,200);
                    if(selected)
                        ofSetColor(255,200,50,200);
                    
                    ofRect(0, 0, 1, 1 );
                    
                    //Background
                    ofFill();
                    ofSetColor(255,20);
                    if(selected)
                        ofSetColor(255,200,50,20);
                    ofRect(0, 0, 1, 1 );
                    
                    //Value
                    ofSetColor(255,255,255,100);
                    ofFill();
                    ofRect(0,0, 1, agent.processor->value() );

                }ofPopMatrix();
            }
            
        } ofPopMatrix();
        
        
    } ofPopMatrix();
}

- (AudioAgent*) agentUnderMouse{
    for(AudioAgent* agent in self.agents){
        int freq = [self freqAtX:ofGetMouseX()];
        float db = [self dbAtY:ofGetMouseY()];
        
        if(agent.inputFreqMin <= freq && agent.inputFreqMax >= freq){
            if(agent.inputMinDb <= db && agent.inputMaxDb >= db){
                return agent;
            }
        }
    }
    return nil;
}

- (int) selectionHookUnderMouse {
    AudioAgent * agent = [self agentUnderMouse];
    if(!agent){
        return None;
    }

    int ret = None;
    
    int freq = [self freqAtX:ofGetMouseX()];
    float db = [self dbAtY:ofGetMouseY()];

    if(fabs([self xAtFreq:agent.inputFreqMin] - ofGetMouseX()) < 10){
        ret |= Left;
    }
    else if(fabs([self xAtFreq:agent.inputFreqMax] - ofGetMouseX()) < 10){
        ret |= Right;
    }
    if(fabs([self yAtDb:agent.inputMinDb] - ofGetMouseY()) < 10){
        ret |= Bottom;
    }
    else if(fabs([self yAtDb:agent.inputMaxDb] - ofGetMouseY()) < 10){
        ret |= Top;
    }
    
    return ret;

    
    //if(fabs(freq-agent.inputFreqMin)
}

- (float) freqAtX:(float)x{
    double n = x;
    n = n / (double)ofGetWidth();
    n = n  * (double)(log10(maxFreq) - log10(minFreq));
    n += log10(minFreq);
    n = pow(10,n);
    return n;
}

-(float)dbAtY:(float)y{
    
    double v = y / (double)ofGetHeight();
    v *= -100;
    
    return v;
}
- (float) xAtFreq:(float)freq{
    double v = (double)freq;
    v = log10(v);
    v -=  log10(minFreq);
    v = v / (double)(log10(maxFreq) - log10(minFreq));
    v = v * (double)ofGetWidth();/**/
    return v;
    
}
- (float) yAtDb:(float)db{
    float v = db;
    v /= -100;
    v *= ofGetHeight();
    return v;
}




- (void)exit
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
 //   cout<<p.x<<"  "<<[self xAtFreq:[self freqAtX:p.x]]<<endl;
//    [self dbAtY:p.y];
    int h = [self selectionHookUnderMouse];

    if(h == Left || h == Right){
        [[NSCursor resizeLeftRightCursor] set];
    } else if(h == Top || h == Bottom){
        [[NSCursor resizeUpDownCursor] set];
    } else if(h != None){
        [[NSCursor crosshairCursor] set];
    }else if([self agentUnderMouse]){
        [[NSCursor openHandCursor] set];
    } else {
        [[NSCursor arrowCursor] set];
    }
    

}

- (void)mouseDragged:(NSPoint)p button:(int)button
{
/*    [[self selectedAgent] setInputFreqMax:[self freqAtX:p.x]];
    [[self selectedAgent] setInputMinDb:[self dbAtY:p.y]];*/
    AudioAgent * agent = [self selectedAgent];
    if(!agent){
        return;
    }
    
    if(selectedHook == None){
        {
            float x = [self xAtFreq:agent.inputFreqMin];
            float diff = x - lastMousePoint.x;
            agent.inputFreqMin = [self freqAtX:p.x+diff];
        }
        {
            float x = [self xAtFreq:agent.inputFreqMax];
            float diff = x - lastMousePoint.x;
            agent.inputFreqMax = [self freqAtX:p.x+diff];
        }
        {
            float y = [self yAtDb:agent.inputMaxDb];
            float diff = y - lastMousePoint.y;
            agent.inputMaxDb = [self dbAtY:p.y+diff];
        }
        {
            float y = [self yAtDb:agent.inputMinDb];
            float diff = y - lastMousePoint.y;
            agent.inputMinDb = [self dbAtY:p.y+diff];
        }
        
    
    }
    else {
        if(selectedHook & Left){
            agent.inputFreqMin = [self freqAtX:p.x];
        }
        if(selectedHook & Right){
            agent.inputFreqMax = [self freqAtX:p.x];
        }
        if(selectedHook & Top){
            agent.inputMaxDb = [self dbAtY:p.y];
        }
        if(selectedHook & Bottom){
            agent.inputMinDb = [self dbAtY:p.y];
        }

    }
    lastMousePoint = p;

}

- (void)mousePressed:(NSPoint)p button:(int)button
{
    [self.agentsArrayController setSelectedObjects:@[  ]];

    if([self agentUnderMouse]){
        [self.agentsArrayController setSelectedObjects:@[ [self agentUnderMouse] ]];
    }
    
    selectedHook = [self selectionHookUnderMouse];
    lastMousePoint = p;
    
/*    [[self selectedAgent] setInputFreqMin:[self freqAtX:p.x]];
    [[self selectedAgent] setInputMaxDb:[self dbAtY:p.y]];*/
}

- (void)mouseReleased:(NSPoint)p button:(int)button
{
     /*   [[self selectedAgent] setInputFreqMax:[self freqAtX:p.x]];
        [[self selectedAgent] setInputMinDb:[self dbAtY:p.y]];*/
    
    
}

- (void)windowResized:(NSSize)size
{
	
}

@end