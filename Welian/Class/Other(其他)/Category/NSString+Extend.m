//
//  NSString+Extend.m
//  The Dragon
//
//  Created by yangxh on 12-7-19.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import "NSString+Extend.h"
#import "PinYin4Objc.h"

@implementation NSString (Extend)

- (BOOL)isContainsString:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

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

//日期转换
- (NSDate *)dateFromShortString
{
    NSString *string = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (NSDate *)dateFromString
{
    NSString *string = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (NSDate *)dateFromNormalString
{
    NSString *string = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:string];
    return date;
}

//去除空格
- (NSString *)deleteTopAndBottomKongge
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)deleteTopAndBottomKonggeAndHuiche
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
}

//汉字首字母转换
- (NSString *)getHanziFirstString
{
    //格式类型
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];

    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:[self substringToIndex:1] withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    return [[NSString stringWithFormat:@"%c",[outputPinyin characterAtIndex:0]] uppercaseString];
}

//获取时间戳
+ (NSString *)getNowTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];
    return timeString;
}

@end
