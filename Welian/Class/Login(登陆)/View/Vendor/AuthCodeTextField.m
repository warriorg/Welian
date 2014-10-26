//
//  AuthCodeTextField.m
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AuthCodeTextField.h"

@implementation AuthCodeTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        self.tintColor = [UIColor clearColor];
        [self setKeyboardType:UIKeyboardTypeNumberPad];
        [self setTextColor:[UIColor clearColor]];
        self.oneLabel = [self addLabelFrame:CGRectMake(0, 0, frame.size.width/4, frame.size.height)];
        
        self.twoLabel = [self addLabelFrame:CGRectMake(66, 0, frame.size.width/4, frame.size.height)];
        
        self.thirdLabel = [self addLabelFrame:CGRectMake(132, 0, frame.size.width/4, frame.size.height)];
        
        self.fourLabel = [self addLabelFrame:CGRectMake(198, 0, frame.size.width/4, frame.size.height)];
        [self becomeFirstResponder];
    }
    return self;
}

- (UILabel *)addLabelFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor lightTextColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:25]];
    [self addSubview:label];
    return label;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
