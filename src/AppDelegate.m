#import "AppDelegate.h"
//#import "AudioAgent.h"

@implementation AppDelegate

@synthesize window, mainView;

-(id)init{
    self =  [super init];
    
    return self;
}

- (void) awakeFromNib
{
    [NSApp setDelegate: self];
    [self loadDataFromDisk];
}

- (void)dealloc
{
    [super dealloc];
}


- (NSString *) pathForDataFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = @"~/Library/Application Support/Soundalizer/";
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO)
    {
        [fileManager createDirectoryAtPath: folder attributes: nil];
    }
    
    NSString *fileName = @"Soundalizer.plist";
    return [folder stringByAppendingPathComponent: fileName];
}

- (void) saveDataToDisk
{
    NSString * path = [self pathForDataFile];
    
    NSMutableDictionary * rootObject;
    rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue: [[self mainView] agents] forKey:@"agents"];
    [NSKeyedArchiver archiveRootObject: rootObject toFile: path];
}

- (void) applicationWillTerminate: (NSNotification *)note
{
    [self saveDataToDisk];
}


- (void) loadDataFromDisk
{
    NSString     * path        = [self pathForDataFile];
    NSDictionary * rootObject;
    
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [[self mainView] loadAgents: [rootObject valueForKey:@"agents"]];
}
@end
