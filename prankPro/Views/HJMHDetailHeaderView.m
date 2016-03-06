//
//  HJMHDetailHeaderView.m
//  prankPro
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHDetailHeaderView.h"

@implementation HJMHDetailHeaderView

-(id)initWithVideo:(Video*)video andFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        //数据
        self.data=video;
        //界面排版
        [self initUI];
        //播放
        [self launch];
        //是否重复,默认是
        self.loop=YES;
    }
    return self;
}

-(void)initUI{
    
    //播放界面框架
    self.playerFrame=[[UIView alloc]init];
    self.playerFrame.backgroundColor=[UIColor blackColor];
    [self addSubview:self.playerFrame];
    [self.playerFrame makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.width.equalTo(self.width);
        make.height.equalTo(self.width);
    }];
    //刷新frame
    [self layoutIfNeeded];
    
    //播放器
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.playerFrame.layer.bounds;
    [self.playerFrame.layer insertSublayer:playerLayer atIndex:0];
    
    //播放管理面板
    [self.playerFrame insertSubview:self.playerView atIndex:1];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //头像
    [self addSubview:self.avatarImage];
    [self.avatarImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerFrame.bottom).offset(5);
        make.left.equalTo(self.left).offset(5);
        make.size.equalTo(60);
    }];
    
    //姓名
    [self addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.top);
        make.left.equalTo(self.avatarImage.right).offset(5);
    }];
    
    //状态
    [self addSubview:self.statusBar];
    [self.statusBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(15);
        make.left.equalTo(self.avatarImage.right).offset(5);
    }];
    
    //分割线
    UIView* seperator=[[UIView alloc]init];
    seperator.backgroundColor=[UIColor grayColor];
    [self addSubview:seperator];
    [seperator makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(1);
    }];
    
    //点赞
    [self addSubview:self.likeBtn];
    [self.likeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerFrame.bottom).offset(10);
        make.right.equalTo(self.right).offset(-15);
        make.size.equalTo(30);
    }];
//    //分享按钮
//    [self addSubview:self.shareBtn];
//    [self.shareBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.playerFrame.bottom).offset(5);
//        make.right.equalTo(self.right).offset(5);
//        make.size.equalTo(50);
//    }];
    
    //AD
//    [self addSubview:self.bannerView];
//    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.bottom);
//        make.left.equalTo(self.left);
//    }];
}

#pragma mark - PlayUIView

- (void)playerTouchPlayerButton:(HJMHPlayerView *)UIView{
    NSLog(@"播放点击");
    self.isUserPause?[self playerPlay]:[self playerPause];
    self.userPause = !self.isUserPause;
}

-(void)handleLikeClick{
    
    [self.likeBtn setEnabled:NO];
    [HJMHUtility likeOrUnLikeInBackground:self.data block:^(BOOL succeeded, NSError *error) {
        self.likeBtn.selected=!self.likeBtn.selected;
        [self.likeBtn setEnabled:YES];
    }];
}

#pragma mark - KVO

/** * 给AVPlayerItem添加监控 *
 * @param playerItem AVPlayerItem对象 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/** * 通过KVO监控播放器状态 *
 * @param keyPath 监控属性
 * @param object 监视器
 * @param change 状态改变
 * @param context 上下文 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

#pragma private method

- (void)launch{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        //没到达缓存时间应该播放
        if ([self isArriveBufferTime] == NO) {
            if (self.isPlayerPlayOnceTime == NO) {
                [MBProgressHUD hideHUDForView:self animated:YES];
                [self playerPlay];
                self.playerPlayOnceTime = YES;
            }
            //更新当前时间
            [self.playerView updateCurrentTime:[self currentSecond] bufferTime:[self allBufferSecond] allTime: [self videoLength]];
        }else{
            [self playerPause];
            self.playerPlayOnceTime = NO;
        } 
        if([self currentSecond]==[self videoLength]){ 
            [self.player seekToTime:CMTimeMake(0, 1)];
            [self.player play];
        }
    } repeats:YES];
}

/*
 *获取当前播放器播放时间
 */
