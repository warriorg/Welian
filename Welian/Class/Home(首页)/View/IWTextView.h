//
//  IWTextView.h
//  01-ItcastWeibo
//
//  Created by apple on 14-1-20.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  增加的功能：占位文字功能

#import <UIKit/UIKit.h>

@interface IWTextView : UITextView
/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  占位文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end