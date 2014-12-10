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
#import "M80AttributedLabel.h"

@interface CommentHomeViewFrame ()
{
    CGFloat _cellWidth;
}

@property (nonatomic, strong) M80AttributedLabel *HBlabel;
@end

@implementation CommentHomeViewFrame

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.HBlabel = [[M80AttributedLabel alloc] init];
        self.HBlabel.font = WLFONT(13);
        _cellWidth = width;
    }
    return self;
}

- (void)setStatusM:(WLStatusM *)statusM
{
    _statusM = statusM;
    
    NSArray * commentDataArray = statusM.commentsArray;
    CGFloat labelX = 5;
    CGFloat labelY =5;
    CGFloat labelW = _cellWidth - 20;
//    NSDictionary *attrsDictionary = @{NSFontAttributeName:WLZanNameFont};

    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        NSString *commStr = [NSString stringWithFormat:@"%@: %@",commMode.user.name,commMode.comment];
        if (commMode.touser) {
            commStr = [NSString stringWithFormat:@"%@ 回复 %@: %@",commMode.user.name,commMode.touser.name, commMode.comment];
        }
        
//        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:commStr attributes:attrsDictionary];
        CGFloat labelH = [self textViewHeightForAttributedText:commStr andWidth:labelW];
        
        if (i==0) {
            _oneLabelStr = commStr;
            
            _oneLabelFrame = CGRectMake(labelX, labelY, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_oneLabelFrame);

        }else if (i==1){
            _twoLabelStr = commStr;
            _twoLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_oneLabelFrame), labelW, labelH);
            _cellHigh = CGRectGetMaxY(_twoLabelFrame);
            
        }else if (i==2){
            _threeLabelStr = commStr;
            _threeLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_twoLabelFrame), labelW, labelH);
            _cellHigh = CGRectGetMaxY(_threeLabelFrame);
            
        }else if (i==3){
            _fourLabelStr = commStr;
            _fourLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_threeLabelFrame), labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fourLabelFrame);
        }else if (i==4){
            _fiveLabelStr = commStr;
            _fiveLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fourLabelFrame), labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fiveLabelFrame);
        }
    }
    if (statusM.commentcount>5) {
        _moreLabelStr = [NSString stringWithFormat:@"查看全部%d条评论",statusM.commentcount];
        _moreLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fiveLabelFrame), labelW, 20);
        _cellHigh = CGRectGetMaxY(_moreLabelFrame);
    }
    _cellHigh += 5;
}

- (CGFloat)textViewHeightForAttributedText:(NSString *)text andWidth:(CGFloat)width
{
    [self.HBlabel setText:text];
    CGSize size = [self.HBlabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


@end
