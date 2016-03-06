//
//  HJMHPreviewVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHPreviewVC.h"
#import "Video.h"
#import "AppDelegate.h"

@implementation HJMHPreviewVC

#pragma events

-(void) viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self initNav];
    [self initAd];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.preview.player setItemByAsset:_recordSession.assetRepresentingSegments];
    [self.preview.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player pause];
}

-(void)initNav{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleCancelClick)];

}

-(void)initAd{
    //ad banner
    self.interstitial =  [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1232384027425912/1747560983"];
    self.interstitial.delegate=self;
    
    GADRequest* request=[GADRequest request]; 
    [self.interstitial loadRequest:request];
    
}

-(void)initUI{
    
    self.navigationController.title=@"Profile";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //播放预览
    [self.view addSubview:self.preview];
    [self.preview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);//.offset(10);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.width);
    }];
    
    self.preview.tapToPauseEnabled = YES;
    self.preview.player.loopEnabled = YES;
    
//    //社交分享label
//    UILabel* shareTitle=[[UILabel alloc]init];
//    shareTitle.text=@"Share";
//    shareTitle.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
//    [shareTitle sizeToFit];
//    [self.view addSubview:shareTitle];
//    [shareTitle makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.preview.bottom).offset(10);
//        make.left.equalTo(self.view.left).offset(10);
//    }];
//    
//    //社交分享按钮
//    [self.view addSubview:self.shareBtn];
//    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(shareTitle.bottom).offset(10);
//        make.left.equalTo(shareTitle.left);
//    }];
    
    //上传按钮
    [self.view addSubview:self.uploadBtn];
    [self.uploadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(@60);
    }];

}

#pragma upload

-(void)uploadVideo:(NSData*)data andToken:(NSString*) token block:(void (^)(BOOL succeeded,NSString* path))completionBlock{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:nil token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
                  if(completionBlock){
                      completionBlock(YES,resp[@"key"]);
                  }
              } option:nil];
}

-(void)handleUploadClick{
    if([self isLogin]){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString* url=@"yours";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString* token=[responseObject valueForKey:@"uptoken"];
            NSData* videoFile=[[NSData alloc]initWithContentsOfURL:self.fileURL];
            [self uploadVideo:videoFile andToken:token block:^(BOOL succeeded,NSString* path) {
                NSData *imageData = UIImagePNGRepresentation(self.thumbnail);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                Video* model=[[Video alloc]init];
                model.thumb=imageFile;
                model.name=@"video";
                model.isBanned=NO;
                model.url=[NSString stringWithFormat:@"yours%@",path];
                model.user=[PFUser currentUser];
                [model saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // 结束刷新
            NSLog(@"Error: %@", error);
        }];
    }
}

-(void)handleCancelClick{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma lazy load

-(SCVideoPlayerView*)preview{
    if(_preview==nil){
        _preview=[[SCVideoPlayerView alloc]init];
        _preview.backgroundColor=[UIColor blackColor];
    }
    return _preview;
}

-(FBSDKShareButton*) shareBtn{
    if(_shareBtn==nil){
        FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
        video.videoURL = self.fileURL;
        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
        content.video = video;
        _shareBtn=[[FBSDKShareButton alloc] init];
        _shareBtn.shareContent = content;
    }
    return _shareBtn;
}

-(UIButton*) uploadBtn{
    if(_uploadBtn==nil){
         _uploadBtn=[[UIButton alloc] init];
        _uploadBtn.backgroundColor=[UIColor redColor];
        [_uploadBtn setTitle:@"Upload" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(handleUploadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

-(UIView*) share{
    if(_share==nil) {
        _share=[[UIView alloc]init];
        _share.backgroundColor=[UIColor redColor];
    }
    return _share;
}
@end
