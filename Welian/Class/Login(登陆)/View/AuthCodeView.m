//
//  AuthCodeView.m
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AuthCodeView.h"

@implementation AuthCodeView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        self.authTextF = [[AuthCodeTextField alloc] initWithFrame:CGRectMake(10, 80, 270, 40)];
        [self.authTextF setDelegate:self];
        [self addSubview:self.authTextF];
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location>3) {
        return NO;
    }
    if (range.location==0) {
        [self.authTextF.oneLabel setText:string];
    }else if (range.location==1){
        [self.authTextF.twoLabel setText:string];
    }else if (range.location == 2){
        [self.authTextF.thirdLabel setText:string];
    }else if (range.location ==3){
        [self.authTextF.fourLabel setText:string];
    }
    
    if (self.authTextF.fourLabel.text.length) {
        [self.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    }else {
        [self.nextButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    
    return YES;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
