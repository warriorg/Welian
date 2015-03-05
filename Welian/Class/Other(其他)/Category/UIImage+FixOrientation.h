//
//  UIImage+FixOrientation.h
//  GKImagePicker
//
//  Created by Genki Kondo on 5/27/13.
//  Copyright (c) 2013 Genki Kondo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;

//设置图片颜色
- (UIImage *) partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest;

@end