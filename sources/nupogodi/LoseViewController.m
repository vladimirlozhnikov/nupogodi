//
//  LoseViewController.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 27.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoseViewController.h"
#import "nupogodiAppDelegate.h"
#import "MenuState.h"

@implementation LoseViewController
@synthesize bg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(showAlertDelay) withObject:nil afterDelay:0.5];
}

- (void) showAlertDelay
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* message = app.settings.English ? @"Try again" : @"Играть еще раз";
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app nextState:[[MenuState alloc] init]];
}

@end
