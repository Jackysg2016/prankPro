//
//  HJPlayerProgressView.h
//  2clip
//
//  Created by mac on 16/1/3.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HJMHPlayerProgressView : UIView

- (instancetype)initWithLineWidth:(CGFloat)lineWidth currentTimeColor:(UIColor*)currentTimeColor bufferTimeColor:(UIColor*)bufferTimeColor lineBackGroundColor:(UIColor*)lineBackGroundColor thumbImg:(UIImage*)thumbImg;
- (void)updateCurrentTime:(CGFloat)currentTime;
- (void)updateBufferTime:(CGFloat)bufferTime;
@end
