//
//  HJMHCommentCellTableViewCell.m
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHCommentTableViewCell.h"

@implementation HJMHCommentTableViewCell
 
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
                 {
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}


-(void)initUI{
    UIView* superview=self.contentView;
    
    //头像
    self.avatarImage=[[PFImageView alloc]init];
    self.avatarImage.backgroundColor=[UIColor redColor];
    [superview addSubview:self.avatarImage];
    [self.avatarImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(superview).offset(5);
        make.size.equalTo(45);
    }];
    
    
    //姓名
    self.nameLabel=[[UILabel alloc]init];
    self.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
    [superview addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.top);
        make.left.equalTo(self.avatarImage.right).offset(5);
    }];
    
    //内容
    self.contentLabel=[[UILabel alloc]init];
    self.contentLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    self.contentLabel.lineBreakMode=UILineBreakModeWordWrap;
    self.contentLabel.numberOfLines=0;

    [superview addSubview:self.contentLabel];
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(5);
        make.left.equalTo(self.avatarImage.right).offset(5);
    }];
    
    //时间
//    self.timeLabel=[[UILabel alloc]init];
//    self.timeLabel.font=[UIFont fontWithName:@"Heiti" size:14];
//    [superview addSubview:self.timeLabel];
//    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.equalTo(superview).offset(5);
//    }];
}

@end
