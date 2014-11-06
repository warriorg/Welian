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
    
    // 投资图标
    CGFloat inverX = CGRectGetMaxX(_nameLabelF)+5;
    CGFloat inverY = nameY;
    _inversImageF = CGRectMake(inverX, inverY, 20, 20);
    
    // 7.时间
    CGFloat timeX = CGRectGetMaxX(_nameLabelF)+5;
    if (user.investorauth==WLVerifiedTypeInvestor) {
        timeX = CGRectGetMaxX(_inversImageF)+5;
    }
    
    CGFloat timeY = nameY+2;
    CGSize timeSize = [status.created sizeWithFont:IWTimeFont];
    _timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    CGFloat jobX = nameX;
    CGFloat jobY = CGRectGetMaxY(_nameLabelF);
    _jobLabelF = CGRectMake(jobX, jobY, cellWidth-jobX-IWCellBorderWidth, 22);
    
    
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

    // 3.内容
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(_iconViewF) + IWCellBorderWidth;
    if (status.content.length) {
        MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
        [contLabel setText:status.content];
        contLabel.numberOfLines = 0;
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.font = IWContentFont;
        
        CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:cellWidth - 2 * IWCellBorderWidth];
        
//        CGSize contentSize = [status.content sizeWithFont:IWContentFont constrainedToSize:CGSizeMake(cellWidth - 2 * IWCellBorderWidth, MAXFLOAT)];
        _contentLabelF = CGRectMake(contentX, contentY, sizelabel.width, sizelabel.height+5);
    }else {
        _contentLabelF = CGRectMake(contentX, CGRectGetMaxY(_iconViewF), 0, 0);
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
        CGSize retweetNameSize = [[NSString stringWithFormat:@"该动态最早由%@发布发布发布发布", retweetStatus.user.name] sizeWithFont:IWRetweetNameFont];
        _retweetNameLabelF = (CGRect){{retweetNameX, 5}, retweetNameSize};
        
        // 5.2.内容
        CGFloat retweetContentX = retweetNameX;
        CGFloat retweetContentY = CGRectGetMaxY(_retweetNameLabelF) + IWCellBorderWidth;
        
//        CGSize retweetContentSize = [retweetStatus.content sizeWithFont:IWRetweetContentFont constrainedToSize:CGSizeMake(retweetWidth - 2 * IWCellBorderWidth, MAXFLOAT)];
        if (retweetStatus.content.length) {
            
            MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
            [contLabel setText:retweetStatus.content];
            contLabel.numberOfLines = 0;
            contLabel.lineBreakMode = NSLineBreakByCharWrapping;
            contLabel.font = IWContentFont;
            
            CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:cellWidth - 2 * IWCellBorderWidth];
            
            _retweetContentLabelF = CGRectMake(retweetContentX, retweetContentY, sizelabel.width, sizelabel.height+5);
        }else{
            _retweetContentLabelF = CGRectMake(retweetContentX, CGRectGetMaxY(_retweetNameLabelF), 0,0);
        }
        
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
        _retweetViewF = CGRectMake(0, retweetY, retweetWidth, retweetHeight);
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
    _cellHeight += IWCellBorderWidth + IWStatusDockH;
    
}



@end
