//
//  HJMHAccountHeaderView.h
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHProfileHeaderView : UICollectionReusableView

@property(nonatomic,strong) PFImageView* avatarImageView;
@property(nonatomic,strong) UILabel* nameLabel;
@property(nonatomic,strong) UILabel* video_count;

-(void)setContent:(PFUser*) data;
@end
