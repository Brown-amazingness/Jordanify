//
//  ViewController.m
//  JordanMeme
//
//  Created by Umar Haroon on 2/22/16.
//  Copyright © 2016 Umar Haroon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    CGSize jordanHeadSize;
}

@end

@implementation ViewController
@synthesize imageView,menuActionSheet,tutorialLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    tutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 240, 240)];
    tutorialLabel.numberOfLines = 0;
    tutorialLabel.center = CGPointMake(self.view.bounds.size.width / 2,self.view.bounds.size.height / 2);
    tutorialLabel.text = @"Tap to add a face \n\n\n Hold on the face to remove it \n\n\n Pinch the face to make it bigger/smaller \n\n\n Press the button to begin";
    [self.view addSubview:tutorialLabel];
    
    
    UIPinchGestureRecognizer *sizeGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(jordanPinched:)];
    [self.view addGestureRecognizer:sizeGesture];
    

    
    self.menuButton.layer.cornerRadius = 20;
    self.menuButton.layer.masksToBounds = NO;
    
    UITapGestureRecognizer *tapPoint = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPoint:)];
    tapPoint.delegate = self;
    tapPoint.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapPoint];
    
    
    UILongPressGestureRecognizer *jordanPoint = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jordan:)];
    jordanPoint.delegate = self;
    [jordanPoint requireGestureRecognizerToFail:tapPoint];

    [self.view addGestureRecognizer:jordanPoint];
    
    menuActionSheet = [[AHKActionSheet alloc]initWithTitle:nil];
    menuActionSheet.blurTintColor = [UIColor colorWithWhite:0.0f alpha:.75f];
    menuActionSheet.blurRadius = 8.0f;
    
    menuActionSheet.buttonHeight = 50.0f;
    menuActionSheet.animationDuration = 0.25f;
    
    menuActionSheet.buttonTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    
    __block UIImagePickerController *picker;
    __weak typeof(self) weakSelf = self;

    [menuActionSheet addButtonWithTitle:@"Test" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        tutorialLabel.hidden = YES;
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf presentViewController:picker animated:YES completion:^{
            }];
        }];
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tapPoint:(UITapGestureRecognizer *)tap{
    tutorialLabel.hidden = YES;
    [imageView removeFromSuperview];
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jordanHead"]];


    CGPoint tapPoint = [tap locationInView:self.view];


    
    imageView.frame = CGRectMake(tapPoint.x, tapPoint.y, 127, 127);
    imageView.center = tapPoint;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:self.menuButton];


    
    
    
}
-(void)jordanPinched:(UIPinchGestureRecognizer *)pinch{
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width * pinch.scale -1.0, imageView.frame.size.height * pinch.scale -1.0);
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.mainImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)menuButtonPressed:(UIButton *)sender {
    tutorialLabel.hidden = YES;
    [menuActionSheet show];
}
-(void)jordan:(UILongPressGestureRecognizer *)tap{
    CGPoint tapPoint = [tap locationInView:self.view];
    CGPoint locationInView = [imageView convertPoint:tapPoint fromView:imageView.window];
    
    if (CGRectContainsPoint(imageView.bounds, locationInView)) {
        [imageView removeFromSuperview];
    }

}

@end
