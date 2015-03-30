//
//  PhoneChangeVC.h
//  Welian
//
//  Created by dong on 15/3/26.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTextField.h"

typedef void (^PhoneChangeBlock)(void);

@interface PhoneChangeVC : UIViewController

// type  1 为验证手机号   2为修改手机号
- (instancetype)initWithPhoneType:(NSInteger)type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet WLTextField *phoneTF;
@property (weak, nonatomic) IBOutlet WLTextField *authCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *authBut;

@property (weak, nonatomic) IBOutlet UIButton *sureBut;
- (IBAction)sureButClick:(id)sender;

- (IBAction)authButClick:(id)sender;
@property (nonatomic, copy) PhoneChangeBlock phoneChangeBlcok;

@end
