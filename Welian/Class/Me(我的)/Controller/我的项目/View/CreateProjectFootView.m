//
//  CreateProjectFootView.m
//  Welian
//
//  Created by dong on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CreateProjectFootView.h"

@implementation CreateProjectFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SuperSize.width-30, 25)];
        [self addSubview:_titLabel];
        _textView = [[IWTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titLabel.frame), SuperSize.width-20, 160)];
        [self.textView setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
        [self.textView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [self.textView setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_textView];
        // 选择照片
        UIImage *butImage = [UIImage imageNamed:@"home_new_picture"];
        _photBut = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame), butImage.size.width, butImage.size.height)];
        [_photBut setImage:butImage forState:UIControlStateNormal];
        [self addSubview:_photBut];
    }
    return self;
}


@end
