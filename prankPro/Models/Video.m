//
//  HJMHVideo.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "Video.h"

@implementation Video

@dynamic name;
@dynamic user;
@dynamic url;
@dynamic thumb; 
@dynamic like_count;
@dynamic play_count;
@dynamic isBanned;
+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Video";
}

@end
