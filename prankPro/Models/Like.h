//
//  Like.h
//  prankPro
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import "Video.h"

@interface Like : PFObject<PFSubclassing>

@property(nonatomic,strong)Video* video;
@property(nonatomic,strong)PFUser* user;
+ (NSString *)parseClassName;

@end
