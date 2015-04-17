//
//  CommentHeadFrame.m
//  weLian
//
//  Created by dong on 14/11/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentHeadFrame.h"

@interface CommentHeadFrame()
{
    CGFloat _cellWidth;
}
@end


@implementation CommentHeadFrame

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        _cellWidth = width;
    }
    return self;
}

- (void)setStatus:(WLStatusM *)status
{
    _status = status;
    _cellHigh = 60;
    _contentFrame = [[WLContentCellFrame alloc] initWithWidth:_cellWidth withShowMoreBut:NO];
    [_contentFrame setStatus:status];
    _cellHigh += _contentFrame.cellHeight;
    
}

@end
