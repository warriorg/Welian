//
//  NSObject+Extend.m
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NSObject+Extend.h"

@implementation NSObject (Extend)

//将NSArray或者NSDictionary转化为NSString
- (NSData*)JSONString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return nil;
    return result;
}

- (NSString *)toJSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        //使用这个方法的返回，我们就可以得到想要的JSON串
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
    
}

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

//设置特殊颜色
- (NSMutableAttributedString *)getAttributedInfoString:(NSString *)str searchStr:(NSString *)searchStr color:(UIColor *)sColor font:(UIFont *)sFont
{
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName:sColor,NSFontAttributeName:sFont};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange searchRange = [str rangeOfString:searchStr options:NSCaseInsensitiveSearch];
    [attrstr addAttributes:attrsDic range:searchRange];
    return attrstr;
}

@end
