//
//  XMGAudioTool.h
//  02-音效的播放
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface XMGAudioTool : NSObject

+ (void)playSoundWithName:(NSString *)soundName;

+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;

+ (void)pauseMusicWithName:(NSString *)musicName;

+ (void)stopMusicWithName:(NSString *)musicName;

@end
