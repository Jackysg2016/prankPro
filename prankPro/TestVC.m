//
//  TestVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "TestVC.h"
#import "Video.h" 
#import "Comment.h"
#import "HJMHCaptureVC.h"
#import "HJMHIndexCollectionVC.h" 
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HJMHScrollBar.h"

@implementation TestVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //admob
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    if([PFUser currentUser]){
        NSLog(@"user %@ loged in",[PFUser currentUser].username);
    }
    [self initBar];
    //[self initBtn];

    //sandbox测试
}

#pragma Progress bar
-(void)initBar{
    self.time=8;
    //进度条
    self.bar=[[HJMHProgressBar alloc]init];
    
    [self.bar initalize];
    [self.view addSubview:self.bar];
    [self.bar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(100);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(@20);
    }];
    
    //按钮
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(150, 150, 50, 50);
    UIImage* img=[[UIImage imageNamed:@"shaver"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self.view addSubview:btn];
    
    //imageview
    UIImageView* iv1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shaver"]];
    iv1.frame=CGRectMake(50, 200, 40, 40);
    [self.view addSubview:iv1];
    
    //imageview
    UIImageView* iv2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bug"]];
    iv2.frame=CGRectMake(100, 200, 40, 40);
    [self.view addSubview:iv2];
    
    //scroll bar
    NSArray* items=@[ @"bug",@"craker",@"shaver",@"craker",@"bug"];
    HJMHScrollBar* bar=[[HJMHScrollBar alloc]initWithFrame:CGRectMake(0,300, self.view.frame.size.width, 100) withData:items];
    [self.view addSubview:bar];
}

-(void)recordClick{
    HJMHCaptureVC* vc=[[HJMHCaptureVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
   // [self.navigationController pushViewController:vc animated:YES];
    
//    HJMHIndexCollectionVC* vc=[[HJMHIndexCollectionVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    PFLogInViewController* vc=[[PFLogInViewController alloc]init];
//    vc.delegate=self;
//    vc.fields = (PFLogInFieldsUsernameAndPassword
//                              | PFLogInFieldsLogInButton
//                              | PFLogInFieldsSignUpButton
//                              | PFLogInFieldsPasswordForgotten
//                 | PFLogInFieldsDismissButton
//                 | PFLogInFieldsFacebook
//                 | PFLogInFieldsTwitter);
//vc.facebookPermissions=@[@"public_profile", @"user_about_me"];
//    [self presentViewController:vc animated:YES completion:^{
//        NSLog(@"present login");
//    }];
}

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
            [connection addRequest:[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"name" }] completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (error) {
                    // Failed to fetch me data.. logout to be safe
                    NSLog(@"couldn't fetch facebook /me data: %@, logout", error);
                }
                
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
                        NSLog(@"File downloaded to: %@", filePath);
                        NSData* img=[NSData dataWithContentsOfFile:filePath];
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

    NSLog(user.username);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Parse
-(void)initBtn{
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(150, 150, 50, 50);
    [btn setTitle:@"sign in" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15.0];
    btn.titleLabel.textColor = [UIColor colorWithRed:(114.0/255.0) green:(115.0/255.0) blue:(116.0/255.0) alpha:1.0];
    [btn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self.view addSubview:btn];
    
    UIButton* btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame=CGRectMake(150, 200, 50, 50);
    [btn2 setTitle:@"sign out" forState:UIControlStateNormal];
    btn2.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15.0];
    btn2.titleLabel.textColor = [UIColor colorWithRed:(114.0/255.0) green:(115.0/255.0) blue:(116.0/255.0) alpha:1.0];
    [btn2 addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    [btn2 sizeToFit];
    [self.view addSubview:btn2];
    
    UIButton* btn3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame=CGRectMake(150, 250, 50, 50);
    [btn3 setTitle:@"add Data" forState:UIControlStateNormal];
    btn3.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15.0];
    btn3.titleLabel.textColor = [UIColor colorWithRed:(114.0/255.0) green:(115.0/255.0) blue:(116.0/255.0) alpha:1.0];
    [btn3 addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    [btn3 sizeToFit];
    [self.view addSubview:btn3];
    
    UIButton* btn4=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.frame=CGRectMake(150, 300, 50, 50);
    [btn4 setTitle:@"query data" forState:UIControlStateNormal];
    btn4.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15.0];
    btn4.titleLabel.textColor = [UIColor colorWithRed:(114.0/255.0) green:(115.0/255.0) blue:(116.0/255.0) alpha:1.0];
    [btn4 addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
    [btn4 sizeToFit];
    [self.view addSubview:btn4];
}

-(void)query{
     PFUser* user=[PFUser currentUser];
    
    //查询一个用户的所有评论
//    PFQuery* query= [Comment query];
//    [query whereKey:@"user" equalTo:user];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        for (Comment* item in objects)
//        {
//            NSLog(@"video name is:%@",item.text);
//        }
//    }];
    //查询一个视频的所有评论
 
}

-(void)addData{
    PFUser* user=[PFUser currentUser];
//    for (int i=0; i<100; i++) {
//        Video* v=[[Video alloc]init];
//        v.name=[NSString stringWithFormat: @"this is video Num:%d",i];
//        v.user=user;
//        [v saveInBackgroundWithTarget:self selector:@selector(saveHandler:)];
//        NSLog(@"saved video %@",v.objectId);
//    }
    
    //评论
    Video* v=[[Video alloc]init];
    v.name=@"how you fuck yourself";
    v.user=user;
    
    Comment* comment=[[Comment alloc]init];
    comment.video=v;
    comment.user=user;
    comment.text=@"you did it well";
    [comment saveInBackground];
}

-(void)saveHandler:(id)sender{
    Video* v=(Video*)sender;
    NSLog(@"saved");
}

-(void)signOut{
    if([PFUser currentUser]){
        [PFUser logOut];
    }
}

-(void)signIn{

    if(![PFUser currentUser]){
        PFLogInViewController* vc=[[PFLogInViewController alloc]init];
        vc.delegate=self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    NSLog(@"logined");
    PFUser* u=[PFUser currentUser];
    NSLog(@"username:%@;pwd:%@", u.username,u.password);
    

//    PFLogInViewController* vc=[[PFLogInViewController alloc]init];
//    vc.delegate=self;
//    [self presentViewController:vc animated:YES completion:nil];
    
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
//    User* u=[[User alloc]init];
//    u.name=@"zeng wei zhou";
//    [u saveInBackground];
//    Video* v=[[Video alloc]init];
//    v.name=@"bbebebe";
//    v.user=u;
//    [v saveInBackground];
//    [Video query];
    
//    // Create the post
//    PFObject *myPost = [PFObject objectWithClassName:@"Post"];
//    myPost[@"title"] = @"I'm Hungry";
//    myPost[@"content"] = @"Where should we go for lunch?";
//    
//    // Create the comment
//    PFObject *myComment = [PFObject objectWithClassName:@"Comment"];
//    myComment[@"content"] = @"Let's do Sushirrito.";
//    
//    // Add a relation between the Post and Comment
//    myComment[@"parent"] = myPost;
//    
//    // This will save both myPost and myComment
//    [myComment saveInBackground];
}

@end
