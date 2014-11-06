//
//  NSString+val.m
//  WTInternship
//
//  Created by gh on 13-7-9.
//  Copyright (c) 2013年 Wanting3. All rights reserved.
//

#import "NSString+val.h"

@implementation NSString(val)
+ (BOOL)phoneValidate:(NSString *)phoneNum{
    
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
+ (BOOL)passwordValidate:(NSString *)password{
    
    NSString *pwdRegex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){5,17}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pwdRegex];
    NSLog(@"%d",[pwdTest evaluateWithObject:password]);
    return [pwdTest evaluateWithObject:password];
}



//数字开头，长度7~11
+ (BOOL)studentNumberValidate:(NSString *)number{
    
    NSString *numberRe = @"^[0-9]{6,10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",numberRe];
    NSLog(@"%d",[numberTest evaluateWithObject:number]);
    return [numberTest evaluateWithObject:number];
}
//判断是否为空
+ (BOOL)stringLeng:(NSString *)str{
    
    if (str.length == 0 || str == nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)userNameValidate:(NSString *)name{
    
    NSString *nameRegex = @"^\\w{1,4}$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameRegex];
    return [nameTest evaluateWithObject:name];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self attributes:attribute];
    CGSize labelsize = [attrStr boundingRectWithSize:size options:options context:nil].size;

    return labelsize;
}

@end
