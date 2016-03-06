//
//  UIViewController+Login.m
//  prankPro
//
//  Created by mac on 16/2/9.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "UIViewController+Login.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HJMHLoginVC.h"

@implementation UIViewController(Login)

-(BOOL)isLogin{
    if(![PFUser currentUser]){
        HJMHLoginVC* vc=[[HJMHLoginVC alloc]init];
        vc.delegate=self;
        vc.fields = (PFLogInFieldsDismissButton
                     | PFLogInFieldsFacebook);
        vc.facebookPermissions=@[@"public_profile", @"user_about_me"];
        [self presentViewController:vc animated:YES completion: nil];
        return NO;
    }else{
        return YES;
    }
}

#pragma Account login

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    if (![FBSDKAccessToken currentAccessToken]) {
        NSLog(@"FB Session does not exist, logout");
    }
    
    if (![FBSDKAccessToken currentAccessToken].userID) {
        NSLog(@"userID on FB Session does not exist, logout");
    }
    
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"Failed refresh of FB Session, logging out: %@", error);
        }
        
        // refreshed
        NSLog(@"refreshed permissions: %@", [FBSDKAccessToken currentAccessToken]);
        
        FBSDKAccessToken *currentAccessToken = [FBSDKAccessToken currentAccessToken];
        if ([currentAccessToken hasGranted:@"public_profile"]) {
            // Logged in with FB
            // Create batch request for all the stuff
            FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
            [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"name"}] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    // Failed to fetch me data.. logout to be safe
                    NSLog(@"couldn't fetch facebook /me data: %@, logout", error);
                    [PFUser logOut];
                }
                PFUser* user=[PFUser currentUser];
                user.username=result[@"name"];
                [user saveInBackground];
                NSString *facebookName = result[@"name"];
                NSLog(@"the facebook name is:%@",facebookName);
            }];
            
            // profile pic request
            [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(500).height(500)"}] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    NSURL *profilePictureURL = [NSURL URLWithString: userData[@"picture"][@"data"][@"url"]];
                    
                    //download
                    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:profilePictureURL];
                    
                    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        NSData* img=[NSData dataWithContentsOfFile:filePath.path];
                        PFFile *imageFile = [PFFile fileWithData:img contentType:@"jpg"];
                        PFUser* user=[PFUser currentUser];
                        user[@"avatar"]=imageFile ;
                        [user saveInBackground];
                    }];
                    [downloadTask resume];
                } else {
                    NSLog(@"Error getting profile pic url, setting as default avatar: %@", error);
                }
            }];
            
            [connection start];
        } else {
            
        }
        
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
