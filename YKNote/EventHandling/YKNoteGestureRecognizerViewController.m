//
//  YKNoteGestureRecognizerViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/18.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteGestureRecognizerViewController.h"

@interface YKNoteGestureRecognizerViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;


@end

@implementation YKNoteGestureRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - user event

- (IBAction)handleTapRecognizer:(UITapGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
    }];
}

- (IBAction)handleSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 100;
    } else {
        location.x += 100;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
        self.imageView.center = location;
    }];
}

- (IBAction)handleRotationRecognizer:(UIRotationGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(sender.rotation);
    self.imageView.transform = transform;
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - private method
- (void)drawImageForGestureRecognizer:(UIGestureRecognizer *)recognizer atPoint:(CGPoint)centerPoint {
    
    NSString *imageName;
    
    if ([recognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        imageName = @"tap";
    }
    else if ([recognizer isMemberOfClass:[UIRotationGestureRecognizer class]]) {
        imageName = @"rotation";
    }
    else if ([recognizer isMemberOfClass:[UISwipeGestureRecognizer class]]) {
        imageName = @"swipe";
    }
    
    self.imageView.image = [UIImage imageNamed:imageName];
    self.imageView.center = centerPoint;
    self.imageView.alpha = 1.0;
}


@end
