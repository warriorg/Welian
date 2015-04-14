//
//  UIView+Extend.h
//  The Dragon
//
//  Created by yangxh on 12-7-3.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

// 设置为调试状态
- (void)setDebug:(BOOL)val;

- (UIView *)findFirstResponder;

- (void)dropShadowWithOpacity:(float)opacity;

//获取按钮对象
+ (UIButton *)getBtnWithTitle:(NSString *)title image:(UIImage *)image;

@end

