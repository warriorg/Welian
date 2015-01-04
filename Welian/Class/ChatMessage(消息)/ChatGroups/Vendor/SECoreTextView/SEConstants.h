//
//  SEConstants.h
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/27.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECompatibility.h"

@interface SEConstants : NSObject

+ (NSColor *)selectedTextBackgroundColor;
+ (NSColor *)linkColor;
+ (NSColor *)selectionCaretColor;
+ (NSColor *)caretColor;

//接收的textColor
+ (NSColor *)receiveTextColor;
//发送的textColor
+ (NSColor *)sendTextColor;

@end