- (NSInteger)currentSecond{
    return CMTimeGetSeconds([self.player currentTime]);
}

/*
 *获取已经缓存秒数
 */
- (NSInteger)currentBufferSecond{
    return CMTimeGetSeconds([self bufferTimeRange].duration);
}

- (NSInteger)allBufferSecond{
    CMTimeRange time = [self bufferTimeRange];
    return CMTimeGetSeconds(time.duration) + CMTimeGetSeconds(time.start);
}

/**
 *  获取总共缓存秒数
 *
 */
- (CMTimeRange)bufferTimeRange{
    return self.player.currentItem.loadedTimeRanges.firstObject.CMTimeRangeValue;
}

//判断是否到达缓存时间
- (BOOL)isArriveBufferTime{
    return [self currentBufferSecond] <= 2;
}

- (int)videoLength{
    return (int)CMTimeGetSeconds(self.player.currentItem.duration);
}

//播放器播放
- (void)playerPlay{
    [self.player play];
}
//播放器暂停
- (void)playerPause{
    [self.player pause];
}
//播放器销毁
-(void)playerDestory{
    [self.timer invalidate];
    [self playerPause];
    //[self removeObserverFromPlayerItem:<#(AVPlayerItem *)#>]
    self.player = nil;
}

#pragma lazy load
-(AVPlayer *)player{
    if(_player==nil) {
        NSURL *sourceMovieURL =[NSURL URLWithString: self.data.url];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    return _player;
}

- (HJMHPlayerView *)playerView{
    if(_playerView == nil) {
        _playerView = [[HJMHPlayerView alloc] initWithVideo:self.data videoTime:[self videoLength]];
        _playerView.delegate = self;
    }
    return _playerView;
}

-(PFImageView*) avatarImage{
    if(_avatarImage==nil){
        _avatarImage=[[PFImageView alloc]init];
        _avatarImage.file=self.data.user[@"avatar"];
        _avatarImage.layer.cornerRadius = 15.0f;
        _avatarImage.layer.masksToBounds = YES;
        [_avatarImage loadInBackground];
    }
    return _avatarImage;
}

-(UILabel*) nameLabel{
    if(_nameLabel==nil){
        self.nameLabel=[[UILabel alloc]init];
        self.nameLabel.text=self.data.user.username;
        self.nameLabel.textColor =kMainTextColor;
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    }
    return _nameLabel;
}

-(HJMHStatusBar*) statusBar{
    if(_statusBar==nil){
        _statusBar=[[HJMHStatusBar alloc]init];
        [_statusBar SetStatusWithPlay:self.data.play_count andLike:self.data.like_count];
    }
    return _statusBar;
}

-(FBSDKShareButton*) shareBtn{
    if(_shareBtn==nil){
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init]; 
        _shareBtn=[[FBSDKShareButton alloc] init];
        _shareBtn.shareContent = content;
    }
    return _shareBtn;
}

-(UIButton*) likeBtn{
    if(_likeBtn==nil){
        _likeBtn=[[UIButton alloc] init];
        UIImage *normalImg = [[UIImage imageNamed:@"like_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_likeBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
        UIImage *pressImg = [[UIImage imageNamed:@"like_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_likeBtn setBackgroundImage:pressImg forState:UIControlStateSelected];
        
        [HJMHUtility isLiked:self.data block:^(BOOL succeeded, NSError *error) {
                [_likeBtn setSelected:succeeded];
        }];
       
        [_likeBtn addTarget:self action:@selector(handleLikeClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _likeBtn;
}

-(GADBannerView*)bannerView{
    if(_bannerView==nil){
        //ad banner
        _bannerView=[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _bannerView.adUnitID = @"ca-app-pub-1232384027425912/8608130189";
        self.bannerView.rootViewController =self;
        GADRequest* request=[GADRequest request]; 
        [self.bannerView loadRequest:request];
    }
    return _bannerView;
}
@end
