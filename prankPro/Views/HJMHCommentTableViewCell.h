//
//  HJMHCommentCellTableViewCell.h
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) PFImageView *avatarImage;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end
