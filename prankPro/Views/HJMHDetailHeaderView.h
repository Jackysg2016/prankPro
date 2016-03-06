//
//  HJMHDetailHeaderView.h
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "HJMHPlayerView.h"
#import "HJMHStatusBar.h"
#import "Video.h"
#import "HJMHUtility.h"

@protocol HJMHDetailViewDelegate <NSObject>

-(void)clickAvatar:(PFUser*)user;
-(void)clickDismmiss;

@end

@interface HJMHDetailHeaderView : UIView<HJMHPlayerViewDelegate>

@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIView* playerFrame;
@property (strong, nonatomic)  HJMHPlayerView *playerView;
@property (strong, nonatomic)  PFImageView *avatarImage; 
@property (strong, nonatomic)  UIView *toolGroup;
@property (strong, nonatomic)  HJMHStatusBar *statusBar;
@property (nonatomic,strong)   AVPlayer *player;
@property (nonatomic, strong)  NSTimer* timer;
@property (nonatomic, strong)  FBSDKShareButton* shareBtn;
@property (nonatomic, strong)  UIButton* likeBtn;
@property (strong, nonatomic)  GADBannerView  *bannerView;
@property (nonatomic,assign,getter=isLoop) BOOL loop;

/**
 *  按钮事件
 */
@property (strong,nonatomic) id<HJMHDetailViewDelegate> delegate;
/**
 *  数据
 */
@property (strong,nonatomic)   Video* data;
/**
 *  用于判断用户是否点击了播放暂停按钮
 */
@property (nonatomic, assign, getter=isUserPause) BOOL userPause;
/**
 *  用于判断播放器是否应该隐藏
 */
@property (nonatomic, assign, getter=isPlayerHidden) BOOL playerHidden;
/**
 *  用于缓冲到达指定时间自动播放 每次恢复播放只执行一次
 */
@property (nonatomic, assign, getter=isPlayerPlayOnceTime) BOOL playerPlayOnceTime;
-(id)initWithVideo:(Video*)video andFrame:(CGRect)frame;
-(void)playerDestory;
@end
