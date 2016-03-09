//
//  Document.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize playStateContent;

- (id) init
{
    self = [super init];
    if (self)
    {
        playStateContent = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [playStateContent release];
    
    [super dealloc];
}

@end
