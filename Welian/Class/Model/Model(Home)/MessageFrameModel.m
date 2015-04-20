//
//  MessageFrameModel.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MessageFrameModel.h"
#import "MLEmojiLabel.h"

@implementation MessageFrameModel


- (void)setMessageDataM:(HomeMessage *)messageDataM
{
    _messageDataM = messageDataM;
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    // 头像
    CGFloat iconX = 10;
    CGFloat iconY = 10;
    CGFloat iconW = 40;
    _iconImageF = CGRectMake(iconX, iconY, iconW, iconW);
    
    // 姓名
    CGFloat nameX = CGRectGetMaxX(_iconImageF)+10;
    CGFloat nameY = iconY;
    CGFloat nameW = cellW -nameX-100;
    CGFloat nameH = 22;
    _nameLabelF = CGRectMake(nameX, nameY, nameW, nameH);
    
    // 图片
    CGFloat photW = 70;
    CGFloat photX = cellW - photW -10;
    CGFloat photY = 10;
    _photImageF = CGRectMake(photX, photY, photW, photW);
    
    // 动态内容
    _trendsLabelF = CGRectMake(photX+5, photY+5, photW-10, photW-10);
    
    // 评论内容
    CGFloat commentX = nameX;
    CGFloat commentY = CGRectGetMaxY(_nameLabelF)+5;
    CGFloat commentW = nameW;
    if ([messageDataM.type isEqualToString:@"feedComment"] || [messageDataM.type isEqualToString:@"projectComment"]) {  // 评论
        MLEmojiLabel *contLabel = [[MLEmojiLabel alloc] init];
        [contLabel setText:messageDataM.msg];
        contLabel.numberOfLines = 0;
        contLabel.lineBreakMode = NSLineBreakByCharWrapping;
        contLabel.font = kNormal16Font;
        
        CGSize sizelabel = [contLabel preferredSizeWithMaxWidth:commentW];
        
        _commentLabelF = CGRectMake(commentX, commentY, sizelabel.width, sizelabel.height+5);
        
        _cellHigh = CGRectGetMaxY(_commentLabelF);
    }else { // 赞 // 转发
        _zanfeedImageF = CGRectMake(commentX, commentY, 30, 28);
        _cellHigh = CGRectGetMaxY(_zanfeedImageF);
    }
    
    // 时间
    CGFloat timeX = nameX;
    CGFloat timeY = _cellHigh;
    CGFloat timeW = nameW;
    _timeLabelF = CGRectMake(timeX, timeY, timeW, 20);
    
    _cellHigh = CGRectGetMaxY(_timeLabelF)+5;
    
}



@end
