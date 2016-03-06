//
//  Like.m
//  prankPro
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "Like.h"

@implementation Like

@dynamic video;
@dynamic user;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Like";
}

@end
