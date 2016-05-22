//
//  UHJordanImageView.m
//  JordanMeme
//
//  Created by Umar Haroon on 5/20/16.
//  Copyright © 2016 Umar Haroon. All rights reserved.
//

#import "UHJordanImageView.h"

@implementation UHJordanImageView

- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        UIPanGestureRecognizer *movePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
        self.gestureRecognizers = @[movePan];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)detectPan:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.superview];
    self.center = CGPointMake(_lastLocation.x + translation.x, _lastLocation.y +translation.y);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.superview bringSubviewToFront:self];
    
    self.lastLocation = self.center;
}

@end

