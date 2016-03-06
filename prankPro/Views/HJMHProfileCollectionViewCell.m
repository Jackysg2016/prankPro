//
//  HJMHProfileCollectionViewCell.m
//  prankPro
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHProfileCollectionViewCell.h"

@implementation HJMHProfileCollectionViewCell


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
    self.backView.layer.opacity=0.1;
    [superview addSubview:self.backView];
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(superview);
        make.height.equalTo(@40);
    }];
    
//    //头像
//    self.avatarImageView=[[PFImageView alloc]init];
//    self.avatarImageView.backgroundColor=[UIColor redColor];
//    [superview addSubview:self.avatarImageView];
//    [self.avatarImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.backView.centerY);
//        make.left.equalTo(self.backView.left).offset(5);
//        make.size.lessThanOrEqualTo(30);
//    }];
//    
//    //姓名
//    self.nameLabel=[[UILabel alloc]init];
//    self.nameLabel.font=[UIFont fontWithName:@"Heiti" size:14];
//    self.nameLabel.textColor = [UIColor whiteColor];
//    [superview addSubview:self.nameLabel];
//    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.avatarImageView.centerY);
//        make.left.equalTo(self.avatarImageView.right).offset(5);
//    }];
    
}

@end
