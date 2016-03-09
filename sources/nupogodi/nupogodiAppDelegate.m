//
//  nupogodiAppDelegate.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nupogodiAppDelegate.h"
#import "nupogodiViewController.h"
#import "MenuState.h"

@interface nupogodiAppDelegate (Private)

- (void) releaseCurrentState;
- (void) runCurrentStateState;

@end

@implementation nupogodiAppDelegate
@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize document, settings;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    document = [[Document alloc] init];
    settings = [[Settings alloc] init];
    
    NSURL* urlEgg1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"egg1" ofType:@"wav"]];
    NSURL* urlEgg2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"egg2" ofType:@"wav"]];
    NSURL* urlEgg3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"egg3" ofType:@"wav"]];
    NSURL* urlEgg4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"egg4" ofType:@"wav"]];
    NSURL* urlCatch = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"catch" ofType:@"wav"]];
    NSURL* urlFail = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"]];
    NSURL* urlFinish = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"finish" ofType:@"wav"]];
    
    AudioServicesCreateSystemSoundID((CFURLRef)urlEgg1, &soundEgg1);
    AudioServicesCreateSystemSoundID((CFURLRef)urlEgg2, &soundEgg2);
    AudioServicesCreateSystemSoundID((CFURLRef)urlEgg3, &soundEgg3);
    AudioServicesCreateSystemSoundID((CFURLRef)urlEgg4, &soundEgg4);
    AudioServicesCreateSystemSoundID((CFURLRef)urlCatch, &soundCatch);
    AudioServicesCreateSystemSoundID((CFURLRef)urlFail, &soundFail);
    AudioServicesCreateSystemSoundID((CFURLRef)urlFinish, &soundFinish);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    MenuState* menuState = [[MenuState alloc] init];
    [self nextState:menuState];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [currentState Pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    AudioServicesDisposeSystemSoundID(soundEgg1);
    AudioServicesDisposeSystemSoundID(soundEgg2);
    AudioServicesDisposeSystemSoundID(soundEgg3);
    AudioServicesDisposeSystemSoundID(soundEgg4);
    AudioServicesDisposeSystemSoundID(soundCatch);
    AudioServicesDisposeSystemSoundID(soundFail);
    AudioServicesDisposeSystemSoundID(soundFinish);
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [self releaseCurrentState];
    [document release];
    [settings release];
    
    [super dealloc];
}

- (void) releaseCurrentState
{
    [currentState Stop];
    [currentState release];
}

- (void) nextState:(id<State>)state
{
    [self releaseCurrentState];
    
    currentState = state;
    [self performSelector:@selector(runCurrentStateState) withObject:nil afterDelay:0.1];
}

- (void) runCurrentStateState
{
    [currentState Run];
}

-(void) playSound:(NSString*)file
{
    if ([file isEqualToString:@"egg1"])
    {
        AudioServicesPlaySystemSound(soundEgg1);
    }
    else if ([file isEqualToString:@"egg2"])
    {
        AudioServicesPlaySystemSound(soundEgg2);
    }
    else if ([file isEqualToString:@"egg3"])
    {
        AudioServicesPlaySystemSound(soundEgg3);
    }
    else if ([file isEqualToString:@"egg4"])
    {
        AudioServicesPlaySystemSound(soundEgg4);
    }
    else if ([file isEqualToString:@"catch"])
    {
        AudioServicesPlaySystemSound(soundCatch);
    }
    else if ([file isEqualToString:@"fail"])
    {
        AudioServicesPlaySystemSound(soundFail);
    }
    else if ([file isEqualToString:@"finish"])
    {
        AudioServicesPlaySystemSound(soundFinish);
    }
}

@end
