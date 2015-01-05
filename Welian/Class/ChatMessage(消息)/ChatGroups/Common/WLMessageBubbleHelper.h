//
//  WLMessageBubbleHelper.h
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface WLMessageBubbleHelper : NSObject

+ (instancetype)sharedMessageBubbleHelper;

- (NSAttributedString *)bubbleAttributtedStringWithText:(NSString *)text;
- (NSAttributedString *)bubbleAttributtedStringWithText:(NSString *)text withTextColor:(UIColor *)textColor;

- (NSAttributedString *)attributedStringWithSpecial:(NSString *)text;

@end
