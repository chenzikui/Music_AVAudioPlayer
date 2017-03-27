//
//  XMGMusicTool.h
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMGMusic;

@interface XMGMusicTool : NSObject

// 获取所有的音乐数据
+ (NSArray *)musics;

+ (void)setPlayingMusic:(XMGMusic *)playingMusic;

+ (XMGMusic *)playingMusic;

+ (XMGMusic *)nextMusic;

+ (XMGMusic *)previousMusic;

@end
