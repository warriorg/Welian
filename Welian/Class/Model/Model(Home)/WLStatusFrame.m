//
//  WLStatusFrame.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusFrame.h"
#import "WLStatusM.h"


@interface WLStatusFrame()
{
    CGFloat _cellWidth;
}
@end


@implementation WLStatusFrame

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        _cellWidth = width;
    }
    return self;
}

/**
 *  在这个方法中计算所有子控件的frame
 *
 *  @param status 微博数据模型
 */
- (void)setStatus:(WLStatusM *)status
{
    _status = status;
    _cellHigh = 60;
    //0 正常动态，1 转推的动态，2推荐的动态，3创建的活动，4 修改个人公司，5 参加的活动，6 修改学校资料，10创建项目，11 网页, 12点评项目
    if (status.type.integerValue==1||status.type.integerValue==2||status.type.integerValue==6||status.type.integerValue==4) {
        _cellHigh = 90;
    }
    _contentFrame = [[WLContentCellFrame alloc] initWithWidth:_cellWidth withShowMoreBut:YES];
    [_contentFrame setStatus:status];
    _cellHigh += _contentFrame.cellHeight;
    
    NSMutableDictionary *daafa = [NSMutableDictionary dictionary];
    if (status.zans.count) {
        [daafa setObject:status.zans forKey:@"zans"];
    }
    
    if (status.forwards.count) {
        [daafa setObject:status.forwards forKey:@"forwards"];
    }
    NSInteger high = 8;
    if (status.zans.count||status.forwards.count) {
        _feedAndZanFM = [[FeedAndZanFrameM alloc] initWithWidth:_cellWidth];
        [_feedAndZanFM setFeedAndzanDic:daafa];
        _cellHigh += _feedAndZanFM.cellHigh;
        high -= 5;
    }
    
    if (status.comments.count) {
        _commentListFrame = [[CommentHomeViewFrame alloc] initWithWidth:_cellWidth];
        [_commentListFrame setStatusM:status];
        _cellHigh += _commentListFrame.cellHigh+high;
    }
    
}



@end
