//
//  HJPlayerProgressView.m
//  2clip
//
//  Created by mac on 16/1/3.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHPlayerProgressView.h"

#define centerYInSelf self.frame.size.height

@interface HJMHPlayerProgressView ()
@property (nonatomic, strong) UIImage* thumbImg;
@property (nonatomic, strong) UIColor* currentTimeColor;
@property (nonatomic, strong) UIColor* bufferTimeColor;
@property (nonatomic, strong) UIColor* lineBackGroundColor;
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  当前时间
 */
@property (nonatomic, assign) CGFloat currentTime;
/**
 *  已缓存时间
 */
@property (nonatomic, assign) CGFloat bufferTime;
@end

@implementation HJMHPlayerProgressView

- (instancetype)initWithLineWidth:(CGFloat)lineWidth currentTimeColor:(UIColor*)currentTimeColor bufferTimeColor:(UIColor*)bufferTimeColor lineBackGroundColor:(UIColor*)lineBackGroundColor thumbImg:(UIImage*)thumbImg{
    if (self = [super init]) {
        
        self.lineWidth = lineWidth;
        self.currentTimeColor = currentTimeColor;
        self.bufferTimeColor = bufferTimeColor;
        self.lineBackGroundColor = lineBackGroundColor;
        self.backgroundColor = [UIColor clearColor];
        self.thumbImg = thumbImg;
    }
    return self;
}

- (void)updateCurrentTime:(CGFloat)currentTime{
    self.currentTime = currentTime;
    [self setNeedsDisplay];
}
- (void)updateBufferTime:(CGFloat)bufferTime{
    self.bufferTime = bufferTime;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGPoint currentTimePoint = CGPointMake(self.currentTime * self.frame.size.width, centerYInSelf);
    CGPoint bufferTimePoint = CGPointMake(self.bufferTime * self.frame.size.width, centerYInSelf);
    
    
    //背景时间长度
    UIBezierPath* backGroundPath = [UIBezierPath bezierPath];
    backGroundPath.lineWidth = self.lineWidth;
    [backGroundPath moveToPoint: CGPointMake(0, centerYInSelf)];
    [backGroundPath addLineToPoint: CGPointMake(self.frame.size.width, centerYInSelf)];
    [self.lineBackGroundColor setStroke];
    [backGroundPath stroke];
    
    //缓存时间长度
    UIBezierPath* bufferTimePath = [UIBezierPath bezierPath];
    bufferTimePath.lineWidth = self.lineWidth;
    [bufferTimePath moveToPoint: CGPointMake(0, centerYInSelf)];
    [bufferTimePath addLineToPoint: bufferTimePoint];
    [self.bufferTimeColor setStroke];
    [bufferTimePath stroke];
    
    //当前播放时间颜色
    UIBezierPath* currentTimePath = [UIBezierPath bezierPath];
    currentTimePath.lineWidth = self.lineWidth;
    [currentTimePath moveToPoint:CGPointMake(0, centerYInSelf)];
    [currentTimePath addLineToPoint: currentTimePoint];
    [self.currentTimeColor setStroke];
    [currentTimePath stroke];
    
    [self.thumbImg drawInRect:CGRectMake(currentTimePoint.x, 0, self.thumbImg.size.width / self.thumbImg.size.height * self.frame.size.height, self.frame.size.height)];
}


@end
