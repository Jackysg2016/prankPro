//
//  TestVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//
 
#import <UIKit/UIKit.h>

#import "HJMHProgressBar.h"

@interface TestVC : UIViewController<PFLogInViewControllerDelegate>
@property(nonatomic,strong) HJMHProgressBar* bar;
@property(nonatomic,assign)CGFloat time;
@end
