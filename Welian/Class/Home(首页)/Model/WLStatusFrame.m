//
//  WLStatusFrame.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "WLBasicTrends.h"
#import "WLPhotoListView.h"
#import "NSString+val.h"
#import "MLEmojiLabel.h"

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
    _contentFrame = [[WLContentCellFrame alloc] initWithWidth:_cellWidth];
    [_contentFrame setStatus:status];
    _cellHigh += _contentFrame.cellHeight;
    
    NSMutableDictionary *daafa = [NSMutableDictionary dictionary];
    if (status.zansArray.count) {
        [daafa setObject:status.zansArray forKey:@"zans"];
    }
    if (status.forwardsArray.count) {
        [daafa setObject:status.forwardsArray forKey:@"forwards"];
    }
    if (status.zansArray.count||status.forwardsArray.count) {
        _feedAndZanFM = [[FeedAndZanFrameM alloc] initWithWidth:_cellWidth];
        [_feedAndZanFM setFeedAndzanDic:daafa];
        _cellHigh += _feedAndZanFM.cellHigh;
    }
    
    if (status.commentsArray.count) {
        _commentListFrame = [[CommentHomeViewFrame alloc] initWithWidth:_cellWidth];
        [_commentListFrame setStatusM:status];
        _cellHigh += _commentListFrame.cellHigh;
    }
    
}



@end
