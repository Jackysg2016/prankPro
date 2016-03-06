//
//  HJMHSCrollBar.h
//  5last
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJMHScrollBarItemView.h"

@protocol HJMHScrollBarDelegate<NSObject>

-(void)didSelectedItem:(HJMHScrollBarItemView*) item;

@end

@interface HJMHScrollBar : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, weak) id<HJMHScrollBarDelegate> delegate;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, strong) NSMutableArray* items;

- (id)initWithFrame:(CGRect)frame withData:(NSArray*) data;
- (id)initWithData:(NSArray*) data andNorSize:(CGFloat) itemSize andMargin:(CGFloat) margin;
-(void) setSelectedItem:(int)index;
@end
