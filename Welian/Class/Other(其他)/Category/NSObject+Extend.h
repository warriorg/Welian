//
//  NSObject+Extend.h
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)

//将NSArray或者NSDictionary转化为NSString
- (NSData *)JSONString;
- (NSString *)toJSONString;
// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData;

@end
