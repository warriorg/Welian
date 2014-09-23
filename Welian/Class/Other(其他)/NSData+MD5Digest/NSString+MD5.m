//
//  NSString+MD5.m
//  TravelHeNan
//
//  Created by Apple on 13-12-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSString+MD5.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)
- (NSString *)md5{
    
    const char* character = [self UTF8String];  
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];  
    
    CC_MD5(character, strlen(character), result);  
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];  
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)  
    {  
        [md5String appendFormat:@"%02x",result[i]];  
    }  
    
    return md5String;  


}
@end
