//
//  MessageKeyboardView.h
//  weLian
//
//  Created by dong on 14-10-13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLBasicTrends.h"
#import "WLTextField.h"

#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 200
#define  toolBarHeight 50
#define  buttonWh 34

typedef void(^MessageCommeBlock)(NSString *comment);

@interface MessageKeyboardView : UIView

@property (nonatomic, strong)  WLTextField  *commentTextView;

- (instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)superView withMessageBlock:(MessageCommeBlock)messageBlock;

- (void)startCompile:(WLBasicTrends*)touser;

-(void)dismissKeyBoard;

@end
