//
//  NSString+val.h
//  WTInternship
//
//  Created by gh on 13-7-9.
//  Copyright (c) 2013年 Wanting3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(val)
//手机号是否有效
+ (BOOL)phoneValidate:(NSString *)phoneNum;

// 邮箱
+ (BOOL) validateEmail:(NSString *)email;

//密码是否有效
+ (BOOL)passwordValidate:(NSString *)password;
//学号是否有效
+ (BOOL)studentNumberValidate:(NSString *)number;
//判断是否为空
+ (BOOL)stringLeng:(NSString *)str;
//判断姓名的输入正确性
+ (BOOL)userNameValidate:(NSString *)name;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
