//
//  Comment.h
//  prankPro
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Video.h"

@interface Comment : PFObject<PFSubclassing>

@property(nonatomic,strong)NSString* text;
@property(nonatomic,strong)PFUser* user;
@property(nonatomic,strong)Video* video;

+ (NSString *)parseClassName;


@end
