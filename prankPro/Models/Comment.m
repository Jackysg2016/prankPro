//
//  Comment.m
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic text;
@dynamic user;
@dynamic video; 

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Comment";
}
@end
