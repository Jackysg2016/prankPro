//
//  HJMHCaptureVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//
#define kVideoLength 6
#import "HJMHCaptureVC.h"
#import "HJMHPreviewVC.h"

@interface HJMHCaptureVC(){
    SCRecorder* _recorder;
    SCRecordSession* _recordSession;
}
@end

@implementation HJMHCaptureVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initSounds];
    
    [self initUI];
    
    [self initRecord];
    
    [self.navigationController setNavigationBarHidden:YES];
    //注册通知观察
    //因为转入后台挂起后恢复可能会继续执行录制
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBackToFront) name:@"NOTIFICATION_CAPTURE_BACKTOFRONT" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBack) name:@"NOTIFICATION_CAPTURE_ENTERBACK" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSession];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_recorder stopRunning];
    [self.audioPlayer pause];
    self.audioPlayer=nil;
    _recorder.previewView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_CAPTURE_ENTERBACK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_CAPTURE_BACKTOFRONT" object:nil];
}

#pragma 初始化

-(void) initRecord{
    //是否初始化
    self.enterBack=NO;
    
    //捕捉初始化
    _recorder=[SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    //配置
    SCVideoConfiguration *videoConf = _recorder.videoConfiguration;
    videoConf.size = CGSizeMake(640, 640);
    videoConf.scalingMode = AVVideoScalingModeResizeAspectFill;
    _recorder.videoConfiguration=videoConf;
    
    //预览
    UIView *previewView = self.preview;
    _recorder.previewView = previewView;
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
}
-(void)didEnterBack{
    if(_recorder.isRecording){
        [_recorder pause];
        [self.audioPlayer stop];
        [self.audioPlayer setCurrentTime:0];
        self.enterBack=YES;
    }
}
-(void)didBackToFront{
    if(self.isEnterBack){
       [self.progressBar setProgressToWidth:1.0f];
        [self.view layoutIfNeeded];
        self.enterBack=NO;
    }
}

-(void)initSounds{
    self.soundItems=@[ @"shaver",@"hairdryer",@"bug",@"craker",@"fart"];
    [self selectSound:self.soundItems.firstObject];
}

-(void) initUI{
    
    self.view.backgroundColor=[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];

    UIView* superview=self.view;
    int topMargin=25;
    
    //预览界面
    [self.view addSubview:self.preview];
    [self.preview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.top);
        make.left.equalTo(superview.left);
        make.width.equalTo(superview.width);
        make.height.equalTo(superview.width);
    }];
    self.preview.clipsToBounds = YES;
    
    //进度条
    [self.view addSubview:self.progressBar];
    [self.progressBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.preview.bottom);
        make.left.equalTo(superview.left);
        make.width.equalTo(superview.width);
        make.height.equalTo(8);
    }];
    
    //闪光灯
    [self.view addSubview:self.flashBtn];
    [self.flashBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(topMargin);
        make.centerX.equalTo(superview.centerX).offset(-20);
    }];
    
    //切换镜头
    [self.view addSubview:self.cameraBtn];
    [self.cameraBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flashBtn.centerY);
        make.left.equalTo(self.flashBtn.right).offset(20);
    }];
    
//    //确认按钮
//    [self.view addSubview:self.okBtn];
//    [self.okBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.flashBtn.centerY);
//        make.left.equalTo(self.cameraBtn.right).offset(10);
//        make.size.equalTo(iconSize);
//    }];
    
    //取消按钮
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.top).offset(topMargin);
        make.left.equalTo(superview.left).offset(10);
    }];
 
    //声音bar
    [self.view addSubview:self.soundBar];
    [self.soundBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressBar.bottom).offset(10);
        make.centerX.equalTo(superview.centerX);
        make.width.equalTo(superview.width);
        make.height.equalTo(65);
    }];
    self.soundBar.delegate=self;
    [self.view layoutIfNeeded];
    
    //捕捉按钮
    [self.view addSubview:self.recordBtn];
    [self.recordBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superview.bottom).offset(-10);
        make.centerX.equalTo(superview.centerX);
        make.size.equalTo(100);
    }];
    
//    //scroll bar
//    NSArray* items=@[ @"bug",@"craker",@"shaver",@"craker",@"bug"];
//    HJMHScrollBar* bar=[[HJMHScrollBar alloc]initWithFrame:CGRectMake(0,600, self.view.frame.size.width, 100) withData:items];
//    [self.view addSubview:bar];
}

#pragma capture初始化

- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    NSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        
        _recorder.session = session;
    }
}
#pragma 捕捉事件

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *__nonnull)recorder didInitializeAudioInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error{
    NSLog(@"didInitializeAudioInSession: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession{
    CGFloat curTime=CMTimeGetSeconds(_recorder.session.currentSegmentDuration);
    
    //超过录制时间停止录制
    if(curTime>kVideoLength){
        [_recorder pause];
        [self.audioPlayer stop];
        NSLog(@"stoped");  
    }
    [self.progressBar setProgressToWidth:(kVideoLength-curTime)/kVideoLength];
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
    
    if(!self.isEnterBack){
        //导出视频
        [self saveMPG:_recorder.session.assetRepresentingSegments];
    }else{
        [_recorder.session removeAllSegments];
    }
}

#pragma export



-(void)saveMPG:(AVAsset*)asset{
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset =SCPresetMediumQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = _recorder.session.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    exportSession.contextType = SCContextTypeAuto;
    HJMHWaterMarkView *overlay = [HJMHWaterMarkView new];
    exportSession.videoConfiguration.overlay = overlay;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"Saving %@",_recorder.session.outputUrl);
         CFTimeInterval time = CACurrentMediaTime();
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
          
        NSError *error = exportSession.error;
        
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        if(error!=nil){
            if (!exportSession.cancelled) {
                [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return;
        }
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            if (error == nil) {
                SCRecordSessionSegment* item=  [_recorder.session.segments firstObject];
                UIImage* img=item.randomThumbnail;
                //转到预览界面
                HJMHPreviewVC* previewVC=[[HJMHPreviewVC alloc]init];
                previewVC.fileURL=_recorder.session.outputUrl;
                previewVC.recordSession=_recorder.session;
                previewVC.thumbnail=img;
                //[self.navigationController popViewControllerAnimated:NO];
                [self.navigationController pushViewController:previewVC animated:YES];
                
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
       
    }];
    
}



#pragma click event

- (void)handleTouchDetected:(HJMHTouch*)touchDetector {
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
        [_recorder record];
       bool res= [self.audioPlayer play];
    }
    //    else if (touchDetector.state == UIGestureRecognizerStateEnded) {
    //        [_recorder pause];
    //    }
}

- (void)handleCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)handleOKClick {
//    HJPreviewVC* vc=[[HJPreviewVC alloc]init];
//    vc.recordSession=_recorder.session;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleCameraClick {
    [_recorder switchCaptureDevices]; 
}

- (void)handleFlashClick {
    switch (_recorder.flashMode) {
        case SCFlashModeOff:
            _recorder.flashMode = SCFlashModeLight;
            break;
        case SCFlashModeLight:
            _recorder.flashMode = SCFlashModeOff;
            break;
        default:
            break;
    }
}

#pragma sound bar

-(void)didSelectedItem:(HJMHScrollBarItemView*) item{
    NSLog(@"%@",item.text.text);
    [self selectSound:item.text.text];
}

-(void)selectSound:(NSString*)item{
    NSString *urlStr=[[NSBundle mainBundle]pathForResource:item ofType:@"mp3"];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    NSError *error=nil;
    if (!_audioPlayer) {
        
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if(error){
            NSLog(@"init audio player error:%@",error.localizedDescription);
        }
    }else{
        _audioPlayer =nil;
        
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if(error){
            NSLog(@"init audio player error:%@",error.localizedDescription);
        }
    }
    //设置播放器属性
    _audioPlayer.numberOfLoops=-1;//设置为0不循环
    //  _audioPlayer.delegate=self;
    [_audioPlayer prepareToPlay];//加载音频文件到缓存
}

#pragma lazy load
-(UIButton*) recordBtn{
    if(_recordBtn==nil){
        _recordBtn=[[UIButton alloc]init];
        [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"capture"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_recordBtn addGestureRecognizer:[[HJMHTouch alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    }
    return _recordBtn;
}

-(UIButton*) flashBtn{
    if(_flashBtn==nil){
        _flashBtn=[[UIButton alloc]init];
        [_flashBtn setBackgroundImage:[[UIImage imageNamed:@"flash"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(handleFlashClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _flashBtn;
}

-(UIButton*) cancelBtn{
    if(_cancelBtn==nil){
        _cancelBtn=[[UIButton alloc]init];
        [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(handleCancelClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

-(UIButton*) cameraBtn{
    if(_cameraBtn==nil){
        _cameraBtn=[[UIButton alloc]init];
        UIImage *buttonNorImg = [[UIImage imageNamed:@"capture_flip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_cameraBtn setBackgroundImage:buttonNorImg forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(handleCameraClick) forControlEvents:UIControlEventTouchUpInside]; 
    }
    return _cameraBtn;
}

-(UIButton*) okBtn{
    if(_okBtn==nil){
        _okBtn=[[UIButton alloc]init]; 
        //        UIImage *buttonNorImg = [[UIImage imageNamed:@"success.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //        [_okBtn setBackgroundImage:buttonNorImg forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(handleOKClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

-(UIView*) preview{
    if(_preview==nil){
        _preview=[[UIView alloc]init];
    }
    return _preview;
}

-(HJMHProgressBar*) progressBar{
    if(_progressBar==nil){
        _progressBar=[[HJMHProgressBar alloc]init];
    }
    return _progressBar;
}

-(HJMHScrollBar*) soundBar{
    if(_soundBar==nil){
        //scroll bar
        
       _soundBar= [[HJMHScrollBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 75) withData:self.soundItems];
    }
    return _soundBar;
}

//-(AVAudioPlayer *)audioPlayer{
//    if (!_audioPlayer) {
//        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"shave" ofType:@"mp3"];
//        NSURL *url=[NSURL fileURLWithPath:urlStr];
//        NSError *error=nil;
//        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
//        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        //设置播放器属性
//        _audioPlayer.numberOfLoops=-1;//设置为0不循环
//      //  _audioPlayer.delegate=self;
//        [_audioPlayer prepareToPlay];//加载音频文件到缓存
//        if(error){
//            NSLog(@"init audio player error:%@",error.localizedDescription);
//            return nil;
//        }
//    }
//    return _audioPlayer;
//}

@end
