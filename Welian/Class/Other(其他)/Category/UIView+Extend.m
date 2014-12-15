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

@end
