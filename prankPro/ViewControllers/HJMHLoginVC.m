//
//  HJMHLoginVC.m
//  prankPro
//
//  Created by mac on 16/2/9.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHLoginVC.h"

@implementation HJMHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.logInView.logo = logoView; // logo can be any UIView
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame=self.logInView.logo.frame;
    frame.size=CGSizeMake(150, 150);
    frame.origin.y=frame.origin.y-100;
    frame.origin.x=frame.origin.x;
    self.logInView.logo.frame=frame;
}

@end
