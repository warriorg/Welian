//
//  WLMessageAvatorFactory.h
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

// 头像大小以及头像与其他控件的距离
static CGFloat const kWLAvatarImageSize = 35.0f;
static CGFloat const kWLAlbumAvatorSpacing = 6.0f;

typedef NS_ENUM(NSInteger, WLMessageAvatorType) {
    WLMessageAvatorTypeNormal = 0,
    WLMessageAvatorTypeSquare,
    WLMessageAvatorTypeCircle
};

@interface WLMessageAvatorFactory : NSObject

+ (UIImage *)avatarImageNamed:(UIImage *)originImage
            messageAvatorType:(WLMessageAvatorType)type;

@end
