//
//  ViewController.h
//  JordanMeme
//
//  Created by Umar Haroon on 2/22/16.
//  Copyright © 2016 Umar Haroon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHKActionSheet.h"
#import "UIImageView+Jordan.h"

@interface ViewController : UIViewController

@property UIImageView_Jordan *imageView;

@property UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

- (IBAction)menuButtonPressed:(UIButton *)sender;

@property AHKActionSheet *menuActionSheet;

@end

