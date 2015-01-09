//
//  NSString+Extend.h
//  The Dragon
//
//  Created by yangxh on 12-7-19.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;

//将NSString转化为NSArray或者NSDictionary
- (id)JSONValue;

//日期转换
- (NSDate *)dateFromString;
- (NSDate *)dateFromShortString;

//去除两端空格
- (NSString *)deleteTopAndBottomKongge;
- (NSString *)deleteTopAndBottomKonggeAndHuiche;

//汉字首字母转换
- (NSString *)getHanziFirstString;


@end
