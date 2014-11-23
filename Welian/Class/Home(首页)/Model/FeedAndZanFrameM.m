//
//  FeedAndZanFrameM.m
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FeedAndZanFrameM.h"

@interface FeedAndZanFrameM()
{
    CGFloat _cellWidth;
}
@end

@implementation FeedAndZanFrameM

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
     _cellWidth = width;
        
    }
    return self;
}

- (void)setFeedAndzanDic:(NSDictionary *)feedAndzanDic
{
    _feedAndzanDic = feedAndzanDic;
//    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;

    CGFloat imageX = 10;
    CGFloat imageY = 0;
    _cellHigh = imageY;
    
    UIImage *image = [UIImage imageNamed:@"good_small"];
    _zanImageF = CGRectMake(imageX, 10, image.size.width, image.size.height);
    
    NSArray *feedArray = [feedAndzanDic objectForKey:@"forwards"];
    NSArray *zanArray = [feedAndzanDic objectForKey:@"zans"];
    
    NSDictionary *attrsDictionary = @{NSFontAttributeName:WLZanNameFont};
    
    CGFloat labelW = _cellWidth- CGRectGetMaxX(_zanImageF)-20;
    NSMutableString *zanStrM = [NSMutableString string];
    if (zanArray.count) {
        for (FeedAndZanModel *zanModel  in zanArray) {
            if (zanModel != zanArray.lastObject) {
                
                [zanStrM appendFormat:@"%@，",zanModel.user.name];
            }else{
                [zanStrM appendFormat:@"%@",zanModel.user.name];
            }
        }

        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:zanStrM attributes:attrsDictionary];
        CGFloat zanlabelH = [self textViewHeightForAttributedText:attributedText andWidth:labelW];
        
        _zanLabelF = CGRectMake(CGRectGetMaxX(_zanImageF)+5, imageY, labelW, zanlabelH);
        _zanNameStr = zanStrM;
        _cellHigh = CGRectGetMaxY(_zanLabelF);
    }
    
    NSMutableString *feedStrM = [NSMutableString string];
    if (feedArray.count) {
        _feedImageF = CGRectMake(imageX, _cellHigh, image.size.width, image.size.height);
        
        for (FeedAndZanModel *feedModel in feedArray) {
            if (feedModel != feedArray.lastObject) {
                
                [feedStrM appendFormat:@"%@，",feedModel.user.name];
            }else{
                [feedStrM appendFormat:@"%@",feedModel.user.name];
            }
        }
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:feedStrM attributes:attrsDictionary];
        CGFloat feedlabelH = [self textViewHeightForAttributedText:attributedText andWidth:labelW];
        
        _feedLabelF = CGRectMake(CGRectGetMaxX(_zanImageF)+5, _cellHigh-10, labelW, feedlabelH);
        _feedNameStr = feedStrM;
        _cellHigh = CGRectGetMaxY(_feedLabelF);
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
