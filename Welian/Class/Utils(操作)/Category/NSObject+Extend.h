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


//设置特殊颜色
- (NSMutableAttributedString *)getAttributedInfoString:(NSString *)str searchStr:(NSString *)searchStr color:(UIColor *)sColor font:(UIFont *)sFont;


//传入的参数：1、生成图片的大小 2、压缩比 3、存放图片的路径
+ (void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath;
//压缩图片 这个方法适用于 对压缩后的图片的质量要求不高或者没有要求,因为这种方法只是压缩了图片的大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



@end
