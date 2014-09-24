//
//  WLPhotoView.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLPhotoView.h"
#import "WLPhoto.h"
#import "UIImageView+WebCache.h"


@interface WLPhotoView ()
{
    UIImageView *_gifView;
}
@end

@implementation WLPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加gif标识(位置、尺寸)
        _gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        
        CGRect gifFrame = _gifView.frame;
        gifFrame.origin.x = self.frame.size.width - gifFrame.size.width;
        gifFrame.origin.y = self.frame.size.height - gifFrame.size.height;
        _gifView.frame = gifFrame;
        
        // 保持在父控件的右下角（左边和上边的距离需要自动拉伸）
        // 子控件要保持显示在父控件的某个角落，就可以用autoresizingMask
        _gifView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:_gifView];
    }
    return self;
}


- (void)setPhoto:(WLPhoto *)photo
{
    _photo = photo;
    
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    
    // 2.gif标识的处理
    if ([photo.url.lowercaseString hasSuffix:@"gif"]) { // 是GIF
        _gifView.hidden = NO;
    } else {
        _gifView.hidden = YES;
    }
}

@end
