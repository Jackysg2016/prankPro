//
//  HJMHVideo.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <Parse/PFObject+Subclass.h>
@interface Video : PFObject<PFSubclassing>

@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)PFUser* user;
@property(nonatomic,strong)NSString* url;
@property(nonatomic,strong)PFFile* thumb;
@property(nonatomic,assign)int play_count;
@property(nonatomic,assign)int like_count;
@property(nonatomic,assign)BOOL isBanned;
+ (NSString *)parseClassName;

@end
