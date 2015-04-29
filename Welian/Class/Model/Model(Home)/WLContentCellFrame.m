//
//  WLContentCellFrame.m
//  weLian
//
//  Created by dong on 14/11/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLContentCellFrame.h"
#import "WLStatusM.h"
#import "MLEmojiLabel.h"
#import "WLPhotoListView.h"

@interface WLContentCellFrame()
{
    CGFloat _cellWidth;
    BOOL _showMoreBut;
}
@end

@implementation WLContentCellFrame

- (instancetype)initWithWidth:(CGFloat)width withShowMoreBut:(BOOL)showMoreBut
{
    self = [super init];
    if (self) {
        _cellWidth = width;
        _showMoreBut = showMoreBut;
    }
    return self;
}

- (void)setIsShowMoreBut:(BOOL)isShowMoreBut
{
    _isShowMoreBut = isShowMoreBut;
}

/**
 *  在这个方法中计算所有子控件的frame
 *
 *  @param status 微博数据模型
 */
- (void)setStatus:(WLStatusM *)status
{
    _status = status;
    NSInteger type = status.type.integerValue;
    // 1.内容
    CGFloat contentX = 10;
    CGFloat contentY = 0;
    if (type== 6||type==5||type== 12||type==4) {
        _contentLabelF = CGRectMake(contentX, contentY, 0, 0);
        _photoListViewF = _contentLabelF;
    }else{
        if (status.content.length) {
            MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
            [contLabel setText:status.content];
            contLabel.numberOfLines = 0;
            contLabel.lineBreakMode = NSLineBreakByCharWrapping;
            contLabel.font = WLFONT(15);
            contLabel.enableToLinkUrl = YES;//设置url转成网页链接展示
            
            CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:_cellWidth - IWCellBorderWidth];
            
            _contentLabelF = CGRectMake(contentX, contentY, sizelabel.width, sizelabel.height+5);
            if (_showMoreBut) {
                if (sizelabel.height >= 330-3) {
                    _contentLabelF = CGRectMake(contentX, contentY, sizelabel.width, 230+3);
                    _isShowMoreBut = _showMoreBut;
                    _moreButFrame = CGRectMake(contentX, CGRectGetMaxY(_contentLabelF), 70, 25);
                }else{
                    _isShowMoreBut = NO;
                    _moreButFrame = CGRectMake(contentX, CGRectGetMaxY(_contentLabelF), 0, 0);
                }
            }else{
                   _moreButFrame = CGRectMake(contentX, CGRectGetMaxY(_contentLabelF), 0, 0);
            }
            
        }else{
            _contentLabelF = CGRectMake(contentX, contentY, 0, 0);
            _moreButFrame = _contentLabelF;
        }
        if (status.photos.count) {
            // 4.如果有配图
            CGFloat photoListX = contentX;
            CGFloat photoListY = CGRectGetMaxY(_moreButFrame) + 5;
            
            // 根据图片数量计算相册的尺寸
            CGSize photoListSize = [WLPhotoListView photoListSizeWithCount:status.photos needAutoSize:NO];
            
            _photoListViewF = (CGRect){{photoListX, photoListY}, photoListSize};
        }
    }
    
    // 6.整个cell的高度
    if (status.photos.count) { // 有配图
        _cellHeight = CGRectGetMaxY(_photoListViewF);
    } else { // 只有文字
        _cellHeight = CGRectGetMaxY(_moreButFrame);
    }
    
    // 活动和项目高度
    if (status.card) {
        NSInteger yy = 10;
        if (type== 6||type==5||type== 12||type==4) {
            yy = 0;
        }
        _cellCardF = CGRectMake(contentX, _cellHeight+yy, _cellWidth - IWCellBorderWidth, 56);
        _cellHeight += 56+yy;
    }
    
    if (!(type==4||type==5||type==6||type==12)) {
        CGFloat dockY = _cellHeight+5;
        _dockFrame = CGRectMake(contentX, dockY, _cellWidth - IWCellBorderWidth, IWStatusDockH);
        _cellHeight = CGRectGetMaxY(_dockFrame);
    }else{
        _cellHeight +=5;
    }
    
}


@end
