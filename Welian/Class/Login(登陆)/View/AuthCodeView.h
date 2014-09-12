//
//  AuthCodeView.h
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCodeTextField.h"

@interface AuthCodeView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) AuthCodeTextField *authTextF;

@end
