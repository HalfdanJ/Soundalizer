#import "OutputDestination.h"
#import "AudioAgent.h"

@implementation OutputDestination
@synthesize hostname, port;

-(id)init{
    self = [super init];
    if(self){
        [self addObserver:self forKeyPath:@"hostname" options:0 context:nil];
        [self addObserver:self forKeyPath:@"port" options:0 context:nil];

        self.hostname = @"localhost";
        self.port = 8888;
        NSLog(@"Init output");
        
    }
    return self;
}

-(void)update:(NSArray *)agents{
    for(AudioAgent * agent in agents){
        if(agent.oscAddress && agent.oscAddress.length > 0){
            ofxOscMessage msg;
            msg.setAddress([agent.oscAddress cStringUsingEncoding:NSUTF8StringEncoding]);
            msg.addFloatArg(agent.processor->value());
            msg.addFloatArg(agent.processor->speedValue());
            osc.sendMessage(msg);
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualTo:@"hostname"] || [keyPath isEqualTo:@"port"]){
        if(self.hostname && self.port){
            osc.setup([self.hostname cStringUsingEncoding:NSUTF8StringEncoding], self.port);
        }
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"hostname"];
    [self removeObserver:self forKeyPath:@"port"];
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if(self){
        self.hostname = [aDecoder decodeObjectForKey:@"hostname"];
        self.port = [aDecoder decodeIntegerForKey:@"port"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.hostname forKey:@"hostname"];
    [aCoder encodeInteger:self.port forKey:@"port"];
}

@end
