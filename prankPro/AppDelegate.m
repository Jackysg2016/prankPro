//
//  AppDelegate.m
//  prankPro
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    // Parse initialization
    [Parse setApplicationId:@"yours" clientKey:@"yours"];
    //Register for facebook
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    //Register for twitter
    [PFTwitterUtils initializeWithConsumerKey:@"yours"
                               consumerSecret:@"yours"];
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CAPTURE_BACKTOFRONT"
                                                        object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CAPTURE_ENTERBACK"
                                                        object:nil];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}
 

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 懒加载

- (UIWindow *)window{
     
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        _window.rootViewController =[[UINavigationController alloc]initWithRootViewController: self.root];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (HJMHIndexCollectionVC *) root{
    if (_root == nil) {
        _root =[[HJMHIndexCollectionVC alloc]init];
    }
    return _root;
}
@end
