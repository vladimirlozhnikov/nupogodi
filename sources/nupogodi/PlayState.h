//
//  PlayState.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
#import "PlayViewController.h"

@interface PlayState : NSObject <State>
{
    PlayViewController* controller;
}

- (void) Run;
- (void) Stop;
- (void) Pause;

@end
