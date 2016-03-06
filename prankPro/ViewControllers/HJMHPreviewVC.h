//
//  HJMHPreviewVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import <SCRecorder.h>
#import <QiniuSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "UIViewController+Login.h"

@interface HJMHPreviewVC : UIViewController<SCPlayerDelegate, SCAssetExportSessionDelegate,GADInterstitialDelegate>

@property (strong, nonatomic) SCRecordSession *recordSession;
@property (strong, nonatomic)  SCVideoPlayerView *preview;
@property (strong, nonatomic) SCPlayer *player;
@property (strong, nonatomic) UIButton* uploadBtn;
@property (strong, nonatomic)  FBSDKShareButton* shareBtn;
@property (strong, nonatomic) NSURL* fileURL;
@property (strong,nonatomic) UIView* share;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic,strong) UIImage* thumbnail;
@end
