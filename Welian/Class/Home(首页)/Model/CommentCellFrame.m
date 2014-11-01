//
//  CommentCellFrame.m
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentCellFrame.h"

@implementation CommentCellFrame

- (void)setCommentM:(CommentMode *)commentM
{
    _commentM = commentM;
    
    // 0.cell的宽度
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 1.头像
    CGFloat iconX = IWCellBorderWidth;
    CGFloat iconY = IWCellBorderWidth;
    
    //    CGSize iconSize = [IWIconView iconSizeWithIconType:IWIconTypeSmall];;
    _iconViewF = (CGRect){{iconX, iconY}, CGSizeMake(IWIconWHSmall, IWIconWHSmall)};
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + IWCellBorderWidth;
    CGFloat nameY = iconY;
    CGSize nameSize = [commentM.user.name sizeWithFont:IWNameFont];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    // 7.时间
    CGFloat timeX = CGRectGetMaxX(_nameLabelF)+IWCellBorderWidth;
    CGFloat timeY = iconY;
    CGSize timeSize = [commentM.created sizeWithFont:IWTimeFont];
    _timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    // 3.内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_nameLabelF) + IWCellBorderWidth;
    CGSize contentSize = [commentM.comment sizeWithFont:IWContentFont constrainedToSize:CGSizeMake(cellWidth - 2 * IWCellBorderWidth-nameX, MAXFLOAT)];
    _contentLabelF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height+5);
    
    if (CGRectGetMaxY(_contentLabelF)<CGRectGetMaxY(_iconViewF)) {
        _cellHeight = CGRectGetMaxY(_iconViewF)+IWCellBorderWidth;
    }else{
        _cellHeight = CGRectGetMaxY(_contentLabelF)+IWCellBorderWidth;
    }
    
}

@end
