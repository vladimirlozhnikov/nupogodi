//
//  Document.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
{
    NSMutableDictionary* playStateContent;
}

@property (nonatomic, retain) NSMutableDictionary* playStateContent;

@end
