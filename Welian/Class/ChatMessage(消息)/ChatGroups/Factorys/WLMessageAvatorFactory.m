//
//  WLMessageAvatorFactory.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageAvatorFactory.h"
#import "UIImage+XHRounded.h"

@implementation WLMessageAvatorFactory

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatorType:(WLMessageAvatorType)type
{
    CGFloat radius = 0.0;
    switch (type) {
        case WLMessageAvatorTypeNormal:
            return originImage;
            break;
        case WLMessageAvatorTypeCircle:
            radius = originImage.size.width / 2.0;
            break;
        case WLMessageAvatorTypeSquare:
            radius = 8;
            break;
        default:
            break;
    }
    UIImage *avator = [originImage createRoundedWithRadius:radius];
    return avator;
}

@end
