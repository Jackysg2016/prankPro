//
//  HJMHProfileVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//
@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import "HJMHProfileCollectionViewCell.h"
#import "HJMHDetailTableVC.h"
#import "HJMHProfileHeaderView.h"
#import "Video.h"

@interface HJMHProfileVC : UICollectionViewController<UIActionSheetDelegate>

@property (nonatomic,strong) NSMutableArray* data;
@property (nonatomic,assign) int mPage;
@property (nonatomic,strong) PFUser* user;
@property (nonatomic,strong) GADBannerView  *bannerView;
@property (nonatomic,strong) HJMHDetailHeaderView* header;

-(id)initWithUser:(PFUser*)user;
@end
