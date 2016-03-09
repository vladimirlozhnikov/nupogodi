//
//  PlayViewController.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 02.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum EWolfPosition
{
    WP_RightUp,
    WP_RightDown,
    WP_LeftDown,
    WP_LeftUp,
    WP_Unknown
} WolfPosition;

typedef enum EShelfPosition
{
    SP_RightUp,
    SP_RightDown,
    SP_LeftDown,
    SP_LeftUp
} ShelfPosition;

typedef enum EEggType
{
    ET_Empty,
    ET_Simply,
    ET_Bomb
} EggType;

@interface PlayViewController : UIViewController
{
    IBOutlet UIImageView* background;
    IBOutlet UIImageView* wolf;
    IBOutlet UIButton* leftUpButton;
    IBOutlet UIButton* leftDownButton;
    IBOutlet UIButton* rightUpButton;
    IBOutlet UIButton* rightDownButton;
    
    // eggs
    
    // left top
    IBOutlet UIImageView* l_t_egg1;
    IBOutlet UIImageView* l_t_egg2;
    IBOutlet UIImageView* l_t_egg3;
    IBOutlet UIImageView* l_t_egg4;
    IBOutlet UIImageView* l_t_egg5;
    
    // left bottom
    IBOutlet UIImageView* l_b_egg1;
    IBOutlet UIImageView* l_b_egg2;
    IBOutlet UIImageView* l_b_egg3;
    IBOutlet UIImageView* l_b_egg4;
    IBOutlet UIImageView* l_b_egg5;
    
    // right top
    IBOutlet UIImageView* r_t_egg1;
    IBOutlet UIImageView* r_t_egg2;
    IBOutlet UIImageView* r_t_egg3;
    IBOutlet UIImageView* r_t_egg4;
    IBOutlet UIImageView* r_t_egg5;
    
    // right bottom
    IBOutlet UIImageView* r_b_egg1;
    IBOutlet UIImageView* r_b_egg2;
    IBOutlet UIImageView* r_b_egg3;
    IBOutlet UIImageView* r_b_egg4;
    IBOutlet UIImageView* r_b_egg5;
    
    // score
    IBOutlet UIImageView* score1;
    IBOutlet UIImageView* score2;
    IBOutlet UIImageView* score3;
    
    // broken eggs (score)
    IBOutlet UIImageView* broken_egg1;
    IBOutlet UIImageView* broken_egg2;
    IBOutlet UIImageView* broken_egg3;
    IBOutlet UIImageView* broken_egg4;
    
    // broken egg in left
    IBOutlet UIImageView* left_broken_egg;
    
    // broken egg in right
    IBOutlet UIImageView* right_broken_egg;
    
    // rabbit zapadlist
    IBOutlet UIImageView* rabbit;
    
    // buttons
    IBOutlet UIButton* startButton;
    IBOutlet UIButton* pauseButton;
    IBOutlet UIButton* bombButton;
    IBOutlet UIButton* soundOffButton;
    
    NSTimer* timer;
    NSMutableArray* leftUpContent;
    NSMutableArray* leftDownContent;
    NSMutableArray* rightUpContent;
    NSMutableArray* rightDownContent;
    
    WolfPosition wolfPosition;
    ShelfPosition shelfPosition;
    
    NSInteger brokenEggs;
    NSInteger score;
    NSInteger chickenPosition;
    NSInteger clearPosition;
    
    // randome score container when rabbit appears
    NSInteger rabbitIndex;
    NSMutableArray* rabbits;
    
    // animated bombed egg
    NSMutableArray* bombAnimation;
    
    BOOL start;
    BOOL pause;
    BOOL bomb;
    BOOL soundOff;
    BOOL firstCleared;
    BOOL secondCleared;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIImageView* wolf;
@property (nonatomic, retain) IBOutlet UIButton* leftUpButton;
@property (nonatomic, retain) IBOutlet UIButton* leftDownButton;
@property (nonatomic, retain) IBOutlet UIButton* rightUpButton;
@property (nonatomic, retain) IBOutlet UIButton* rightDownButton;

// left top
@property (nonatomic, retain) IBOutlet UIImageView* l_t_egg1;
@property (nonatomic, retain) IBOutlet UIImageView* l_t_egg2;
@property (nonatomic, retain) IBOutlet UIImageView* l_t_egg3;
@property (nonatomic, retain) IBOutlet UIImageView* l_t_egg4;
@property (nonatomic, retain) IBOutlet UIImageView* l_t_egg5;

// left bottom
@property (nonatomic, retain) IBOutlet UIImageView* l_b_egg1;
@property (nonatomic, retain) IBOutlet UIImageView* l_b_egg2;
@property (nonatomic, retain) IBOutlet UIImageView* l_b_egg3;
@property (nonatomic, retain) IBOutlet UIImageView* l_b_egg4;
@property (nonatomic, retain) IBOutlet UIImageView* l_b_egg5;

// right top
@property (nonatomic, retain) IBOutlet UIImageView* r_t_egg1;
@property (nonatomic, retain) IBOutlet UIImageView* r_t_egg2;
@property (nonatomic, retain) IBOutlet UIImageView* r_t_egg3;
@property (nonatomic, retain) IBOutlet UIImageView* r_t_egg4;
@property (nonatomic, retain) IBOutlet UIImageView* r_t_egg5;

// right bottom
@property (nonatomic, retain) IBOutlet UIImageView* r_b_egg1;
@property (nonatomic, retain) IBOutlet UIImageView* r_b_egg2;
@property (nonatomic, retain) IBOutlet UIImageView* r_b_egg3;
@property (nonatomic, retain) IBOutlet UIImageView* r_b_egg4;
@property (nonatomic, retain) IBOutlet UIImageView* r_b_egg5;

// score
@property (nonatomic, retain) IBOutlet IBOutlet UIImageView* score1;
@property (nonatomic, retain) IBOutlet IBOutlet UIImageView* score2;
@property (nonatomic, retain) IBOutlet IBOutlet UIImageView* score3;

// broken eggs
@property (nonatomic, retain) IBOutlet UIImageView* broken_egg1;
@property (nonatomic, retain) IBOutlet UIImageView* broken_egg2;
@property (nonatomic, retain) IBOutlet UIImageView* broken_egg3;
@property (nonatomic, retain) IBOutlet UIImageView* broken_egg4;

// broken egg in left
@property (nonatomic, retain) IBOutlet UIImageView* left_broken_egg;
@property (nonatomic, retain) IBOutlet UIImageView* left_chicken_up;
@property (nonatomic, retain) IBOutlet UIImageView* left_chicken_run1;
@property (nonatomic, retain) IBOutlet UIImageView* left_chicken_run2;
@property (nonatomic, retain) IBOutlet UIImageView* left_chicken_run3;

// broken egg in right
@property (nonatomic, retain) IBOutlet UIImageView* right_broken_egg;
@property (nonatomic, retain) IBOutlet UIImageView* right_chicken_up;
@property (nonatomic, retain) IBOutlet UIImageView* right_chicken_run1;
@property (nonatomic, retain) IBOutlet UIImageView* right_chicken_run2;
@property (nonatomic, retain) IBOutlet UIImageView* right_chicken_run3;

// rabbit zapadlist
@property (nonatomic, retain) IBOutlet UIImageView* rabbit;

// buttons
@property (nonatomic, retain) IBOutlet UIButton* startButton;
@property (nonatomic, retain) IBOutlet UIButton* pauseButton;
@property (nonatomic, retain) IBOutlet UIButton* bombButton;
@property (nonatomic, retain) IBOutlet UIButton* soundOffButton;

- (void) Pause;

@end
