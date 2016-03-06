//
//  Report.m
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "Report.h"

@implementation Report
@dynamic video;
@dynamic reporter;
@dynamic readed;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Report";
}

@end
