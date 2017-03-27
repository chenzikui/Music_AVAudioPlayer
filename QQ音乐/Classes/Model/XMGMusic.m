//
//  XMGMusic.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGMusic.h"

@implementation XMGMusic

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)musicWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
