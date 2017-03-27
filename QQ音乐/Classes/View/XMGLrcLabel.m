//
//  XMGLrcLabel.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLrcLabel.h"

@implementation XMGLrcLabel

- (void)setLrcProgress:(CGFloat)lrcProgress
{
    _lrcProgress = lrcProgress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect = CGRectMake(0, 0, self.bounds.size.width * self.lrcProgress, self.bounds.size.height);
    [[UIColor greenColor] set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}

@end
