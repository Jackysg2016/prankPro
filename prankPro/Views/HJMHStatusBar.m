//
//  HJMHStatusBar.m
//  prankPro
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHStatusBar.h"

@implementation HJMHStatusBar


-(void)SetStatusWithPlay:(int)playCount andLike:(int)likeCount{
    self.play_count.text=[NSString stringWithFormat:@"%d", playCount];
    self.like_count.text=[NSString stringWithFormat:@"%d", likeCount];
}

-(instancetype)init{
    if(self=[super init]){
        [self initViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    //播放次数
    UIImageView* iconPlay=[[UIImageView alloc]init];
    iconPlay.image=[UIImage imageNamed:@"play"];
    
    [self addSubview:iconPlay];
    [self addSubview:self.play_count];
    
    [iconPlay makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.size.equalTo(15);
    }];
    [self.play_count makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(iconPlay.mas_right).offset(5);
    }];
    
    //点赞数量
    UIImageView* iconLike=[[UIImageView alloc]init];
    iconLike.image=[UIImage imageNamed:@"like"];
    [self addSubview:iconLike];
    [self addSubview:self.like_count];
    
    [iconLike makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.play_count.mas_right).offset(25);
        make.size.equalTo(15);
    }];
    
    [self.like_count makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(iconLike.mas_right).offset(5);
    }];
}

#pragma lazy load
-(UILabel*) play_count{
    if(_play_count==nil){
        _play_count=[[UILabel alloc]init];
        _play_count.textColor =kSubTextColor;
        _play_count.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    }
    return _play_count;
}

-(UILabel*) like_count{
    if(_like_count==nil){
        _like_count=[[UILabel alloc]init];
        _like_count.textColor =kSubTextColor;
        _like_count.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    }
    return _like_count;
}

@end
