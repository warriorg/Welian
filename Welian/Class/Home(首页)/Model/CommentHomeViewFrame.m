//
//  CommentHomeViewFrame.m
//  weLian
//
//  Created by dong on 14/11/23.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentHomeViewFrame.h"
#import "CommentMode.h"
#import "WLStatusM.h"

@interface CommentHomeViewFrame ()
{
    CGFloat _cellWidth;
}
@end

@implementation CommentHomeViewFrame

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        _cellWidth = width;
    }
    return self;
}

- (void)setStatusM:(WLStatusM *)statusM
{
    _statusM = statusM;
    
    NSArray * commentDataArray = statusM.commentsArray;
    CGFloat labelX = 5;
    CGFloat labelY =0;
    CGFloat labelW = _cellWidth - 20;
    NSDictionary *attrsDictionary = @{NSFontAttributeName:WLZanNameFont};

    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        NSString *commStr = [NSString stringWithFormat:@"%@: %@",commMode.user.name,commMode.comment];
        if (commMode.touser) {
            commStr = [NSString stringWithFormat:@"%@ 回复 %@: %@",commMode.user.name,commMode.touser.name, commMode.comment];
        }
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:commStr attributes:attrsDictionary];
        CGFloat labelH = [self textViewHeightForAttributedText:attributedText andWidth:labelW];
        
        if (i==0) {
            _oneLabelStr = commStr;
            
            _oneLabelFrame = CGRectMake(labelX, labelY, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_oneLabelFrame);

        }else if (i==1){
            _twoLabelStr = commStr;
            _twoLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_oneLabelFrame)-10, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_twoLabelFrame);
            
        }else if (i==2){
            _threeLabelStr = commStr;
            _threeLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_twoLabelFrame)-10, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_threeLabelFrame);
            
        }else if (i==3){
            _fourLabelStr = commStr;
            _fourLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_threeLabelFrame)-10, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fourLabelFrame);
        }else if (i==4){
            _fiveLabelStr = commStr;
            _fiveLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fourLabelFrame)-10, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fiveLabelFrame);
        }
    }
    if (statusM.commentcount>5) {
        _moreLabelStr = [NSString stringWithFormat:@"查看全部%d条评论",statusM.commentcount];
        _moreLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fiveLabelFrame)-10, labelW, 35);
        _cellHigh = CGRectGetMaxY(_moreLabelFrame);
    }
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


@end
