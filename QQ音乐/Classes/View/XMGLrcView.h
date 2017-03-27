//
//  XMGLrcView.h
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGLrcLabel;

@interface XMGLrcView : UIScrollView

@property (nonatomic, copy) NSString *lrcName;

@property (nonatomic, assign) NSTimeInterval currentTime;

@property (weak, nonatomic)  XMGLrcLabel *lrcLabel;

@end
