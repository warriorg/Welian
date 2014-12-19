//
//  NSString+Extend.m
//  The Dragon
//
//  Created by yangxh on 12-7-19.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    }
//    else {
//        expectedLabelSize = [self sizeWithFont:font
//                             constrainedToSize:size
//                                 lineBreakMode:NSLineBreakByWordWrapping];
//    }

    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

//将NSString转化为NSArray或者NSDictionary
- (id)JSONValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
