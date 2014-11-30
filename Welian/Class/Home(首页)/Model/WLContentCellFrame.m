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
}
@end

@implementation WLContentCellFrame

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
    
    // 1.内容
    CGFloat contentX = 10;
    CGFloat contentY = 0;
    if (status.content.length) {
        MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
        [contLabel setText:status.content];
        contLabel.numberOfLines = 0;
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.font = IWContentFont;
        
        CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:_cellWidth - IWCellBorderWidth];
        if (sizelabel.height>140) {
            
        }
        _contentLabelF = CGRectMake(contentX, contentY, sizelabel.width, sizelabel.height+5);
        
    }else {
        _contentLabelF = CGRectMake(contentX, contentY, 0, 0);
    }
    
    WLStatusM *retweetStatus = status.relationfeed;
    if (status.photos.count) {
        // 4.如果有配图
        CGFloat photoListX = contentX;
        CGFloat photoListY = CGRectGetMaxY(_contentLabelF) + 5;
        
        // 根据图片数量计算相册的尺寸
        CGSize photoListSize = [WLPhotoListView photoListSizeWithCount:status.photos.count];
        
        _photoListViewF = (CGRect){{photoListX, photoListY}, photoListSize};
    } else if (retweetStatus) {
        // 5.如果有转发微博
        CGFloat retweetX = contentX;
        CGFloat retweetY = CGRectGetMaxY(_contentLabelF) + 5;
        CGFloat retweetWidth = _cellWidth-IWCellBorderWidth;
        CGFloat retweetHeight = 0;
        
        // 5.1.昵称
        CGFloat retweetNameX = IWCellBorderWidth;
        CGSize retweetNameSize = [[NSString stringWithFormat:@"该动态最早由%@发布发布发布发布", retweetStatus.user.name] sizeWithFont:IWRetweetNameFont];
        _retweetNameLabelF = (CGRect){{retweetNameX, 5}, retweetNameSize};
        
        // 5.2.内容
        CGFloat retweetContentX = retweetNameX;
        CGFloat retweetContentY = CGRectGetMaxY(_retweetNameLabelF) + 5;
        
        if (retweetStatus.content.length) {
            
            MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
            [contLabel setText:retweetStatus.content];
            contLabel.numberOfLines = 0;
            contLabel.lineBreakMode = NSLineBreakByCharWrapping;
            contLabel.font = IWContentFont;
            
            CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:_cellWidth - 3 * IWCellBorderWidth];
            
            _retweetContentLabelF = CGRectMake(retweetContentX, retweetContentY, sizelabel.width, sizelabel.height+5);
        }else{
            _retweetContentLabelF = CGRectMake(retweetContentX, CGRectGetMaxY(_retweetNameLabelF), 0,0);
        }
        
        // 5.3.如果有配图
        if (retweetStatus.photos.count) {
            CGFloat retweetPhotoListX = retweetContentX;
            CGFloat retweetPhotoListY = CGRectGetMaxY(_retweetContentLabelF) + 5;
            
            // 根据图片数量计算相册的尺寸
            CGSize retweetPhotoListSize = [WLPhotoListView photoListSizeWithCount:retweetStatus.photos.count];
            
            _retweetPhotoListViewF = (CGRect){{retweetPhotoListX, retweetPhotoListY}, retweetPhotoListSize};
            
            retweetHeight = CGRectGetMaxY(_retweetPhotoListViewF);
        } else {
            retweetHeight = CGRectGetMaxY(_retweetContentLabelF);
        }
        retweetHeight += 5;
        
        // 5.4.整体
        _retweetViewF = CGRectMake(retweetX, retweetY, retweetWidth, retweetHeight);
    }
    
    // 6.整个cell的高度
    if (retweetStatus) { // 有转发微博
        _cellHeight = CGRectGetMaxY(_retweetViewF);
    } else if (status.photos.count) { // 有配图
        _cellHeight = CGRectGetMaxY(_photoListViewF);
    } else { // 只有文字
        _cellHeight = CGRectGetMaxY(_contentLabelF);
    }

    CGFloat dockY = _cellHeight+5;
    _dockFrame = CGRectMake(contentX, dockY, _cellWidth - IWCellBorderWidth, IWStatusDockH);
    _cellHeight = CGRectGetMaxY(_dockFrame);
    
}


@end
