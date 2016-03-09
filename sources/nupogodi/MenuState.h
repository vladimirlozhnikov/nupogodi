//
//  MenuState.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
#import "MenuViewController.h"

@interface MenuState : NSObject <State>
{
    MenuViewController* controller;
}

- (void) Run;
- (void) Stop;
- (void) Pause;

@end
