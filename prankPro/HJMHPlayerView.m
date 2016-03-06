//
//  HJPlayerView.m
//  2clip
//
//  Created by mac on 16/1/3.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHPlayerView.h"

@interface HJMHPlayerView ()

@property (nonatomic, strong) HJMHPlayerProgressView* progressView;
@property (nonatomic, strong) UIButton* playButton;
@property (nonatomic, strong) NSDateFormatter* formatter;
@property (nonatomic, assign) NSInteger allTime;
@property (nonatomic, strong) NSString* allFormatterTime;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) UIImageView* thumbImage;
@end

@implementation HJMHPlayerView

- (instancetype)initWithVideo:(Video*)video videoTime:(NSInteger)videoTime{
    if (self = [super init]) {
       // self.data=script;
        self.fadeTime = 0.5;
        //初始化播放按钮
//        [self addSubview:self.playButton];
//        [self.playButton makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.center);
//            make.size.equalTo(50);
//        }];
        //初始化预览图
        //[self addSubview:self.thumbImage];
        //初始化进度条
        [self addSubview: self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

-(void)didMoveToSuperview{
    
}

#pragma mark - 方法

- (void)showPlayer{
    self.hidden = NO;
    [self.timer invalidate];
    [UIView animateWithDuration:self.fadeTime animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        //显示三秒后自动隐藏
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoHiddenPlayer) userInfo:nil repeats:NO];
    }];
}

- (void)autoHiddenPlayer{
    self.returnBlock();
    [self hiddenPlayer];
}

- (void)hiddenPlayer{
    [self.timer invalidate];
    [UIView animateWithDuration:self.fadeTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)updateCurrentTime:(CGFloat)currentTime bufferTime:(CGFloat)bufferTime allTime:(NSInteger)allTime{
    
    //更新时间
    self.allTime = allTime;
    self.allFormatterTime = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:allTime]];
    
    //更新进度条
    [self.progressView updateCurrentTime: currentTime / self.allTime];
    [self.progressView updateBufferTime: bufferTime / self.allTime];
}

- (void)updateValue:(handle) block{
    self.returnBlock = block;
}

#pragma mark - 协议
- (void)playButtonTouchDown{
    self.playButton.selected = !self.playButton.isSelected;
    if([self.delegate respondsToSelector:@selector(playerTouchPlayerButton:)]){
        [self.delegate playerTouchPlayerButton: self];
    }
}

#pragma mark - 懒加载

-(UIButton*)playButton{
    if(_playButton==nil){
        _playButton=[[UIButton alloc]init];
        _playButton.tintColor = [UIColor whiteColor];
        UIImage *buttonNorImg = [[UIImage imageNamed:@"asmedia_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *buttonSelImg = [[UIImage imageNamed:@"asmedia_pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_playButton setBackgroundImage:buttonNorImg forState:UIControlStateNormal];
        [_playButton setBackgroundImage:buttonSelImg forState:UIControlStateSelected];
     
        [_playButton addTarget:self action:@selector(playButtonTouchDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (NSDateFormatter *)formatter{
    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"mm:ss"];
    }
    return _formatter;
}

- (HJMHPlayerProgressView *)progressView{
    if(_progressView == nil) {
        _progressView = [[HJMHPlayerProgressView alloc] initWithLineWidth:10 currentTimeColor:[UIColor redColor] bufferTimeColor:[UIColor grayColor] lineBackGroundColor:[UIColor whiteColor] thumbImg:nil];
    }
    return _progressView;
}

@end
