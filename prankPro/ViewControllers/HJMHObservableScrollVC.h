//
//  HJObservableScrollViewController.h
//  2clip
//
//  Created by mac on 15/12/27.
//  Copyright © 2015年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h> 

@protocol HJMHObservableScrollVCDelegate <NSObject>
@optional
- (void)ScrollOffset:(CGPoint)offset;
@end

@interface HJMHObservableScrollVC : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, weak) id<HJMHObservableScrollVCDelegate> delegate;

- (instancetype)initWithControllers:(NSArray*)controllers;
- (NSInteger)currentPage;
- (void)setScrollViewPage:(NSInteger)page;

@end
