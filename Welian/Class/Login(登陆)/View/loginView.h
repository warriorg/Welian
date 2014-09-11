//
//  loginView.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jianjuTextField.h"

@interface loginView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tsLabel;
@property (strong, nonatomic)  jianjuTextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
