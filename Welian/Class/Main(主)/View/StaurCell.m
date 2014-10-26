//
//  StaurCell.m
//  weLian
//
//  Created by dong on 14/10/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "StaurCell.h"
#import "UIImageView+WebCache.h"
#import "WLPhoto.h"

@implementation StaurCell

- (void)setStatusM:(WLStatusM *)statusM
{
    _statusM = statusM;
    if (statusM.photos.count) {
        NSInteger i = 0;
        for (WLPhoto *photo in statusM.photos) {
            NSString *urlStr = photo.url;
            if (i==0) {
                [_oneImage setHidden:NO];
                [_oneImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            }else if(i==1){
                [_twoImage setHidden:NO];
                [_twoImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            }else if (i==2){
                [_threeImage setHidden:NO];
                [_threeImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            }
            i++;
            if (i==2) {
                break;
            }
        }
        
        
        [_contentLabel setHidden:YES];
        
    }else{
        [_oneImage setHidden:YES];
        [_twoImage setHidden:YES];
        [_threeImage setHidden:YES];
        [_contentLabel setHidden:NO];
        [_contentLabel setText:statusM.content];
    }
}

@end
