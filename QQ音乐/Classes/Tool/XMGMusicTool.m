//
//  XMGMusicTool.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGMusicTool.h"
#import "XMGMusic.h"

@implementation XMGMusicTool

static NSArray *_musics;
static XMGMusic *_playingMusic;

+ (void)initialize
{
    // 1.读取文件
    NSString *musicsPath = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
    
    // 2.将数据加载到数组中
    NSArray *musics = [NSArray arrayWithContentsOfFile:musicsPath];
    
    // 3.遍历数组,将字典转成模型
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in musics) {
        XMGMusic *music = [XMGMusic musicWithDict:dict];
        [tempArray addObject:music];
    }
    
    _musics = tempArray;
    
    _playingMusic = _musics[2];
}

+ (NSArray *)musics
{
    return _musics;
}

+ (void)setPlayingMusic:(XMGMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (XMGMusic *)playingMusic;
{
    return _playingMusic;
}

+ (XMGMusic *)nextMusic
{
    // 1.获取当前歌曲的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首歌曲的下标值
    NSInteger nextIndex = ++currentIndex;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    
    // 3.获取下一首歌曲
    XMGMusic *nextMusic = _musics[nextIndex];
    
    return nextMusic;
}

+ (XMGMusic *)previousMusic
{
    // 1.获取当前歌曲的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取上一首歌曲的下标值
    NSInteger previousIndex = --currentIndex;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    
    // 3.获取上一首歌曲
    XMGMusic *previousMusic = self.musics[previousIndex];
    
    return previousMusic;
}

@end
