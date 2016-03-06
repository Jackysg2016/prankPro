//
//  HJMHUtility.m
//  prankPro
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHUtility.h"

@implementation HJMHUtility


#pragma mark Like Photos
+ (void)likeOrUnLikeInBackground:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [Like query];
    [queryExistingLikes whereKey:@"video" equalTo:item];
    [queryExistingLikes whereKey:@"user"  equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            if(activities.count!=0){
                for (PFObject *activity in activities) {
                    [activity delete];
                }
                [item incrementKey:@"like_count" byAmount:@-1];
            }else{
                // proceed to creating new like
                Like *likeActivity = [[Like alloc]init];
                likeActivity.user=[PFUser currentUser];
                likeActivity.video=item;
                
                [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (completionBlock) {
                        completionBlock(succeeded,error);
                    }
                }];
                
                [item incrementKey:@"like_count"];
                [item saveInBackground];
            }
            
        }
    }];
    
}

+ (void)isLiked:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFQuery *queryExistingLikes = [Like query];
    [queryExistingLikes whereKey:@"video" equalTo:item];
    [queryExistingLikes whereKey:@"user"  equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            if(activities.count!=0){
                if (completionBlock) {
                    completionBlock(YES,error);
                }
            }else{
                if (completionBlock) {
                    completionBlock(NO,error);
                }
            }
            
        }
    }];

}

+(void)reportVideo:(Video*)item block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
}

+ (id)myRefreshHead:(void(^)())block{
    MJRefreshNormalHeader* head = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"Pull to refresh" forState:MJRefreshStateIdle];
    [head setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [head setTitle:@"Refreshing" forState:MJRefreshStateRefreshing];
    return head;
}

+ (id)myRefreshFoot:(void(^)())block{
    MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    [foot setTitle:@"" forState:MJRefreshStateIdle];
    [foot setTitle:@"" forState:MJRefreshStatePulling];
    [foot setTitle:@"Refreshing" forState:MJRefreshStateRefreshing];
    return foot;
}

@end
