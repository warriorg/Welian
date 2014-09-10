//
//  loginView.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tsLabel;
@property (strong, nonatomic)  UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
