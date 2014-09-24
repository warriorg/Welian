//
//  IWTextView.m
//  01-ItcastWeibo
//
//  Created by apple on 14-1-20.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWTextView.h"

@interface IWTextView()
{
    BOOL _hidePlaceholder;
}
@end

@implementation IWTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColor = [UIColor grayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChange
{
    if (self.text.length) { // 隐藏placeholder
        _hidePlaceholder = YES;
    } else { // 显示placeholder
        _hidePlaceholder = NO;
    }
    
    [self setNeedsDisplay];
}

/**
 *  文本框的文字即将发生改变的时候就会调用
 *
 *  @param range    <#range description#>
 *  @param text     即将输入的文字
 *
 *  @return YES允许改变，NO不允许改变
 */
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (text.length) { // 即将输入东西
//        _hidePlaceholder = YES;
//        [self setNeedsDisplay];
//    } else if (textView.text.length == 1) { // 即将删除东西 && textView只剩下一个文字
//        _hidePlaceholder = NO;
//        [self setNeedsDisplay];
//    }
//    return YES;
//}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_hidePlaceholder) return;
    
    // 设置画笔颜色
    [_placeholderColor set];
    
    /*
     NSLineBreakByWordWrapping = 0,  保持单词的完整性
    NSLineBreakByCharWrapping,
    NSLineBreakByClipping,
    NSLineBreakByTruncatingHead,	
     NSLineBreakByTruncatingTail,
    NSLineBreakByTruncatingMiddle
     */
    CGFloat paddingX = 8;
    CGFloat paddingY = self.font.lineHeight * 0.4;
    rect.origin.x = paddingX;
    rect.origin.y = paddingY;
    rect.size.height -= 2 * paddingY;
    rect.size.width -= 2 * paddingX;
    
    [_placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByWordWrapping];
}

@end
