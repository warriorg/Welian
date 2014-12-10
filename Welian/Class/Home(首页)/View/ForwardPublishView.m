//
//  ForwardPublishView.m
//  weLian
//
//  Created by dong on 14-10-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ForwardPublishView.h"
#import "WLStatusM.h"
#import "WLBasicTrends.h"
#import "UIImageView+WebCache.h"
#import "WLPhoto.h"

@interface ForwardPublishView ()
{

    UIImageView *_imageView;

    MLEmojiLabel *_titelLabel;
    
    UILabel *_nameLabel;
}



@end

@implementation ForwardPublishView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _titelLabel = [[MLEmojiLabel alloc] init];
        [self addSubview:_titelLabel];
        
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setStatus:(WLStatusM *)status
{
    
    
    WLStatusM *statusM = status;
//    if (statusM.relationfeed) {
//        statusM = statusM.relationfeed;
//    }

    
    WLPhoto *photoM = [statusM.photos firstObject];
    
    CGFloat labelX = 15;
    CGFloat labelW = self.frame.size.width-30;
    if (photoM) {
        [_imageView setFrame:CGRectMake(10, 0, self.frame.size.height, self.frame.size.height)];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:photoM.url] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority];
        labelX += self.frame.size.height+10;
        labelW -= self.frame.size.height;
    }else{
        [_imageView setHidden:YES];
    }

    [_nameLabel setFrame:CGRectMake(labelX, 5, labelW, 20)];
    [_nameLabel setText:statusM.user.name];
    
    [_titelLabel setFrame:CGRectMake(labelX, CGRectGetMaxY(_nameLabel.frame), labelW, 30)];
    _titelLabel.backgroundColor = [UIColor clearColor];
    _titelLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_titelLabel setTextColor:[UIColor darkGrayColor]];
    // 5.2.正文
    _titelLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _titelLabel.customEmojiPlistName = @"expressionImage_custom";
    
    [_titelLabel setText:statusM.content];
    
}


@end
