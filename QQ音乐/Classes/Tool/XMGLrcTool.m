//
//  XMGLrcTool.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLrcTool.h"
#import "XMGLrcline.h"

@implementation XMGLrcTool

+ (NSArray *)lrcToolWithLrcname:(NSString *)lrcname
{
    // 1.取出歌词的字符串
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    
    // 2.将歌词文件转化成模型数据
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger count = lrcArray.count;
    for (int i = 0; i < count; i++) {
        // 2.1.取出当前行的歌词
        NSString *lrclineString = lrcArray[i];
        
        // 2.2.过滤掉不需要行的歌词
        if ([lrclineString hasPrefix:@"[ti:"] || [lrclineString hasPrefix:@"[ar:"] || [lrclineString hasPrefix:@"[al:"]|| ![lrclineString hasPrefix:@"["]) {
            continue;
        }
        
        // 2.3.将歌词转成模型
        XMGLrcline *lrcline = [[XMGLrcline alloc] init];
        
        // [00:00.74]I want it that way
        NSArray *lrclineArray = [lrclineString componentsSeparatedByString:@"]"];
        lrcline.text = lrclineArray[1];
        lrcline.time = [self timeWithString:[lrclineArray[0] substringFromIndex:1]];
        
        // 2.4.将解析好的歌词加入到数组中
        [tempArray addObject:lrcline];
    }
    
    return tempArray;
    
    return nil;
}

// 00:00.74
+ (NSTimeInterval)timeWithString:(NSString *)timeString
{
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger second = [[[timeString componentsSeparatedByString:@"."][0] componentsSeparatedByString:@":"][1] integerValue];
    NSInteger haomiao = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return min * 60 + second + haomiao * 0.01;
}

@end
