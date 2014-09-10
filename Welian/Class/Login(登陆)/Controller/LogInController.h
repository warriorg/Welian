//
//  LogInController.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *LogInButtoon;
- (IBAction)signInClick:(UIButton *)sender;
- (IBAction)logInClick:(UIButton *)sender;

@end
