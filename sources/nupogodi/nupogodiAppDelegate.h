//
//  nupogodiAppDelegate.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "State.h"
#import "Document.h"
#import "Settings.h"
#import <AVFoundation/AVFoundation.h>

@class nupogodiViewController;

@interface nupogodiAppDelegate : NSObject <UIApplicationDelegate>
{
    id<State> currentState;
    Document* document;
    Settings* settings;
    
    SystemSoundID soundEgg1;
    SystemSoundID soundEgg2;
    SystemSoundID soundEgg3;
    SystemSoundID soundEgg4;
    SystemSoundID soundCatch;
    SystemSoundID soundFail;
    SystemSoundID soundFinish;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet nupogodiViewController *viewController;
@property (readonly) Document* document;
@property (readonly) Settings* settings;

- (void) nextState:(id<State>)state;

-(void) playSound:(NSString*)file;

@end
