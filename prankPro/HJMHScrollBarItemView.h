//
//  HJMHScrollBarItemView.h
//  5last
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHScrollBarItemView : UIView

@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* text;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)img andText:(NSString*) text andImageSize:(CGFloat)size andMargin:(CGFloat) margin;

-(void)setSelected;

-(void)setUnSelected;
@end
