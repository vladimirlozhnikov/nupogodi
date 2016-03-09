//
//  Settings.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (id) init
{
    self = [super init];
    if (self)
    {
        NSString* path = [self getPath];
        
        if (path != nil)
        {
            content = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
    }
    
    return self;
}

- (void) dealloc
{
    [content release];
    [super dealloc];
}

- (void) save
{
    NSString* path = [self getPath];
    if (path != nil)
    {
        [content writeToFile:path atomically:NO];
    }
}

- (BOOL) English
{
    BOOL push = [[content valueForKey:@"English"] boolValue];
    return push;
}

- (void) setEnglish:(BOOL)en
{
    [content setValue:[NSNumber numberWithBool:en] forKey:@"English"];
}

- (NSString*) getPath
{
    NSFileManager* manager= [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents = [paths objectAtIndex:0];
    NSString* str = [NSString stringWithFormat:@"%@.%@", @"Settings", @"plist"];
    NSString* alerts = [[NSString alloc] initWithString:[documents stringByAppendingPathComponent:str]];
    
    if ([manager fileExistsAtPath:alerts] == NO)
    {
        NSString* pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        if ([manager copyItemAtPath:pathToDefaultPlist toPath:alerts error:nil] == NO)
        {
            [alerts release];
            return nil;
        }
    }
    
    return [alerts autorelease];
}

@end
