//
//  UITextField+LeftRightView.m
//  Welian
//
//  Created by dong on 15/4/23.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "UITextField+LeftRightView.h"

@implementation UITextField (LeftRightView)

+ (UITextField *)textFieldWitFrame:(CGRect)frame placeholder:(NSString *)placeholder leftViewImageName:(NSString *)leftImage andRightViewImageName:(NSString *)rightImage
{
    UITextField *textf = [[UITextField alloc] initWithFrame:frame];
    [textf setPlaceholder:placeholder];
    [textf setBackgroundColor:[UIColor whiteColor]];
    [textf.layer setCornerRadius:4];
    [textf.layer setMasksToBounds:YES];
    
    if (leftImage) {
        [textf setLeftViewMode:UITextFieldViewModeAlways];
        UIButton *nameleftV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
        [nameleftV setUserInteractionEnabled:NO];
        [nameleftV setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        [textf setLeftView:nameleftV];
    }
    if (rightImage) {
        [textf setRightViewMode:UITextFieldViewModeAlways];
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
        [rightBtn setUserInteractionEnabled:NO];
        [rightBtn setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
        [textf setRightView:rightBtn];
    }
    return textf;
}

@end
