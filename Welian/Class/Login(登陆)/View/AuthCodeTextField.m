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
        [self setBackgroundColor:[UIColor lightGrayColor]];
        self.tintColor = [UIColor clearColor];
        [self setKeyboardType:UIKeyboardTypeNumberPad];
        [self setTextColor:[UIColor clearColor]];
        self.oneLabel = [self addLabelFrame:CGRectMake(0, 0, frame.size.width/4-1, frame.size.height)];
        
        self.twoLabel = [self addLabelFrame:CGRectMake(70, 0, frame.size.width/4-1, frame.size.height)];
        
        self.thirdLabel = [self addLabelFrame:CGRectMake(140, 0, frame.size.width/4-1, frame.size.height)];
        
        self.fourLabel = [self addLabelFrame:CGRectMake(210, 0, frame.size.width/4-1, frame.size.height)];
    }
    return self;
}

- (UILabel *)addLabelFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor lightTextColor]];
    [label setTextColor:KBasesColor];
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
