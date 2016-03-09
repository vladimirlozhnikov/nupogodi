//
//  LoseViewController.h
//  nupogodi
//
//  Created by vladimir.lozhnikov on 27.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LoseViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIImageView* bg;
}

@property (nonatomic, retain) IBOutlet UIImageView* bg;

@end
