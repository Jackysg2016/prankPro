//
//  HJMHAccountHeaderView.m
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHProfileHeaderView.h"

@implementation HJMHProfileHeaderView
 
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor=[UIColor colorWithRed:88.0f/255.0f green:88.0f/255.0f blue:88.0f/255.0f alpha:1];
    //头像
    self.avatarImageView=[[PFImageView alloc]init];
    self.avatarImageView.backgroundColor=[UIColor redColor];
    self.avatarImageView.layer.cornerRadius = 30.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    [self addSubview:self.avatarImageView];
    [self.avatarImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.size.lessThanOrEqualTo(60);
    }];
    
    //姓名
    self.nameLabel=[[UILabel alloc]init];
    self.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    self.nameLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.right).offset(10);
    }];
    
//    //视频数量icon
//    UIImageView* iconLike=[[UIImageView alloc]init];
//    iconLike.image=[[UIImage imageNamed:@"movie"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self addSubview:iconLike];
//    [iconLike makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.avatarImageView.bottom);
//        make.left.equalTo(self.avatarImageView.right).offset(10);
//        make.height.equalTo(20);
//    }];
//
//    //视频数量
//    self.video_count=[[UILabel alloc]init];
//    self.video_count.font=[UIFont fontWithName:@"Heiti" size:13];
//    [self addSubview:self.video_count];
//    [self.video_count makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(iconLike.centerY);
//        make.left.equalTo(iconLike.right).offset(10);
//    }];
//    
//    //分割线
//    UIView* seperator=[[UIView alloc]init];
//    seperator.backgroundColor=[UIColor grayColor];
//    [self addSubview:seperator];
//    [seperator makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.avatarImageView.bottom).offset(20);
//        make.left.equalTo(self);
//        make.width.equalTo(self);
//        make.height.equalTo(1);
//    }];
}

-(void)setContent:(PFUser*) data{
    self.avatarImageView.image=[UIImage imageNamed:@"avatar"];
    self.avatarImageView.file=data[@"avatar"];
    [self.avatarImageView loadInBackground];
    
    self.nameLabel.text=data.username;
    
//    self.video_count.text=data[@"video_count"];
}
@end
