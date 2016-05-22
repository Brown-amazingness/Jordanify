//
//  ViewController.h
//  JordanMeme
//
//  Created by Umar Haroon on 2/22/16.
//  Copyright © 2016 Umar Haroon. All rights reserved.
//

#import "UHJordanImageView.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property UHJordanImageView *imageView;

@property UILabel *tutorialLabel;

@property (weak, nonatomic) IBOutlet UHJordanImageView *mainImageView;
@property UIImage *screengrab;
@property NSMutableArray *imageViewArray;

@property CGPoint lastLocation;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolBar;

- (IBAction)clearBarButtonItemPressed:(UIButton *)sender;



@end

