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
        self.HBlabel.font = WLFONT(14);
        [self.HBlabel setLineSpacing:1];
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

    for (NSInteger i = 0; i<commentDataArray.count; i++) {
        CommentMode *commMode = commentDataArray[i];
        NSString *commStr = [NSString stringWithFormat:@"%@: %@",commMode.user.name,commMode.comment];
        if (commMode.touser) {
            commStr = [NSString stringWithFormat:@"%@ 回复 %@: %@",commMode.user.name,commMode.touser.name, commMode.comment];
        }

        CGFloat labelH = [self textViewHeightForAttributedText:commStr andWidth:labelW];
        
        if (i==0) {
            _oneLabelStr = commStr;
            _oneLabelFrame = CGRectMake(labelX, labelY, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_oneLabelFrame);

        }else if (i==1){
            _twoLabelStr = commStr;
            _twoLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_oneLabelFrame)+2, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_twoLabelFrame);
            
        }else if (i==2){
            _threeLabelStr = commStr;
            _threeLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_twoLabelFrame)+2, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_threeLabelFrame);
            
        }else if (i==3){
            _fourLabelStr = commStr;
            _fourLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_threeLabelFrame)+2, labelW, labelH);
            _cellHigh = CGRectGetMaxY(_fourLabelFrame);
        }else if (i==4){
            _fiveLabelStr = commStr;
            _fiveLabelFrame = CGRectMake(labelX, CGRectGetMaxY(_fourLabelFrame)+2, labelW, labelH);
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
    [self.HBlabel setText:nil];
    // 在字符串内前后分别添加]和[，是为了方便找出表情两边的内容
    text = [NSString stringWithFormat:@"]%@[", text];
    // 如有换行，下面的正则表达式无法查出正确的内容（求高手帮忙写个咯），因此先把换行符转义了
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    // 找出表情两边的内容
    NSArray *texts  = [self match:text withRegex:@"(?<=\\]).*?(?=\\[)"];
    
    for (NSUInteger i = 0; i < [texts count]; i++) {
        NSString *s = [texts objectAtIndex:i];
        // 根据上面的转义替换成换行符，这样绘制的时候就能换行了
        s = [s stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [self.HBlabel appendText:s];
        if (i < [texts count] - 1) {
            [self.HBlabel appendImage:[UIImage imageNamed:@"Expression_14"]
                        maxSize:CGSizeMake(20, 20)
                         margin:UIEdgeInsetsZero
                      alignment:M80ImageAlignmentBottom];
        }
    }
    CGSize size = [self.HBlabel sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


- (NSArray *)match:(NSString *)string withRegex:(NSString *)regex {
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
    NSArray *matchResults = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSString *tmpStr = @"";
    NSMutableArray *matchs = [NSMutableArray array];
    for (NSTextCheckingResult *match in matchResults) {
        NSRange matchRange = [match range];
        tmpStr = [string substringWithRange:matchRange];
        [matchs addObject:tmpStr];
    }
    return matchs;
}



@end
