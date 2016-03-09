//
//  PlayState.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayState.h"
#import "nupogodiAppDelegate.h"

@implementation PlayState

- (void) dealloc
{
    [controller release];
    [super dealloc];
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        controller = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    }
    
    return self;
}

- (void) Run
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.document.playStateContent setValue:[NSNumber numberWithFloat:0.8] forKey:@"playTimer1"];
    [app.document.playStateContent setValue:[NSNumber numberWithFloat:0.65] forKey:@"playTimer2"];
    [app.document.playStateContent setValue:[NSNumber numberWithFloat:0.55] forKey:@"playTimer3"];
    
    if (version < 5)
    {
        [self performSelector:@selector(delayedRun) withObject:nil afterDelay:0.1];
    }
    else
    {
        [app.viewController presentModalViewController:controller animated:NO];
    }
}

- (void) delayedRun
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.viewController presentModalViewController:controller animated:YES];
}

- (void) Stop
{
    [controller dismissModalViewControllerAnimated:NO];
}

- (void) Pause
{
    [controller Pause];
}

@end
