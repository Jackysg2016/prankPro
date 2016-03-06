//
//  HJMHProfileCollectionViewCell.h
//  prankPro
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHProfileCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)   PFImageView *thumbImageView;
@property (strong, nonatomic)   PFImageView *avatarImageView;
@property (strong, nonatomic)   UILabel *nameLabel;
@property (strong, nonatomic)   UILabel *likeLabel;
@property (strong, nonatomic)   UIView *backView;

@end
