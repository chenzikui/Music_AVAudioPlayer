//
//  XMGPlayingViewController.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGPlayingViewController.h"
#import "XMGMusic.h"
#import "XMGMusicTool.h"
#import "XMGAudioTool.h"
#import "NSString+TimeExtension.h"
#import "CALayer+PauseAimate.h"
#import "XMGLrcView.h"
#import "XMGLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define XMGColor(r,g,b,a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a])

@interface XMGPlayingViewController () <UIScrollViewDelegate, AVAudioPlayerDelegate>

/* 歌曲数据 */
@property (nonatomic, strong) NSArray *musics;

@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

// 滑块
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
// 播放暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
// 滚动的视图
@property (weak, nonatomic) IBOutlet XMGLrcView *lrcView;
// 歌词的Label
@property (weak, nonatomic) IBOutlet XMGLrcLabel *lrcLabel;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/* 歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

/* 当前播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

#pragma mark - 监听Slider的事件
- (IBAction)startSlider;
- (IBAction)endSlide;
- (IBAction)sliderValueChange;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;

#pragma mark - 歌曲控制事件
- (IBAction)playOrPause;
- (IBAction)previous;
- (IBAction)next;

- (IBAction)dismissAction;

@end

@implementation XMGPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加毛玻璃效果和歌词的View
    [self setupBlurGlass];
    
    // 2.设置滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.开始播放歌曲
    [self startPlayingMusic];
    
    // 4.设置ScrollView的可滚动区域
    self.lrcView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    self.lrcView.lrcLabel = self.lrcLabel;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 3.设置图片圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.borderWidth = 5;
    self.iconView.layer.borderColor = XMGColor(36, 36, 36, 1.0).CGColor;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setupBlurGlass
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    [self.albumView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *HVFL = @"H:|-0-[toolBar]-0-|";
    NSString *VVFL = @"V:|-0-[toolBar]-0-|";
    NSArray *toolbarHCons = [NSLayoutConstraint constraintsWithVisualFormat:HVFL options:0 metrics:nil views:@{@"toolBar":toolBar}];
    NSArray *toolbarVCons = [NSLayoutConstraint constraintsWithVisualFormat:VVFL options:0 metrics:nil views:@{@"toolBar":toolBar}];
    [self.albumView addConstraints:toolbarHCons];
    [self.albumView addConstraints:toolbarVCons];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 开始播放歌曲
- (void)startPlayingMusic
{
    // 0.获取当前正在播放的歌曲
    XMGMusic *playingMusic = [XMGMusicTool playingMusic];
    
    // 1.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    self.playOrPauseBtn.selected = YES;
    
    // 设置歌词信息
    self.lrcView.lrcName = playingMusic.lrcname;
    
    // 2.开始播放歌曲
    self.currentPlayer = [XMGAudioTool playMusicWithName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:self.currentPlayer.duration];
    self.currentPlayer.delegate = self;
    
    // 3.添加动画
    [self startAnimate];
    
    // 4.添加定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    
    // 5.添加歌词的定时器
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 6.设置锁屏时的信息
    [self setupLockInfo];
}

// 开始动画
- (void)startAnimate
{
    // 1.创建动画
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 2.设置动画的属性
    [rotateAnim setFromValue:@(0)];
    [rotateAnim setFromValue:@(-2 * M_PI)];
    [rotateAnim setRepeatCount:NSIntegerMax];
    [rotateAnim setDuration:40.0];
    [self.iconView.layer addAnimation:rotateAnim forKey:nil];
}

- (void)stopAnimate
{
    [self.iconView.layer removeAllAnimations];
}


#pragma mark 定时器的操作
- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addLrcTimer
{
    [self updateLrc];
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新界面
- (void)updateProgressInfo
{
    // 1.改变当前播放的时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    // 2.修改进度条
    // 2.1.计算当前播放的进度比例
    CGFloat progressRatio = self.currentPlayer.currentTime / self.currentPlayer.duration;
    
    // 2.2.设置进度条的比例
    self.progressSlider.value = progressRatio;
}

- (IBAction)startSlider
{
    [self removeProgressTimer];
}

- (IBAction)endSlide
{
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    [self addProgressTimer];
}

- (IBAction)sliderValueChange {
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    // 1.获取点击的位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.拿到x占据的比例
    CGFloat progress = point.x / self.progressSlider.frame.size.width;
    
    // 3.设置歌曲的进度
    self.currentPlayer.currentTime = progress * self.currentPlayer.duration;
    [self updateProgressInfo];
}

#pragma mark - 更新歌词
- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - 歌曲控制事件
- (IBAction)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    
    if (self.currentPlayer.playing) {
        // 1.歌曲的控制
        [self.currentPlayer pause];
        [self removeProgressTimer];
        
        // 2.动画的控制
        [self.iconView.layer pauseAnimate];
    } else {
        [self.currentPlayer play];
        
        [self addProgressTimer];
        
        // 继续播放动画
        [self.iconView.layer resumeAnimate];
    }
}

- (IBAction)previous {
    XMGMusic *previousMusic = [XMGMusicTool previousMusic];
    [self playMusic:previousMusic];
}

- (IBAction)next {
    XMGMusic *nextMusic = [XMGMusicTool nextMusic];
    [self playMusic:nextMusic];
}

- (IBAction)dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)playMusic:(XMGMusic *)playMusic
{
    // 1.停止当前播放的歌曲
    XMGMusic *playingMusic = [XMGMusicTool playingMusic];
    [XMGAudioTool stopMusicWithName:playingMusic.filename];
    
    // 2.取出下一首歌曲,播放下一首歌曲
    [XMGAudioTool playMusicWithName:playMusic.filename];
    
    // 3.并且将当前播放的歌曲设置成下一首个
    [XMGMusicTool setPlayingMusic:playMusic];
    
    // 4.更改界面
    [self startPlayingMusic];
}

#pragma mark - 实现UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.获取滚动的区域
    CGFloat scrollX = scrollView.contentOffset.x;
    
    // 2.计算滚动的比例
    CGFloat alpha = 1 - scrollX / scrollView.bounds.size.width;
    
    // 3.设置内容的透明度
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}

#pragma mark - 实现AVAudioPlayer的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self next];
    }
}

/*
 // MPMediaItemPropertyAlbumTitle
 // MPMediaItemPropertyAlbumTrackCount
 // MPMediaItemPropertyAlbumTrackNumber
 // MPMediaItemPropertyArtist
 // MPMediaItemPropertyArtwork
 // MPMediaItemPropertyComposer
 // MPMediaItemPropertyDiscCount
 // MPMediaItemPropertyDiscNumber
 // MPMediaItemPropertyGenre
 // MPMediaItemPropertyPersistentID
 // MPMediaItemPropertyPlaybackDuration
 // MPMediaItemPropertyTitle
 */

#pragma mark - 设置锁屏时的信息
- (void)setupLockInfo
{
    // 1.获取播放中心的实例
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置播放中心的信息
    XMGMusic *playingMusic = [XMGMusicTool playingMusic];
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    playingInfo[MPMediaItemPropertyAlbumTitle] = playingMusic.name;
    playingInfo[MPMediaItemPropertyArtist] = playingMusic.singer;
    playingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:playingMusic.icon]];
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.currentPlayer.duration);
    
    playingCenter.nowPlayingInfo = playingInfo;
    
    // 3.开始监听远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 4.让控制器成为第一响应者
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载代码
- (NSArray *)musics
{
    if (_musics == nil) {
        _musics = [XMGMusicTool musics];
    }
    return _musics;
}

@end
