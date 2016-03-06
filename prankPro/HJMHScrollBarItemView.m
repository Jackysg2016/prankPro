//
//  HJMHScrollBarItemView.m
//  5last
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHScrollBarItemView.h"

@implementation HJMHScrollBarItemView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)img andText:(NSString*) text andImageSize:(CGFloat)size andMargin:(CGFloat) margin
{ 
    if (self = [super initWithFrame:frame]) {
        
        //init img
        self.icon=[[UIImageView alloc]initWithFrame:self.bounds];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.icon.image=img;
        CGRect bounds=self.icon.frame;
        bounds=CGRectMake(bounds.origin.x+margin/2,bounds.origin.y,bounds.size.width-margin, bounds.size.height-margin);
        self.icon.frame=bounds;
        [self addSubview:self.icon];
        
        //text
        self.text=[[UILabel alloc]initWithFrame:self.bounds];
        CGRect tBounds=self.text.frame;
        tBounds=CGRectMake(tBounds.origin.x,tBounds.origin.y+size,tBounds.size.width,tBounds.size.height-size);
        self.text.frame=tBounds;
        self.text.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
        self.text.textColor=[UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.text=text;
        [self addSubview:self.text];
        
        //unselected
        [self setUnSelected];
        
    }
    return self;
}

-(void)setSelected{
    self.alpha=1;
}

-(void)setUnSelected{
    self.alpha=0.6;
}
@end
