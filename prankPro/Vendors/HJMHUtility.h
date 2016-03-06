//
//  HJMHUtility.h
//  prankPro
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Video.h"
#import "Like.h"

@interface HJMHUtility : NSObject
+ (void)likeOrUnLikeInBackground:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)isLiked:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+(void)reportVideo:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (id)myRefreshHead:(void(^)())block;
+ (id)myRefreshFoot:(void(^)())block;
@end
