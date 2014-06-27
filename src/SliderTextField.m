//
//  SliderTextField.m
//  Soundalizer
//
//  Created by flux on 26/06/2014.
//
//

#import "SliderTextField.h"

@implementation SliderTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib{
    [self setSelectable:false];
    [self setEditable:false];
  
    [self setBordered:false];
    
    
//    [self setDrawsBackground:false];

}

- (void)resetCursorRects
{
    
    [self addCursorRect:[self bounds] cursor:[NSCursor resizeLeftRightCursor]];
}

- (void)drawRect:(NSRect)dirtyRect
{
//    NSLog(@"%f", self.floatValue);
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)mouseDragged:(NSEvent *)theEvent{
    dragged = true;
    [self setSelectable:false];
    [self setEditable:false];
    float deltaX = [theEvent deltaX];
    
    float val = self.floatValue;
    float delta = MAX(3,fabs(val))*0.01*deltaX;
    val += delta;

    
    if(self.formatter){
        NSNumberFormatter * formatter = self.formatter;
        if(formatter.minimum){
            val = MAX([formatter.minimum floatValue], val);
        }
        
        if(formatter.maximum){
            val = MIN([formatter.maximum floatValue], val);
        }
    }
    
    [self setFloatValue:val];
    NSDictionary *bindingInfo = [self infoForBinding:NSValueBinding];
    [[bindingInfo valueForKey:NSObservedObjectKey] setValue:[NSNumber numberWithFloat:self.floatValue]
                                                 forKeyPath:[bindingInfo valueForKey:NSObservedKeyPathKey]];
    
    [[self window] makeFirstResponder:nil];

   /* CGPoint p = CGPointMake(mouseLoc.x, mouseLoc.y);
    CGWarpMouseCursorPosition(p);
*/

}
-(void)mouseDown:(NSEvent *)theEvent{
    [self setSelectable:true];
    [self setEditable:true];


    CGEventRef ourEvent = CGEventCreate(NULL);
    mouseLoc = CGEventGetLocation(ourEvent);
    
    dragged = false;
        //[NSCursor hide];
}

-(void)mouseUp:(NSEvent *)theEvent{
    if(dragged){
        [self setSelectable:false];
        [self setEditable:false];
    }
    
}



@end
