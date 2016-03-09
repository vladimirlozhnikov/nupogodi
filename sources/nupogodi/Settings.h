//
//  Settings.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject
{
    NSMutableDictionary* content;
}

@property (assign) BOOL English;

- (void) save;

@end
