//
//  HJMHSCrollBar.m
//  5last
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#define kTagGap 6250
#import "HJMHScrollBar.h"

@interface HJMHScrollBar (){
    CGFloat _itemSize;
    CGFloat _margin;
    UIColor *_norColor;
    UIColor *_selColor;
}
@end

@implementation HJMHScrollBar

- (id)initWithData:(NSArray*) data andNorSize:(CGFloat) itemSize andMargin:(CGFloat) margin
{
    if (self=[super init]) {
        // Initialization code
        _itemSize=itemSize;
        _margin=margin;
        self.items=[NSMutableArray arrayWithCapacity:10];
        [self initScrollBarWithData:data];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withData:(NSArray*) data
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        _itemSize=50;
        _margin=15;
        self.items=[NSMutableArray arrayWithCapacity:10];
        [self initScrollBarWithData:data];
        [self setSelectedItem:0];
    }
    return self;
}

-(void)initScrollBarWithData:(NSArray*)items{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < [items count]; i++)
    {
        UIImage* image=[UIImage imageNamed:items[i]];
        HJMHScrollBarItemView* item=[[HJMHScrollBarItemView alloc]initWithFrame:CGRectMake(i*(_itemSize+_margin), 0, _itemSize+_margin, _itemSize+_margin)  andImage:image  andText:items[i] andImageSize:_itemSize andMargin:_margin];
        // 单击的 Recognizer
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        tap.numberOfTapsRequired = 1;
        [item addGestureRecognizer:tap];
        item.userInteractionEnabled=true;
        [self.scrollView addSubview:item];
        [self.items addObject:item];

    }
    self.scrollView.contentSize = CGSizeMake([items count]*(_itemSize+_margin), self.frame.size.height);
}

-(void) setSelectedItem:(int)index{
    [self.items[index] setSelected];
}
#pragma mark - 私有方法

-(void)SingleTap:(UITapGestureRecognizer*)sender {
    for (HJMHScrollBarItemView* item in self.items) {
        [item setUnSelected];
    }
    
    HJMHScrollBarItemView* selItem=(HJMHScrollBarItemView*)sender.view;
    [selItem setSelected];
    //动画效果
    if ([self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
        [self.delegate didSelectedItem:(HJMHScrollBarItemView*)selItem];
    }
}
@end
