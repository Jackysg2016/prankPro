//
//  HJMHCaptureVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"
#import "HJMHProgressBar.h"
#import "HJMHScrollBar.h"
#import "HJMHTouch.h"
#import "HJMHWaterMarkView.h"
#import "Video.h"

@interface HJMHCaptureVC : UIViewController<SCRecorderDelegate,SCAssetExportSessionDelegate,UIAlertViewDelegate,HJMHScrollBarDelegate>

@property (strong, nonatomic)    UIButton *recordBtn;
@property (strong, nonatomic)    UIButton *cancelBtn;
@property (strong, nonatomic)    UIButton *flashBtn;
@property (strong, nonatomic)    UIButton *cameraBtn;
@property (strong, nonatomic)    UIButton *okBtn;
@property (strong, nonatomic)    UIView *preview;
@property (strong, nonatomic)    HJMHProgressBar *progressBar;
@property (strong, nonatomic)    HJMHScrollBar *soundBar;
@property (strong, nonatomic)    AVAudioPlayer *audioPlayer;//播放器
@property (strong, nonatomic)    NSArray* soundItems;
@property (assign,nonatomic,getter=isEnterBack) BOOL enterBack;
@end
