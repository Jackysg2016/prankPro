//
//  HJMHProgressBar.h
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define MIN_VIDEO_DUR 2.0f
#define MAX_VIDEO_DUR 8.0f

#import <UIKit/UIKit.h>

@interface HJMHProgressBar : UIView

@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) UIView *progressView;

- (void)setProgressToWidth:(CGFloat)width;
-(void) initalize;
@end
