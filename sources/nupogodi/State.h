//
//  State.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol State <NSObject>

- (void) Run;
- (void) Stop;
- (void) Pause;

@end
