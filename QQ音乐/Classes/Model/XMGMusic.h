//
//  XMGMusic.h
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGMusic : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *lrcname;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *singerIcon;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)musicWithDict:(NSDictionary *)dict;

@end
