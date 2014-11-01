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

@implementation ForwardPublishView

- (void)setStatusF:(WLStatusFrame *)statusF
{
    _statusF = statusF;
    WLStatusM *statusM = statusF.status;
    if (statusM.relationfeed) {
        statusM = statusM.relationfeed;
    }
    [_nameLabel setText:statusM.user.name];
    
    _titelLabel.backgroundColor = [UIColor clearColor];
    _titelLabel.lineBreakMode = NSLineBreakByCharWrapping;
    // 5.2.正文
    _titelLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _titelLabel.customEmojiPlistName = @"expressionImage_custom";
    
    [_titelLabel setText:statusM.content];
    
    WLPhoto *photoM = [statusM.photos firstObject];

//    [_imageView setImage:[UIImage imageNamed:photoM.url]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:photoM.url] placeholderImage:[UIImage imageNamed:@"picture_loading"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
}


@end
