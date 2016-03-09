//
//  MenuState.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuState.h"
#import "nupogodiAppDelegate.h"

@implementation MenuState

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
        controller = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    }
    
    return self;
}

- (void) Run
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version < 5)
    {
        [self performSelector:@selector(delayedRun) withObject:nil afterDelay:0.1];
    }
    else
    {
        nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
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
}

@end
