//
//  XMGLrcCell.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLrcCell.h"
#import "XMGLrcLabel.h"

@implementation XMGLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        XMGLrcLabel *lrcLabel = [[XMGLrcLabel alloc] init];
        lrcLabel.font = [UIFont systemFontOfSize:14.0];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        self.lrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *labelHCon = [NSLayoutConstraint constraintWithItem:lrcLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *labelVCon = [NSLayoutConstraint constraintWithItem:lrcLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:labelHCon];
        [self addConstraint:labelVCon];
    }
    return self;
}

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LrcCell";
    XMGLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XMGLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    return cell;
}

@end
