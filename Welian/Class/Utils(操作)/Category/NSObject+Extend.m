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

//传入的参数：1、生成图片的大小 2、压缩比 3、存放图片的路径
+ (void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    [thumbImageData writeToFile:thumbPath atomically:NO];
}

//压缩图片 这个方法适用于 对压缩后的图片的质量要求不高或者没有要求,因为这种方法只是压缩了图片的大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
