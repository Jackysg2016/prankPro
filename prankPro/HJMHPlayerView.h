//
//  HJPlayerView.h
//  2clip
//
//  Created by mac on 16/1/3.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "HJMHPlayerProgressView.h"

@class HJMHPlayerView;

@protocol HJMHPlayerViewDelegate<NSObject>
@optional
- (void)playerTouchPlayerButton:(HJMHPlayerView*)UIView;
@end

typedef void(^handle)();

@interface HJMHPlayerView : UIView

//淡出时间
@property (nonatomic, assign) CGFloat fadeTime;
@property (nonatomic, weak) id<HJMHPlayerViewDelegate> delegate;
@property (nonatomic, strong) handle returnBlock;

- (instancetype)initWithVideo:(Video*)video videoTime:(NSInteger)videoTime;
//- (void)setWithTitle:(NSString*)title videoTime:(NSInteger)videoTime;

- (void)showPlayer;
- (void)hiddenPlayer;
/**
 *  用于更新参数
 *
 */
- (void)updateValue:(handle) block;
/**
 *  更新时间
 *  @param time 传递秒数
 */
- (void)updateCurrentTime:(CGFloat)currentTime bufferTime:(CGFloat)bufferTime allTime:(NSInteger)allTime;

@end
