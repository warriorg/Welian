//
//  CommentCellFrame.m
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentCellFrame.h"
#import "MLEmojiLabel.h"

@implementation CommentCellFrame

- (void)setCommentM:(CommentMode *)commentM
{
    _commentM = commentM;
    
    // 0.cell的宽度
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 1.头像
    CGFloat iconX = IWCellBorderWidth;
    CGFloat iconY = IWCellBorderWidth;
    
    _iconViewF = (CGRect){{iconX, iconY}, CGSizeMake(35, 35)};
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + IWCellBorderWidth;
    CGFloat nameY = iconY;
    CGSize nameSize = [commentM.user.name sizeWithFont:IWNameFont];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    // 7.时间
    CGFloat timeX = CGRectGetMaxX(_nameLabelF)+IWCellBorderWidth;
    CGFloat timeY = iconY;
    CGSize timeSize = CGSizeMake(80, 15);
    _timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    
    // 3.内容
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_nameLabelF) + IWCellBorderWidth;
    MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
    NSString *labelstr = commentM.comment;
    if (commentM.touser) {
        labelstr = [NSString stringWithFormat:@"回复 %@：%@",commentM.touser.name,commentM.comment];
    }
    [contLabel setText:labelstr];
    contLabel.numberOfLines = 0;
    contLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contLabel.font = WLFONT(14);
    
    CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:cellWidth - IWCellBorderWidth-contentX];
    _contentLabelF = CGRectMake(contentX, contentY, sizelabel.width, sizelabel.height+5);
    
    if (CGRectGetMaxY(_contentLabelF)<CGRectGetMaxY(_iconViewF)) {
        _cellHeight = CGRectGetMaxY(_iconViewF)+IWCellBorderWidth;
    }else{
        _cellHeight = CGRectGetMaxY(_contentLabelF)+IWCellBorderWidth;
    }
    
}

@end
