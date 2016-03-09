//
//  PlayViewController.m
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"
#import "nupogodiAppDelegate.h"
#import "LoseState.h"
#import "WinState.h"

@interface NSNumber (CustomSorting)
- (NSComparisonResult) sortRabbits:(NSNumber*)otherNumber;
@end

@interface PlayViewController (Private)

- (void) initialization;
- (void) redrawGame:(BOOL)redrawAll;
- (BOOL) random;
- (void) randomRabbits;
- (void) eggIsDown;
- (void) lose;
- (void) win;

@end

@implementation PlayViewController
@synthesize background, wolf, leftUpButton, leftDownButton, rightUpButton, rightDownButton;

// left top
@synthesize l_t_egg1, l_t_egg2, l_t_egg3, l_t_egg4, l_t_egg5;

// left bottom
@synthesize l_b_egg1, l_b_egg2, l_b_egg3, l_b_egg4, l_b_egg5;

// right top
@synthesize r_t_egg1, r_t_egg2, r_t_egg3, r_t_egg4, r_t_egg5;

// right bottom
@synthesize r_b_egg1, r_b_egg2, r_b_egg3, r_b_egg4, r_b_egg5;

// score
@synthesize score1, score2, score3;

// broken eggs
@synthesize broken_egg1, broken_egg2, broken_egg3, broken_egg4;

// broken egg in left
@synthesize left_broken_egg, left_chicken_up, left_chicken_run1, left_chicken_run2, left_chicken_run3;

// broken egg in right
@synthesize right_broken_egg, right_chicken_up, right_chicken_run1, right_chicken_run2, right_chicken_run3;

// rabbit zapadlist
@synthesize rabbit;

