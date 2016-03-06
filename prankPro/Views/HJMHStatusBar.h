//
//  HJMHStatusBar.h
//  prankPro
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMHStatusBar : UIView

@property(nonatomic,strong)UILabel* play_count; 
@property(nonatomic,strong)UILabel* like_count;

-(void)SetStatusWithPlay:(int)playCount andLike:(int)likeCount;

@end
