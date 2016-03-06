//
//  HJObservableScrollViewController.m
//  2clip
//
//  Created by mac on 15/12/27.
//  Copyright © 2015年 huijimuhe. All rights reserved.
//

#import "HJMHObservableScrollVC.h"

@interface HJMHObservableScrollVC ()

@property (nonatomic, strong) NSArray<UIViewController*>* conArr;
@end

@implementation HJMHObservableScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 初始化

- (instancetype)initWithControllers:(NSArray*)controllers{
    if (self = [super init]) {
        self.view.backgroundColor=[UIColor whiteColor];
        self.conArr = controllers;
        [self.view addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        //适配iOS7uinavigationbar遮挡tableView的问题
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view needsUpdateConstraints];
    }
    return self;
}


#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        __block UIView* preView = nil;
        [self.conArr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController: obj];
            [_scrollView addSubview:obj.view];
            if (preView == nil) {
                [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.height.width.equalTo(_scrollView);
                }];
            }else{
                [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(preView.mas_right);
                    make.top.width.height.equalTo(preView);
                }];
            }
            preView = obj.view;
        }];
        [preView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_scrollView.mas_right);
            make.bottom.mas_equalTo(_scrollView.mas_bottom);
        }];
    }
    return _scrollView;
}

- (NSArray<UIViewController *> *)conArr{
    if (_conArr == nil) {
        _conArr = [NSArray array];
    }
    return _conArr;
}

- (NSInteger)currentPage{
    return self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}

- (void)setScrollViewPage:(NSInteger)page{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.frame.size.width * page;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(ScrollOffset:)]) {
        [self.delegate ScrollOffset:scrollView.contentOffset];
    }
}


@end
