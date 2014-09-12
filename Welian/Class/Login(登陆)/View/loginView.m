//
//  loginView.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "loginView.h"

@implementation loginView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        self.phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 270, 40)];
        [self.phoneTextF setDelegate:self];
        //        [self.phoneTextF setBounds:CGRectMake(0, 0, 270, 50)];
        [self.phoneTextF.layer setCornerRadius:8];
        [self.phoneTextF setKeyboardType:UIKeyboardTypePhonePad];
        [self.phoneTextF.layer setMasksToBounds:YES];
        [self.phoneTextF setFont:[UIFont systemFontOfSize:20]];
        [self.phoneTextF setBackgroundColor:[UIColor lightGrayColor]];
        [self.phoneTextF setPlaceholder:@"手机号码"];
        [self.phoneTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self addSubview:self.phoneTextF];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    [self aaa:textField];
    if (range.location==0&&string.length) {
        [self.nextButton setEnabled:YES];
    }
    if (range.location==0&&string.length==0) {
        [self.nextButton setEnabled:NO];
    }
    if (range.location==11) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.nextButton setEnabled:NO];
    return YES;
}




@end
