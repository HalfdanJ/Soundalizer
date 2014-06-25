

#import "AppDelegate.h"
//#import "AudioAgent.h"

@implementation AppDelegate

@synthesize window, mainView;

-(id)init{
    self =  [super init];
    
    return self;
}

-(void)awakeFromNib{
    
}


- (void)dealloc
{
    [super dealloc];
}


-(void)changeColor:(id)sender
{
    [mainView changeColor:self];
}


@end
