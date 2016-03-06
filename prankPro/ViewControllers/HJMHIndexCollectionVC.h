//
//  HJMHIndexCollectionVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import "UIViewController+Login.h"

@interface HJMHIndexCollectionVC : UICollectionViewController<UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray* data;
@property (nonatomic,assign) int mPage;
@property (strong, nonatomic) GADBannerView  *bannerView;

@end
