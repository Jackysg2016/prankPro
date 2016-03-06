//
//  HJMHProgressBar.m
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHProgressBar.h"

@interface HJMHProgressBar ()



@end

@implementation HJMHProgressBar

-(id) init{
    if(self=[super init]){
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    //背景
    [self addSubview:self.barView];
    [self.barView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    //进度条
    [self addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.center);
        make.size.equalTo(self);
    }];
    
}

#pragma mark - method

- (void)setProgressToWidth:(CGFloat)width
{
    [self.progressView updateConstraints:^(MASConstraintMaker *make) { 
        make.width.equalTo(self.width).multipliedBy(width);
    }];
}
 
#pragma lazy load
-(UIView*) barView{
    if(_barView==nil){
        _barView = [[UIView alloc] init];
        _barView.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.8];
    }
    return _barView;
}

-(UIView*) progressView{
    if(_progressView==nil){
        _progressView = [[UIView alloc]init];
        _progressView.backgroundColor = [UIColor colorWithRed:232.0/255 green:76.0/255 blue:61.0/255 alpha:1];
    }
    return _progressView;
}

@end