// buttons
@synthesize startButton, pauseButton, bombButton, soundOffButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        wolfPosition = WP_RightUp;
        shelfPosition = SP_RightUp;
        
        leftUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        leftDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        
        brokenEggs = 0;
        score = 0;
        rabbitIndex = 0;
        rabbits = [[NSMutableArray alloc] init];
        bombAnimation = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [bombAnimation release];
    [rabbits release];
    [leftUpContent release];
    [leftDownContent release];
    [rightUpContent release];
    [rightDownContent release];
    
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
    
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.settings.English)
    {
        self.background.image = [UIImage imageNamed:@"nu_bg_eng.png"];
    }
    [self initialization];
    
    // arrow buttons
    [leftUpButton addTarget:self action:@selector(leftUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftDownButton addTarget:self action:@selector(leftDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightUpButton addTarget:self action:@selector(rightUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightDownButton addTarget:self action:@selector(rightDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // buttons
    [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton addTarget:self action:@selector(pauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bombButton addTarget:self action:@selector(bombButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [soundOffButton addTarget:self action:@selector(soundOffButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_1.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_2.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_3.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_4.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_5.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_6.png"]];
    [bombAnimation addObject:[UIImage imageNamed:@"FIREBALL_7.png"]];
    
    //[self randomRabbits];
    [self redrawGame:NO];
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

- (void) initialization
{
    l_t_egg1.image = [UIImage imageNamed:@"egg_top_left_1.png"];
    l_t_egg2.image = [UIImage imageNamed:@"egg_top_left_2.png"];
    l_t_egg3.image = [UIImage imageNamed:@"egg_top_left_3.png"];
    l_t_egg4.image = [UIImage imageNamed:@"egg_top_left_4.png"];
    l_t_egg5.image = [UIImage imageNamed:@"egg_top_left_5.png"];
    
    l_b_egg1.image = [UIImage imageNamed:@"egg_top_left_1.png"];
    l_b_egg2.image = [UIImage imageNamed:@"egg_top_left_2.png"];
    l_b_egg3.image = [UIImage imageNamed:@"egg_top_left_3.png"];
    l_b_egg4.image = [UIImage imageNamed:@"egg_top_left_4.png"];
    l_b_egg5.image = [UIImage imageNamed:@"egg_top_left_5.png"];
    
    r_t_egg1.image = [UIImage imageNamed:@"egg_top_right_1.png"];
    r_t_egg2.image = [UIImage imageNamed:@"egg_top_right_2.png"];
    r_t_egg3.image = [UIImage imageNamed:@"egg_top_right_3.png"];
    r_t_egg4.image = [UIImage imageNamed:@"egg_top_right_4.png"];
    r_t_egg5.image = [UIImage imageNamed:@"egg_top_right_5.png"];
    
    r_b_egg1.image = [UIImage imageNamed:@"egg_top_right_1.png"];
    r_b_egg2.image = [UIImage imageNamed:@"egg_top_right_2.png"];
    r_b_egg3.image = [UIImage imageNamed:@"egg_top_right_3.png"];
    r_b_egg4.image = [UIImage imageNamed:@"egg_top_right_4.png"];
    r_b_egg5.image = [UIImage imageNamed:@"egg_top_right_5.png"];
    
    l_t_egg1.hidden = YES;
    l_t_egg2.hidden = YES;
    l_t_egg3.hidden = YES;
    l_t_egg4.hidden = YES;
    l_t_egg5.hidden = YES;
    
    l_b_egg1.hidden = YES;
    l_b_egg2.hidden = YES;
    l_b_egg3.hidden = YES;
    l_b_egg4.hidden = YES;
    l_b_egg5.hidden = YES;
    
    r_t_egg1.hidden = YES;
    r_t_egg2.hidden = YES;
    r_t_egg3.hidden = YES;
    r_t_egg4.hidden = YES;
    r_t_egg5.hidden = YES;
    
    r_b_egg1.hidden = YES;
    r_b_egg2.hidden = YES;
    r_b_egg3.hidden = YES;
    r_b_egg4.hidden = YES;
    r_b_egg5.hidden = YES;
}

- (void) leftUpButtonClicked:(id)sender
{
    wolfPosition = WP_LeftUp;
    [self redrawGame:NO];
}

- (void) leftDownButtonClicked:(id)sender
{
    wolfPosition = WP_LeftDown;
    [self redrawGame:NO];
}

- (void) rightUpButtonClicked:(id)sender
{
    wolfPosition = WP_RightUp;
    [self redrawGame:NO];
}

- (void) rightDownButtonClicked:(id)sender
{
    wolfPosition = WP_RightDown;
    [self redrawGame:NO];
}

- (void) startButtonClicked:(id)sender
{
    if (!start)
    {
        start = YES;
        pause = NO;
        [startButton setBackgroundImage:[UIImage imageNamed:@"button_gr.png"] forState:UIControlStateNormal];
        [pauseButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [self performSelector:@selector(startWithDelay) withObject:nil afterDelay:0.2];
    }
}

- (void) startWithDelay
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [timer invalidate];
    timer = nil;
    
    NSNumber* n = nil;
    if (score < 50)
    {
        n = [app.document.playStateContent objectForKey:@"playTimer1"];
    }
    else if (score < 400)
    {
        n = [app.document.playStateContent objectForKey:@"playTimer2"];
    }
    else
    {
        n = [app.document.playStateContent objectForKey:@"playTimer3"];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:[n floatValue] target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void) pauseButtonClicked:(id)sender
{
    if (!pause)
    {
        pause = YES;
        start = NO;
        [pauseButton setBackgroundImage:[UIImage imageNamed:@"button_gr.png"] forState:UIControlStateNormal];
        [startButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [timer invalidate];
        timer = nil;
    }
}

- (void) bombButtonClicked:(id)sender
{
    if (!start) return;
    
    bomb = !bomb;
    
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (bomb)
    {
        [bombButton setBackgroundImage:[UIImage imageNamed:@"button_gr.png"] forState:UIControlStateNormal];
        
        NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer3"];
        [timer invalidate];
        timer = nil;
        
        [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
    }
    else
    {
        [bombButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        if (score < 50)
        {
            [timer invalidate];
            timer = nil;
            
            NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer1"];
            [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
        }
        else if (score < 400)
        {
            [timer invalidate];
            timer = nil;
            
            NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer2"];
            [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
        }
        else
        {
            [timer invalidate];
            timer = nil;
            
            nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer3"];
            [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
        }
    }
}

- (void) soundOffButtonClicked:(id)sender
{
    soundOff = !soundOff;
    
    if (soundOff)
    {
        [soundOffButton setBackgroundImage:[UIImage imageNamed:@"button_gr.png"] forState:UIControlStateNormal];
    }
    else
    {
        [soundOffButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void) redrawGame:(BOOL)redrawAll
{
    // redraw wolf
    NSString* wolfName = nil;
    switch (wolfPosition)
    {
        case WP_LeftUp:
            wolfName = @"wolf_4_top.png";
            break;
        case WP_LeftDown:
            wolfName = @"wolf_4.png";
            break;
        case WP_RightUp:
            wolfName = @"wolf_1_top.png";
            break;
        case WP_RightDown:
            wolfName = @"wolf_1.png";
            break;
    }
    
    if (wolfName)
    {
        self.wolf.image = [UIImage imageNamed:wolfName];
    }
    
    // redraw score
    NSInteger h = score / 100;
    NSInteger m = (score - h * 100) / 10;
    NSInteger l = score % 10;
    
    NSString* h_name = [NSString stringWithFormat:@"%d.png", h];
    NSString* m_name = [NSString stringWithFormat:@"%d.png", m];
    NSString* l_name = [NSString stringWithFormat:@"%d.png", l];
    
    score1.image = [UIImage imageNamed:h_name];
    score2.image = [UIImage imageNamed:m_name];
    score3.image = [UIImage imageNamed:l_name];
    
    // draw broken eggs
    NSString* brokenName1 = nil;
    NSString* brokenName2 = nil;
    NSString* brokenName3 = nil;
    NSString* brokenName4 = nil;
    
    if (brokenEggs > 0)
    {
        brokenName4 = @"chicken_egg_left.png";
    }
    if (brokenEggs > 1)
    {
        brokenName3 = @"chicken_egg_left.png";
    }
    if (brokenEggs > 2)
    {
        brokenName2 = @"chicken_egg_left.png";
    }
    if (brokenEggs > 3)
    {
        brokenName1 = @"chicken_egg_left.png";
    }
    
    broken_egg1.image = [UIImage imageNamed:brokenName1];
    broken_egg2.image = [UIImage imageNamed:brokenName2];
    broken_egg3.image = [UIImage imageNamed:brokenName3];
    broken_egg4.image = [UIImage imageNamed:brokenName4];
    
    // redraw other
    if (redrawAll)
    {
        // show rabbit zapadlist 2 times
        /*int rabbitScore = [[rabbits objectAtIndex:rabbitIndex] intValue];
        if (score >= (rabbitScore - 2))
        {
            rabbit.image = [UIImage imageNamed:@"hare.png"];
        }
        else
        {
            rabbit.image = nil;
        }*/
        
        // redraw left top shelf
        EggType luEgg1 = [[leftUpContent objectAtIndex:0] intValue];
        EggType luEgg2 = [[leftUpContent objectAtIndex:1] intValue];
        EggType luEgg3 = [[leftUpContent objectAtIndex:2] intValue];
        EggType luEgg4 = [[leftUpContent objectAtIndex:3] intValue];
        EggType luEgg5 = [[leftUpContent objectAtIndex:4] intValue];
        
        if (luEgg1 == ET_Simply)
        {
            //self.l_t_egg1.image = [UIImage imageNamed:@"egg_top_left_1.png"];
            self.l_t_egg1.hidden = NO;
            //self.l_t_egg1.frame = CGRectMake(105.0, 100.0 + 5.0, 8.0, 13.0);
        }
        else if (luEgg1 == ET_Bomb)
        {
            //self.l_t_egg1.image = [UIImage imageNamed:@"bomb_left_1.png"];
            //self.l_t_egg1.frame = CGRectMake(94.0, 87.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            self.l_t_egg1.hidden = YES;
            //self.l_t_egg1.image = nil;
        }
        
        if (luEgg2 == ET_Simply)
        {
            //self.l_t_egg2.image = [UIImage imageNamed:@"egg_top_left_2.png"];
            self.l_t_egg2.hidden = NO;
            //self.l_t_egg2.frame = CGRectMake(113.0, 106.0 + 5.0, 11.0, 13.0);
        }
        else if (luEgg2 == ET_Bomb)
        {
            //self.l_t_egg2.image = [UIImage imageNamed:@"bomb_left_2.png"];
            //self.l_t_egg2.frame = CGRectMake(104.0, 96.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_t_egg2.image = nil;
            self.l_t_egg2.hidden = YES;
        }
        
        if (luEgg3 == ET_Simply)
        {
            //self.l_t_egg3.image = [UIImage imageNamed:@"egg_top_left_3.png"];
            self.l_t_egg3.hidden = NO;
            //self.l_t_egg3.frame = CGRectMake(125.0, 112.0 + 5.0, 13.0, 12.0);
        }
        else if (luEgg3 == ET_Bomb)
        {
            //self.l_t_egg3.image = [UIImage imageNamed:@"bomb_left_3.png"];
            //self.l_t_egg3.frame = CGRectMake(117.0, 103.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_t_egg3.image = nil;
            self.l_t_egg3.hidden = YES;
        }
        
        if (luEgg4 == ET_Simply)
        {
            //self.l_t_egg4.image = [UIImage imageNamed:@"egg_top_left_4.png"];
            self.l_t_egg4.hidden = NO;
            //self.l_t_egg4.frame = CGRectMake(139.0, 122.0 + 5.0, 12.0, 10.0);
        }
        else if (luEgg4 == ET_Bomb)
        {
            //self.l_t_egg4.image = [UIImage imageNamed:@"bomb_left_4.png"];
            //self.l_t_egg4.frame = CGRectMake(130.0, 112.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_t_egg4.image = nil;
            self.l_t_egg4.hidden = YES;
        }
        
        if (luEgg5 == ET_Simply)
        {
            //self.l_t_egg5.image = [UIImage imageNamed:@"egg_top_left_5.png"];
            self.l_t_egg5.hidden = NO;
            //self.l_t_egg5.frame = CGRectMake(152.0, 129.0 + 5.0, 10.0, 14.0);
        }
        else if (luEgg5 == ET_Bomb)
        {
            /*self.l_t_egg5.frame = CGRectMake(142.0, 121.0 + 5.0, 30.0, 30.0);
            
            if (luEgg4 == ET_Empty)
            {
                self.l_t_egg5.animationImages = bombAnimation;
                self.l_t_egg5.animationRepeatCount = 1;
                [self.l_t_egg5 startAnimating];
            }
            else
            {
                self.l_t_egg5.image = [UIImage imageNamed:@"bomb_left_5.png"];
            }*/
        }
        else
        {
            //self.l_t_egg5.image = nil;
            self.l_t_egg5.hidden = YES;
        }
        
        // redraw left bottom shelf
        EggType lbEgg1 = [[leftDownContent objectAtIndex:0] intValue];
        EggType lbEgg2 = [[leftDownContent objectAtIndex:1] intValue];
        EggType lbEgg3 = [[leftDownContent objectAtIndex:2] intValue];
        EggType lbEgg4 = [[leftDownContent objectAtIndex:3] intValue];
        EggType lbEgg5 = [[leftDownContent objectAtIndex:4] intValue];
        
        if (lbEgg1 == ET_Simply)
        {
            //self.l_b_egg1.image = [UIImage imageNamed:@"egg_top_left_1.png"];
            self.l_b_egg1.hidden = NO;
            //self.l_b_egg1.frame = CGRectMake(105.0, 146.0 + 5.0, 8.0, 13.0);
        }
        else if (lbEgg1 == ET_Bomb)
        {
            //self.l_b_egg1.image = [UIImage imageNamed:@"bomb_left_1.png"];
            //self.l_b_egg1.frame = CGRectMake(94.0, 136.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_b_egg1.image = nil;
            self.l_b_egg1.hidden = YES;
        }
        
        if (lbEgg2 == ET_Simply)
        {
            //self.l_b_egg2.image = [UIImage imageNamed:@"egg_top_left_2.png"];
            self.l_b_egg2.hidden = NO;
            //self.l_b_egg2.frame = CGRectMake(114.0, 152.0 + 5.0, 11.0, 13.0);
        }
        else if (lbEgg2 == ET_Bomb)
        {
            //self.l_b_egg2.image = [UIImage imageNamed:@"bomb_left_2.png"];
            //self.l_b_egg2.frame = CGRectMake(105.0, 144.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_b_egg2.image = nil;
            self.l_b_egg2.hidden = YES;
        }
        
        if (lbEgg3 == ET_Simply)
        {
            //self.l_b_egg3.image = [UIImage imageNamed:@"egg_top_left_3.png"];
            self.l_b_egg3.hidden = NO;
            //self.l_b_egg3.frame = CGRectMake(126.0, 158.0 + 5.0, 13.0, 12.0);
        }
        else if (lbEgg3 == ET_Bomb)
        {
            //self.l_b_egg3.image = [UIImage imageNamed:@"bomb_left_3.png"];
            //self.l_b_egg3.frame = CGRectMake(118.0, 149.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_b_egg3.image = nil;
            self.l_b_egg3.hidden = YES;
        }
        
        if (lbEgg4 == ET_Simply)
        {
            //self.l_b_egg4.image = [UIImage imageNamed:@"egg_top_left_4.png"];
            self.l_b_egg4.hidden = NO;
            //self.l_b_egg4.frame = CGRectMake(139.0, 168.0 + 5.0, 12.0, 10.0);
        }
        else if (lbEgg4 == ET_Bomb)
        {
            //self.l_b_egg4.image = [UIImage imageNamed:@"bomb_left_4.png"];
            //self.l_b_egg4.frame = CGRectMake(130.0, 158.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.l_b_egg4.image = nil;
            self.l_b_egg4.hidden = YES;
        }
        
        if (lbEgg5 == ET_Simply)
        {
            //self.l_b_egg5.image = [UIImage imageNamed:@"egg_top_left_5.png"];
            self.l_b_egg5.hidden = NO;
            //self.l_b_egg5.frame = CGRectMake(152.0, 176.0 + 5.0, 10.0, 14.0);
        }
        else if (lbEgg5 == ET_Bomb)
        {
            /*self.l_b_egg5.frame = CGRectMake(142.0, 168.0 + 5.0, 30.0, 30.0);
            
            if (lbEgg4 == ET_Empty)
            {
                self.l_b_egg5.animationImages = bombAnimation;
                self.l_b_egg5.animationRepeatCount = 1;
                [self.l_b_egg5 startAnimating];
            }
            else
            {
                self.l_b_egg5.image = [UIImage imageNamed:@"bomb_left_5.png"];
            }*/
        }
        else
        {
            //self.l_b_egg5.image = nil;
            self.l_b_egg5.hidden = YES;
        }
        
        // redraw right top shelf
        EggType ruEgg1 = [[rightUpContent objectAtIndex:0] intValue];
        EggType ruEgg2 = [[rightUpContent objectAtIndex:1] intValue];
        EggType ruEgg3 = [[rightUpContent objectAtIndex:2] intValue];
        EggType ruEgg4 = [[rightUpContent objectAtIndex:3] intValue];
        EggType ruEgg5 = [[rightUpContent objectAtIndex:4] intValue];
        
        if (ruEgg1 == ET_Simply)
        {
            //self.r_t_egg1.image = [UIImage imageNamed:@"egg_top_right_1.png"];
            self.r_t_egg1.hidden = NO;
            //self.r_t_egg1.frame = CGRectMake(368.0, 100.0 + 5.0, 8.0, 13.0);
        }
        else if (ruEgg1 == ET_Bomb)
        {
            //self.r_t_egg1.frame = CGRectMake(357.0, 92.0 + 5.0, 30.0, 30.0);
            //self.r_t_egg1.image = [UIImage imageNamed:@"bomb_right_1.png"];
        }
        else
        {
            //self.r_t_egg1.image = nil;
            self.r_t_egg1.hidden = YES;
        }
        
        if (ruEgg2 == ET_Simply)
        {
            //self.r_t_egg2.image = [UIImage imageNamed:@"egg_top_right_2.png"];
            self.r_t_egg2.hidden = NO;
            //self.r_t_egg2.frame = CGRectMake(358.0, 106.0 + 5.0, 11.0, 13.0);
        }
        else if (ruEgg2 == ET_Bomb)
        {
            //self.r_t_egg2.image = [UIImage imageNamed:@"bomb_right_2.png"];
            //self.r_t_egg2.frame = CGRectMake(349.0, 100.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_t_egg2.image = nil;
            self.r_t_egg2.hidden = YES;
        }
        
        if (ruEgg3 == ET_Simply)
        {
            //self.r_t_egg3.image = [UIImage imageNamed:@"egg_top_right_3.png"];
            self.r_t_egg3.hidden = NO;
            //self.r_t_egg3.frame = CGRectMake(344.0, 113.0 + 5.0, 13.0, 12.0);
        }
        else if (ruEgg3 == ET_Bomb)
        {
            //self.r_t_egg3.image = [UIImage imageNamed:@"bomb_right_3.png"];
            //self.r_t_egg3.frame = CGRectMake(336.0, 104.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_t_egg3.image = nil;
            self.r_t_egg3.hidden = YES;
        }
        
        if (ruEgg4 == ET_Simply)
        {
            //self.r_t_egg4.image = [UIImage imageNamed:@"egg_top_right_4.png"];
            self.r_t_egg4.hidden = NO;
            //self.r_t_egg4.frame = CGRectMake(330.0, 121.0 + 5.0, 12.0, 10.0);
        }
        else if (ruEgg4 == ET_Bomb)
        {
            //self.r_t_egg4.image = [UIImage imageNamed:@"bomb_right_4.png"];
            //self.r_t_egg4.frame = CGRectMake(321.0, 111.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_t_egg4.image = nil;
            self.r_t_egg4.hidden = YES;
        }
        
        if (ruEgg5 == ET_Simply)
        {
            //self.r_t_egg5.image = [UIImage imageNamed:@"egg_top_right_5.png"];
            self.r_t_egg5.hidden = NO;
            //self.r_t_egg5.frame = CGRectMake(320.0, 131.0 + 5.0, 10.0, 14.0);
        }
        else if (ruEgg5 == ET_Bomb)
        {
            /*self.r_t_egg5.frame = CGRectMake(310.0, 123.0 + 5.0, 30.0, 30.0);
            
            if (ruEgg4 == ET_Empty)
            {
                self.r_t_egg5.animationImages = bombAnimation;
                self.r_t_egg5.animationRepeatCount = 1;
                [self.r_t_egg5 startAnimating];
            }
            else
            {
                self.r_t_egg5.image = [UIImage imageNamed:@"bomb_right_5.png"];
            }*/
        }
        else
        {
            //self.r_t_egg5.image = nil;
            self.r_t_egg5.hidden = YES;
        }
        
        // redraw right bottom shelf
        EggType rbEgg1 = [[rightDownContent objectAtIndex:0] intValue];
        EggType rbEgg2 = [[rightDownContent objectAtIndex:1] intValue];
        EggType rbEgg3 = [[rightDownContent objectAtIndex:2] intValue];
        EggType rbEgg4 = [[rightDownContent objectAtIndex:3] intValue];
        EggType rbEgg5 = [[rightDownContent objectAtIndex:4] intValue];
        
        if (rbEgg1 == ET_Simply)
        {
            //self.r_b_egg1.image = [UIImage imageNamed:@"egg_top_right_1.png"];
            self.r_b_egg1.hidden = NO;
            //self.r_b_egg1.frame = CGRectMake(367.0, 146.0 + 5.0, 8.0, 13.0);
        }
        else if (rbEgg1 == ET_Bomb)
        {
            //self.r_b_egg1.image = [UIImage imageNamed:@"bomb_right_1.png"];
            //self.r_b_egg1.frame = CGRectMake(356.0, 138.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_b_egg1.image = nil;
            self.r_b_egg1.hidden = YES;
        }
        
        if (rbEgg2 == ET_Simply)
        {
            //self.r_b_egg2.image = [UIImage imageNamed:@"egg_top_right_2.png"];
            self.r_b_egg2.hidden = NO;
            //self.r_b_egg2.frame = CGRectMake(355.0, 151.0 + 5.0, 11.0, 13.0);
        }
        else if (rbEgg2 == ET_Bomb)
        {
            //self.r_b_egg2.image = [UIImage imageNamed:@"bomb_right_2.png"];
            //self.r_b_egg2.frame = CGRectMake(346.0, 143.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_b_egg2.image = nil;
            self.r_b_egg2.hidden = YES;
        }
        
        if (rbEgg3 == ET_Simply)
        {
            //self.r_b_egg3.image = [UIImage imageNamed:@"egg_top_right_3.png"];
            self.r_b_egg3.hidden = NO;
            //self.r_b_egg3.frame = CGRectMake(342.0, 159.0 + 5.0, 13.0, 12.0);
        }
        else if (rbEgg3 == ET_Bomb)
        {
            //self.r_b_egg3.image = [UIImage imageNamed:@"bomb_right_3.png"];
            //self.r_b_egg3.frame = CGRectMake(334.0, 150.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_b_egg3.image = nil;
            self.r_b_egg3.hidden = YES;
        }
        
        if (rbEgg4 == ET_Simply)
        {
            //self.r_b_egg4.image = [UIImage imageNamed:@"egg_top_right_4.png"];
            self.r_b_egg4.hidden = NO;
            //self.r_b_egg4.frame = CGRectMake(328.0, 167.0 + 5.0, 12.0, 10.0);
        }
        else if (rbEgg4 == ET_Bomb)
        {
            //self.r_b_egg4.image = [UIImage imageNamed:@"bomb_right_4.png"];
            //self.r_b_egg4.frame = CGRectMake(319.0, 157.0 + 5.0, 30.0, 30.0);
        }
        else
        {
            //self.r_b_egg4.image = nil;
            self.r_b_egg4.hidden = YES;
        }
        
        if (rbEgg5 == ET_Simply)
        {
            //self.r_b_egg5.image = [UIImage imageNamed:@"egg_top_right_5.png"];
            self.r_b_egg5.hidden = NO;
            //self.r_b_egg5.frame = CGRectMake(317.0, 174.0 + 5.0, 10.0, 14.0);
        }
        else if (rbEgg5 == ET_Bomb)
        {
            /*self.r_b_egg5.frame = CGRectMake(307.0, 166.0 + 5.0, 30.0, 30.0);
            
            if (rbEgg4 == ET_Empty)
            {
                self.r_b_egg5.animationImages = bombAnimation;
                self.r_b_egg5.animationRepeatCount = 1;
                [self.r_b_egg5 startAnimating];
            }
            else
            {
                self.r_b_egg5.image = [UIImage imageNamed:@"bomb_right_5.png"];
            }*/
        }
        else
        {
            //self.r_b_egg5.image = nil;
            self.r_b_egg5.hidden = YES;
        }
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    // generate new egg on the current shelf
    NSMutableArray* currentArray = nil;
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (shelfPosition)
    {
        case SP_LeftUp:
            currentArray = leftUpContent;
            break;
        case SP_LeftDown:
            currentArray = leftDownContent;
            break;
        case SP_RightUp:
            currentArray = rightUpContent;
            break;
        case SP_RightDown:
            currentArray = rightDownContent;
            break;
    }
    
    // checking for rabbit zapadlist.
    /*int rabbitScore = [[rabbits objectAtIndex:rabbitIndex] intValue];
    if (rabbitScore <= score && rabbitIndex < 10)
    {
        eggType = ET_Bomb;
        rabbitIndex++;
    }*/
    
    // shift eggs on the current shelf and add a new egg
    
    [currentArray replaceObjectAtIndex:5 withObject:[currentArray objectAtIndex:4]];
    [currentArray replaceObjectAtIndex:4 withObject:[currentArray objectAtIndex:3]];
    [currentArray replaceObjectAtIndex:3 withObject:[currentArray objectAtIndex:2]];
    [currentArray replaceObjectAtIndex:2 withObject:[currentArray objectAtIndex:1]];
    [currentArray replaceObjectAtIndex:1 withObject:[currentArray objectAtIndex:0]];
    
    BOOL hasEgg = [self random];
    EggType eggType = !hasEgg ? ET_Empty : ET_Simply;
    [currentArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:eggType]];
    
    NSNumber* egg1 = [currentArray objectAtIndex:0];
    NSNumber* egg2 = [currentArray objectAtIndex:1];
    NSNumber* egg3 = [currentArray objectAtIndex:2];
    NSNumber* egg4 = [currentArray objectAtIndex:3];
    NSNumber* egg5 = [currentArray objectAtIndex:4];
    NSNumber* egg6 = [currentArray objectAtIndex:5];
        
    // check wolf position
    eggType = [egg6 intValue];
    
    // sound
    NSString* soundName = nil;
    if (!soundOff && (([egg1 intValue] != ET_Empty) || ([egg2 intValue] != ET_Empty) || ([egg3 intValue] != ET_Empty) || ([egg4 intValue] != ET_Empty) || ([egg5 intValue] != ET_Empty)))
    {
        if (shelfPosition == SP_RightUp)
        {
            soundName = @"egg1";
        }
        else if (shelfPosition == SP_LeftDown)
        {
            soundName = @"egg2";
        }
        else if (shelfPosition == SP_LeftUp)
        {
            soundName = @"egg3";
        }
        else if (shelfPosition == SP_RightDown)
        {
            soundName = @"egg4";
        }
        
        if (eggType == ET_Simply)
        {
            if (wolfPosition == shelfPosition)
            {
                soundName = @"catch";
            }
            else
            {
                soundName = @"fail";
            }
        }
        
        if (soundName)
        {
            [app playSound:soundName];
        }
    }

    if (eggType == ET_Simply)
    {
        if (wolfPosition != shelfPosition)
        {
            [self eggIsDown];
        }
        else
        {
            if (score < 900)
            {
                score++;
            }
            else
            {
                [self win];
            }
        }
    }
    else if (eggType == ET_Bomb)
    {
        if (wolfPosition == shelfPosition)
        {
            // booooooooooom, craaaassshhhhhh
            [self lose];
        }
    }
    
    // set next active shelf
    if (score < 5)
    {
        shelfPosition = SP_RightUp;
    }
    else if (score < 10)
    {
        shelfPosition = (shelfPosition == SP_RightUp) ? SP_LeftDown : SP_RightUp;
    }
    else
    {
        if (shelfPosition == SP_LeftUp)
        {
            shelfPosition = SP_RightUp;
        }
        else
        {
            shelfPosition++;
        }
    }
    
    [self redrawGame:YES];
    
    if (score == 50)
    {
        [timer invalidate];
        timer = nil;
        
        nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer2"];
        [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
    }
    else if (score == 400)
    {
        [timer invalidate];
        timer = nil;
        
        nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer3"];
        [self performSelector:@selector(setTimer:) withObject:n afterDelay:0.2];
    }
    
    // reset broken eggs
    if (score == 200 && !firstCleared && (brokenEggs > 0))
    {
        brokenEggs = 0;
        clearPosition = 0;
        [timer invalidate];
        timer = nil;
        
        firstCleared = YES;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod3:) userInfo:nil repeats:YES];
    }
    else if (score == 500 && !secondCleared && (brokenEggs > 0))
    {
        brokenEggs = 0;
        clearPosition = 0;
        [timer invalidate];
        timer = nil;
        
        secondCleared = YES;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod3:) userInfo:nil repeats:YES];
    }
}

- (void) setTimer:(NSNumber*)period
{
    [timer invalidate];
    timer = nil;
    
    NSLog(@"timer: %@", period);
    timer = [NSTimer scheduledTimerWithTimeInterval:[period floatValue] target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (void)timerFireMethod3:(NSTimer*)theTimer
{
    if (clearPosition >= 5)
    {
        clearPosition = 0;
        [theTimer invalidate];
        theTimer = nil;
        
        // clear all shelves
        leftUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        leftDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        
        nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSNumber* n = [app.document.playStateContent objectForKey:@"playTimer2"];
        
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:[n floatValue] target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
    else
    {
        // beep
    }
    
    clearPosition++;
}

- (void)timerFireMethod2:(NSTimer*)theTimer
{
    BOOL inLeft = [(NSNumber*)[theTimer userInfo] boolValue];
    
    if (chickenPosition == 0)
    {
        // draw broken egg
        if (inLeft)
        {
            left_broken_egg.image = [UIImage imageNamed:@"broken egg_left.png"];
            left_chicken_up.image = nil;
            left_chicken_run1.image = nil;
            left_chicken_run2.image = nil;
            left_chicken_run3.image = nil;
        }
        else
        {
            right_broken_egg.image = [UIImage imageNamed:@"broken egg_right.png"];
            right_chicken_up.image = nil;
            right_chicken_run1.image = nil;
            right_chicken_run2.image = nil;
            right_chicken_run3.image = nil;
        }
    }
    else if (chickenPosition == 1)
    {
        // draw chicken up
        if (inLeft)
        {
            left_chicken_up.image = [UIImage imageNamed:@"chicken_run_left_1.png"];
            left_chicken_run1.image = nil;
            left_chicken_run2.image = nil;
            left_chicken_run3.image = nil;
        }
        else
        {
            right_chicken_up.image = [UIImage imageNamed:@"chicken_run_right_1.png"];
            right_chicken_run1.image = nil;
            right_chicken_run2.image = nil;
            right_chicken_run3.image = nil;
        }
    }
    else if (chickenPosition == 2)
    {
        // draw chicken 1
        if (inLeft)
        {
            left_chicken_up.image = nil;
            left_chicken_run1.image = [UIImage imageNamed:@"chicken_run_left_1.png"];
            left_chicken_run2.image = nil;
            left_chicken_run3.image = nil;
        }
        else
        {
            right_chicken_up.image = nil;
            right_chicken_run1.image = [UIImage imageNamed:@"chicken_run_right_1.png"];
            right_chicken_run2.image = nil;
            right_chicken_run3.image = nil;
        }
    }
    else if (chickenPosition == 3)
    {
        // draw chicken 2
        if (inLeft)
        {
            left_chicken_up.image = nil;
            left_chicken_run1.image = nil;
            left_chicken_run2.image = [UIImage imageNamed:@"chicken_run_left_2.png"];
            left_chicken_run3.image = nil;
        }
        else
        {
            right_chicken_up.image = nil;
            right_chicken_run1.image = nil;
            right_chicken_run2.image = [UIImage imageNamed:@"chicken_run_right_2.png"];
            right_chicken_run3.image = nil;
        }
    }
    else if (chickenPosition == 4)
    {
        // draw chicken 3
        if (inLeft)
        {
            left_chicken_up.image = nil;
            left_chicken_run1.image = nil;
            left_chicken_run2.image = nil;
            left_chicken_run3.image = [UIImage imageNamed:@"chicken_run_left_3.png"];
        }
        else
        {
            right_chicken_up.image = nil;
            right_chicken_run1.image = nil;
            right_chicken_run2.image = nil;
            right_chicken_run3.image = [UIImage imageNamed:@"chicken_run_right_3.png"];
        }
    }
    else
    {
        [theTimer invalidate];
        theTimer = nil;
        
        // clear all broken positions
        left_broken_egg.image = nil;
        right_broken_egg.image = nil;
        
        left_chicken_run1.image = nil;
        left_chicken_run2.image = nil;
        left_chicken_run3.image = nil;
        
        right_chicken_run1.image = nil;
        right_chicken_run2.image = nil;
        right_chicken_run3.image = nil;
        
        // clear all shelves
        leftUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        leftDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightUpContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
        rightDownContent = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];

        chickenPosition = 0;
        
        // fire main timer
        nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (brokenEggs >= 4)
        {
            // end game
            [self lose];
        }
        else
        {
            NSNumber* n = nil;
            if (score < 50)
            {
                n = [app.document.playStateContent objectForKey:@"playTimer1"];
            }
            else if (score < 400)
            {
                n = [app.document.playStateContent objectForKey:@"playTimer2"];
            }
            else
            {
                n = [app.document.playStateContent objectForKey:@"playTimer3"];
            }
            
            [timer invalidate];
            timer = nil;
            
            timer = [NSTimer scheduledTimerWithTimeInterval:[n floatValue] target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
            bomb = NO;
            [bombButton setBackgroundImage:nil forState:UIControlStateNormal];
        }

        return;
    }
    
    chickenPosition++;
}

- (void) eggIsDown
{
    // stop main timer
    [timer invalidate];
    timer = nil;
    
    if (brokenEggs < 5)
    {
        brokenEggs++;
        
        // show the running chicken
        BOOL inLeft = NO;
        if (shelfPosition == SP_LeftUp || shelfPosition == SP_LeftDown)
        {
            inLeft = YES;
        }
        
        chickenPosition = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod2:) userInfo:[NSNumber numberWithBool:inLeft] repeats:YES];
        
        return;
    }
}

- (BOOL) random
{
    // generate random number between 1 and 100
    int index = (arc4random() % 100) + 1;
    // generate random boolean
    BOOL e = ((index / 2) * 2 == index);
    return e;
}

- (void) randomRabbits
{
    for (int i = 0; i < 10; i++)
    {
        // generate random number between 1 and 1000
        int index = (arc4random() % 1000) + 1;
        [rabbits addObject:[NSNumber numberWithInt:index]];
    }
    
    [rabbits sortUsingSelector:@selector(sortRabbits:)];
    
    /*[rabbits addObject:[NSNumber numberWithInt:5]];
    [rabbits addObject:[NSNumber numberWithInt:6]];
    [rabbits addObject:[NSNumber numberWithInt:8]];
    [rabbits addObject:[NSNumber numberWithInt:9]];
    [rabbits addObject:[NSNumber numberWithInt:10]];
    [rabbits addObject:[NSNumber numberWithInt:15]];
    [rabbits addObject:[NSNumber numberWithInt:20]];
    [rabbits addObject:[NSNumber numberWithInt:21]];
    [rabbits addObject:[NSNumber numberWithInt:22]];
    [rabbits addObject:[NSNumber numberWithInt:23]];
    [rabbits addObject:[NSNumber numberWithInt:25]];
    [rabbits addObject:[NSNumber numberWithInt:26]];
    [rabbits addObject:[NSNumber numberWithInt:27]];
    [rabbits addObject:[NSNumber numberWithInt:28]];
    [rabbits addObject:[NSNumber numberWithInt:29]];*/
}

- (void) lose
{
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (!soundOff)
    {
        [app playSound:@"finish"];
    }
    
    [app nextState:[[LoseState alloc] init]];
}

- (void) win
{
    [timer invalidate];
    timer = nil;
    
    nupogodiAppDelegate* app = (nupogodiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app nextState:[[WinState alloc] init]];
}

#pragma mark - Public Methods

- (void) Pause
{
    [self pauseButtonClicked:nil];
}

@end

@implementation NSNumber (CustomSorting)

- (NSComparisonResult) sortRabbits:(NSNumber*)otherNumber
{
    return [self compare:otherNumber];
}

@end
