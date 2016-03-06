//
//  HJMHWaterMarkView.m
//  prankPro
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHWaterMarkView.h"

@interface HJMHWaterMarkView() {
    UILabel *_watermarkLabel;
}
@end

@implementation HJMHWaterMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _watermarkLabel = [UILabel new];
        _watermarkLabel.textColor = [UIColor whiteColor];
        _watermarkLabel.font = [UIFont boldSystemFontOfSize:40];
        _watermarkLabel.text = @"#PrankPro";
        
        [self addSubview:_watermarkLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static const CGFloat inset = 18;
    
    CGSize size = self.bounds.size;
    
    [_watermarkLabel sizeToFit];
    CGRect watermarkFrame = _watermarkLabel.frame;
    watermarkFrame.origin.x = size.width - watermarkFrame.size.width - inset;
    watermarkFrame.origin.y = self.bounds.origin.y + inset*2;    //
    _watermarkLabel.frame = watermarkFrame;
    
}
 

@end
