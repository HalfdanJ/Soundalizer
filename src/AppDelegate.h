#import "ofxCocoaGLView.h"
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow *window;
    ofxCocoaGLView* mainView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet ofxCocoaGLView* mainView;

- (NSString *) pathForDataFile;
- (void) saveDataToDisk;
- (void) loadDataFromDisk;


@end    
