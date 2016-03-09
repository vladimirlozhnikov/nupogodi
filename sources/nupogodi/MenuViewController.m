//
//  MenuViewController.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "PlayState.h"
#import "nupogodiAppDelegate.h"
#import "TestFlight.h"

@implementation MenuViewController
@synthesize background, playButton;

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

- (void) localizable
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.settings.English)
    {
        [self.playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [self.playButton setTitle:@"PLAY" forState:UIControlStateHighlighted];
        self.background.image = [UIImage imageNamed:@"nu_bg_eng.png"];
    }
    else
    {
        [self.playButton setTitle:@"ИГРАТЬ" forState:UIControlStateNormal];
        [self.playButton setTitle:@"ИГРАТЬ" forState:UIControlStateHighlighted];
        self.background.image = [UIImage imageNamed:@"nu_bg.png"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self localizable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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

- (IBAction)playClicked:(id)sender
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app nextState:[[PlayState alloc] init]];
}

- (IBAction)englishButtonClicked:(id)sender
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    app.settings.English = YES;
    [app.settings save];
    [self localizable];
}

- (IBAction)russianButtonClicked:(id)sender
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    app.settings.English = NO;
    [app.settings save];
    [self localizable];
}

@end
