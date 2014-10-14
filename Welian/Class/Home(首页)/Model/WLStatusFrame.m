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


@implementation WLStatusFrame

/**
 *  在这个方法中计算所有子控件的frame
 *
 *  @param status 微博数据模型
 */
- (void)setStatus:(WLStatusM *)status
{
    _status = status;
    WLBasicTrends *user = status.user;
    // 0.cell的宽度
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 1.头像
    CGFloat iconX = IWCellBorderWidth;
    CGFloat iconY = IWCellBorderWidth+10;
    
//    CGSize iconSize = [IWIconView iconSizeWithIconType:IWIconTypeSmall];;
    _iconViewF = (CGRect){{iconX, iconY}, CGSizeMake(IWIconWHSmall, IWIconWHSmall)};
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + IWCellBorderWidth;
    CGFloat nameY = iconY;
    CGSize nameSize = [status.user.name sizeWithFont:IWNameFont];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    // 7.时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_nameLabelF) + IWCellBorderWidth * 0.5;
    CGSize timeSize = [status.created sizeWithFont:IWTimeFont];
    _timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    
    //    // 朋友关系图片
    CGFloat mbW = 0;
    if(user.friendship == WLRelationTypeFriend){ // 朋友
        mbW = WLFriendW;
        
    }else if (user.friendship == WLRelationTypeFriendsFriend){
        mbW = WLFriendsFriend;
    }
    CGFloat mbX = cellWidth - mbW-10;
    CGFloat mbY = iconY;
    _mbViewF = CGRectMake(mbX, mbY, mbW, 17);

    
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(_iconViewF) + IWCellBorderWidth;
    if (status.content) {
        // 3.内容
        CGSize contentSize = [status.content sizeWithFont:IWContentFont constrainedToSize:CGSizeMake(cellWidth - 2 * IWCellBorderWidth, MAXFLOAT)];
        _contentLabelF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    }else {
        _contentLabelF = CGRectMake(contentX, contentY, 0, 0);
    }
    
    WLStatusM *retweetStatus = status.relationfeed;
    if (status.photos.count) {
        // 4.如果有配图
        CGFloat photoListX = contentX;
        CGFloat photoListY = CGRectGetMaxY(_contentLabelF) + IWCellBorderWidth;
        
        // 根据图片数量计算相册的尺寸
        CGSize photoListSize = [WLPhotoListView photoListSizeWithCount:status.photos.count];
        
        _photoListViewF = (CGRect){{photoListX, photoListY}, photoListSize};
    } else if (retweetStatus) {
        // 5.如果有转发微博
        CGFloat retweetX = contentX;
        CGFloat retweetY = CGRectGetMaxY(_contentLabelF) + IWCellBorderWidth;
        CGFloat retweetWidth = cellWidth;
        CGFloat retweetHeight = 0;
        
        // 5.1.昵称
        CGFloat retweetNameX = IWCellBorderWidth;
        CGFloat retweetNameY = IWCellBorderWidth;
        CGSize retweetNameSize = [[NSString stringWithFormat:@"@%@", retweetStatus.user.name] sizeWithFont:IWRetweetNameFont];
        _retweetNameLabelF = (CGRect){{retweetNameX, retweetNameY}, retweetNameSize};
        
        // 5.2.内容
        CGFloat retweetContentX = retweetNameX;
        CGFloat retweetContentY = CGRectGetMaxY(_retweetNameLabelF) + IWCellBorderWidth;
        
        CGSize retweetContentSize = [retweetStatus.content sizeWithFont:IWRetweetContentFont constrainedToSize:CGSizeMake(retweetWidth - 2 * IWCellBorderWidth, MAXFLOAT)];
        _retweetContentLabelF = CGRectMake(retweetContentX, retweetContentY, retweetContentSize.width, retweetContentSize.height + 20);
        
        // 5.3.如果有配图
        if (retweetStatus.photos.count) {
            CGFloat retweetPhotoListX = retweetContentX;
            CGFloat retweetPhotoListY = CGRectGetMaxY(_retweetContentLabelF) + IWCellBorderWidth;
            
            // 根据图片数量计算相册的尺寸
            CGSize retweetPhotoListSize = [WLPhotoListView photoListSizeWithCount:retweetStatus.photos.count];
            
            _retweetPhotoListViewF = (CGRect){{retweetPhotoListX, retweetPhotoListY}, retweetPhotoListSize};
            
            retweetHeight = CGRectGetMaxY(_retweetPhotoListViewF);
        } else {
            retweetHeight = CGRectGetMaxY(_retweetContentLabelF);
        }
        retweetHeight += IWCellBorderWidth;
        
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
    _dockY = _cellHeight+IWCellBorderWidth;
    _cellHeight += IWCellBorderWidth + IWCellBorderWidth + IWStatusDockH;
    
}



@end
