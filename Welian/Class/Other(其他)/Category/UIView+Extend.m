//
//  UIView+Extend.m
//  The Dragon
//
//  Created by yangxh on 12-7-3.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (void)setDebug:(BOOL)val
{
    if (val) {
        self.layer.borderColor = [[UIColor colorWithRed:(arc4random()%100)/100.0f green:(arc4random()%100)/100.0f blue:(arc4random()%100)/100.0f alpha:1.0f] CGColor
                                  ];
        self.layer.borderWidth = 1.0f;
    }
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder]) {
        return self;
    }
    
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        UIView *firstResponder = [subview findFirstResponder];
        
        if (firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (void)dropShadowWithOpacity:(float)opacity
{
    opacity = opacity < .0f ? .5f : opacity;
    
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

//获取按钮对象
+ (UIButton *)getBtnWithTitle:(NSString *)title image:(UIImage *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f);
    button.layer.cornerRadius = 5.f;
    button.layer.masksToBounds = YES;
    //    favoriteBtn.frame = CGRectMake(0.f, 0.f, self.view.width / 3.f, toolBarHeight);
    //    favoriteBtn.frame = CGRectMake(0.f, 0.f , (self.view.width - 20 * 2) / 2.f, toolBarHeight - 20.f);
    return button;
}

@end
