//
//  Report.h
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Video.h"

@interface Report  : PFObject<PFSubclassing>

@property(nonatomic,strong)Video* video;
@property(nonatomic,strong)PFUser* reporter;
@property(nonatomic,assign,getter=isReaded)bool readed;
+ (NSString *)parseClassName;
@end