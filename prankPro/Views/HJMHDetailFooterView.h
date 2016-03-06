//
//  HJMHCommentFooter.h
//  prankPro
//
//  Created by mac on 16/2/7.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHDetailFooterView : UIView
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic) BOOL hideDropShadow;

+ (CGRect)rectForView;

@end
