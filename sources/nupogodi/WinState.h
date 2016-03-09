//
//  WinState.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 27.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
#import "WinViewController.h"

@interface WinState : NSObject <State>
{
    WinViewController* controller;
}

- (void) Run;
- (void) Stop;
- (void) Pause;

@end
