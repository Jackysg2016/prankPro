//
//  HJMHIndexCollectionViewCell.m
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHIndexCollectionViewCell.h"

@implementation HJMHIndexCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

-(void)initUI{
    UIView* superview=self.contentView;
    
    //预览
    self.thumbImageView=[[PFImageView alloc]init];
    self.thumbImageView.clipsToBounds=true;
    [superview addSubview:self.thumbImageView];
    [self.thumbImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(superview);
        make.size.equalTo(CGSizeMake((kWindowW-10)/2, (kWindowW-5)/2));
    }];
    
    //背景
    self.backView=[[UIView alloc]init];
    self.backView.backgroundColor=[UIColor blackColor];
    self.backView.layer.opacity=0.2;
    [superview addSubview:self.backView];
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(superview);
        make.height.equalTo(@35);
    }];
    
    //头像
    self.avatarImageView=[[PFImageView alloc]init];
    self.avatarImageView.layer.cornerRadius = 15.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    [superview addSubview:self.avatarImageView];
    [self.avatarImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView.centerY);
        make.left.equalTo(self.backView.left).offset(2);
        make.size.lessThanOrEqualTo(30);
    }];
    
    //姓名
    self.nameLabel=[[UILabel alloc]init];
    self.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    self.nameLabel.textColor = kMainTextColor;
    [superview addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView.centerY);
        make.left.equalTo(self.avatarImageView.right).offset(5);
    }];
    
}

@end
