//
//  ViewController.m
//  JordanMeme
//
//  Created by Umar Haroon on 2/22/16.
//  Copyright © 2016 Umar Haroon. All rights reserved.
//

#import "ViewController.h"
#import "UHJordanImageView.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UITabBarDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    CGSize jordanHeadSize;
}

@property UIImagePickerController *picker;
@property UIActivityViewController *activityVC;

@end

@implementation ViewController
@synthesize imageView,tutorialLabel,imageViewArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //creates the UIImagePickerController VC
    _picker = [[UIImagePickerController alloc] init];
    UIImage *image = [UIImage imageNamed:@"Camera"];
    _screengrab= image;
    _activityVC = [[UIActivityViewController alloc]initWithActivityItems:[NSArray arrayWithObject:_screengrab] applicationActivities:nil];

    
    imageViewArray = [[NSMutableArray alloc]init];

    jordanHeadSize = CGSizeMake(117, 117);
    
    
    //Creates the tutorial label. It honestly should be built in IB now that i think about it.
    //TODO: Make tutorialLabel in Main.storyboard.

    tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 240, 240)];
    tutorialLabel.numberOfLines = 0;
    tutorialLabel.center = CGPointMake(self.view.bounds.size.width / 2,self.view.bounds.size.height / 2);
    tutorialLabel.text = @"Tap to add a face \n\n\n Hold on the face to remove it \n\n\n Pinch the face to make it bigger/smaller \n\n\n Press the camera icon to begin.";
    tutorialLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:tutorialLabel];
    
    
    //Creating the gestures.
    
    
    UIPinchGestureRecognizer *sizeGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(jordanPinched:)];
    
    UITapGestureRecognizer *tapPoint = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPoint:)];
    tapPoint.delegate = self;
    tapPoint.numberOfTapsRequired = 1;
    
    
    UITapGestureRecognizer *doubleTapInvertGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDoubleTapped:)];
    doubleTapInvertGesture.numberOfTapsRequired = 2;
    
    self.view.gestureRecognizers = @[sizeGesture,tapPoint,doubleTapInvertGesture];
    
    
}




-(void)tapPoint:(UITapGestureRecognizer *)tap{
    tutorialLabel.hidden = YES;
    UHJordanImageView *jordanFace = [[UHJordanImageView alloc]initWithImage:[UIImage imageNamed:@"jordanHead"]];
    CGPoint tapPoint = [tap locationInView:self.view];
    
    jordanFace.alpha = 0;
    
    jordanFace.frame = CGRectMake(tapPoint.x, tapPoint.y, jordanHeadSize.width, jordanHeadSize.height);
    
    jordanFace.center = tapPoint;
    [self.view addSubview:jordanFace];
    
    [UIView animateWithDuration:.3 animations:^{
        jordanFace.alpha = 1;
    }];
    
    [self.imageViewArray addObject:jordanFace];
    
    [self.view bringSubviewToFront:self.mainToolBar];
    
    
    
    
    
}
-(void)jordanPinched:(UIPinchGestureRecognizer *)pinch{
    
    UHJordanImageView *image = imageViewArray[imageViewArray.count - 1];
    
    image.transform = CGAffineTransformScale(image.transform, pinch.scale, pinch.scale);
    jordanHeadSize.height = image.frame.size.height;
    jordanHeadSize.width = image.frame.size.width;
    pinch.scale = 1;
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.mainImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)importButtonPressed:(UIButton *)sender{
    
    
    self.tutorialLabel.hidden = YES;
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:_picker animated:YES completion:nil];
    });
    
    
}

-(void)imageDoubleTapped:(UITapGestureRecognizer *)tap{
    if (imageViewArray.count >0) {
        
        
        
        tutorialLabel.hidden = YES;
        UHJordanImageView *imageView2 = [[UHJordanImageView alloc] initWithImage:[UIImage imageNamed:@"jordanHeadInverted"]];
        
        imageView2.alpha = 0;
        
        if (imageView.image != [UIImage imageNamed:@"jordanHeadInverted"]){
            [UIView animateWithDuration:.1 animations:^{
                [self.imageViewArray[self.imageViewArray.count - 1] setAlpha:0];
                
                
            }];
            
            [self.imageViewArray[self.imageViewArray.count - 1] removeFromSuperview];
        }
        
        
        imageView2 = [[UHJordanImageView alloc]initWithImage:[UIImage imageNamed:@"jordanHeadInverted"]];
        CGPoint tapPoint = [tap locationInView:self.view];
        
        
        imageView2.frame = CGRectMake(tapPoint.x, tapPoint.y, jordanHeadSize.width, jordanHeadSize.height);
        
        imageView2.center = tapPoint;
        
        [UIView animateWithDuration:.3 animations:^{
            [imageView2 setAlpha:1];
        }];
        
        [self.view addSubview:imageView2];
        
        [self.imageViewArray addObject:imageView2];
        
        [self.view bringSubviewToFront:self.mainToolBar];
        
        
    }





}



- (IBAction)clearBarButtonItemPressed:(UIButton *)sender {
    
    for (UHJordanImageView *image in imageViewArray) {

        [UIView animateWithDuration:.3 animations:^{
            image.alpha = 0;

        }completion:^(BOOL succeeded){
            [image removeFromSuperview];
        }];
        
    }
    
}

-(IBAction)shareButtonPressed:(UIButton *)sender{
    [self screenshotAndSaveImage:NO];
    _activityVC = [[UIActivityViewController alloc]initWithActivityItems:[NSArray arrayWithObject:_screengrab] applicationActivities:nil];
    _activityVC.popoverPresentationController.sourceView = self.view;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:_activityVC animated:YES completion:nil];
        
    });
}

-(void)screenshotAndSaveImage:(BOOL)saveImage
{
    
    
    UIView *wholeScreen = self.view;
    
    self.mainToolBar.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(wholeScreen.bounds.size, NO, 0.0);
    
    
    [wholeScreen.layer renderInContext:UIGraphicsGetCurrentContext()];
    [wholeScreen drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.screengrab = screengrab;
    if (saveImage) {
        UIImageWriteToSavedPhotosAlbum(_screengrab, nil, nil, nil);
    }
    self.mainToolBar.hidden = NO;
    
    
    
    
}


-(IBAction)undoButtonPressed:(UIButton *)sender{
    if ([imageViewArray count]) {
        [imageViewArray[imageViewArray.count - 1] removeFromSuperview];
        [imageViewArray removeObjectAtIndex:(imageViewArray.count - 1)];
    }

}


@end
