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
#import "MLEmojiLabel.h"

@interface CommentHomeViewFrame ()
{
    CGFloat _cellWidth;
}

@property (nonatomic, strong) MLEmojiLabel *HBlabel;
@end

@implementation CommentHomeViewFrame

- (MLEmojiLabel *)HBlabel
{
    if (_HBlabel == nil) {
        _HBlabel = [[MLEmojiLabel alloc] init];
        _HBlabel.font = WLFONT(14);
        [_HBlabel setLineSpacing:1];
    }
    return _HBlabel;
}

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
    
    NSArray * commentDataArray = statusM.comments;
    CGFloat labelX = 5;
    CGFloat labelY =5;
    CGFloat labelW = _cellWidth - 20;
    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        [self.HBlabel setText:commMode.commentAndName];
        CGFloat labelH = [self.HBlabel preferredSizeWithMaxWidth:labelW].height;
        
        if (i==0) {
            _oneLabelFrame = CGRectMake(labelX, labelY, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_oneLabelFrame);

        }else if (i==1){
            _twoLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_oneLabelFrame)+4, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_twoLabelFrame);
            
        }else if (i==2){
            _threeLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_twoLabelFrame)+4, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_threeLabelFrame);
            
        }else if (i==3){
            _fourLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_threeLabelFrame)+4, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fourLabelFrame);
        }else if (i==4){
            _fiveLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fourLabelFrame)+4, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fiveLabelFrame);
        }
    }
    if (statusM.commentcount.integerValue>5) {
        _moreLabelStr = [NSString stringWithFormat:@"查看全部%ld条评论",(long)statusM.commentcount.integerValue];
        _moreLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fiveLabelFrame)+4, labelW, 20);
        _cellHigh = CGRectGetMaxY(_moreLabelFrame);
    }
    _cellHigh += 5;
}


@end
