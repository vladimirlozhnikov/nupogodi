//
//  MenuViewController.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 01.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
{
    IBOutlet UIImageView* background;
    IBOutlet UIButton* playButton;
}

@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) IBOutlet UIButton* playButton;

- (IBAction)englishButtonClicked:(id)sender;
- (IBAction)russianButtonClicked:(id)sender;
- (IBAction)playClicked:(id)sender;

@end
