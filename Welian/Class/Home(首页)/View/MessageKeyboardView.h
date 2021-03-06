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
//#import "WLMessageTextView.h"
#import "HPGrowingTextView.h"

#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  toolBarHeight 50
#define  buttonWh 34

typedef void(^MessageCommeBlock)(NSString *comment);
typedef void(^MessageTextHighBlcok)(CGFloat textHigh);

@interface MessageKeyboardView : UIView

@property (nonatomic, strong)  HPGrowingTextView  *commentTextView;

@property (nonatomic, copy) MessageTextHighBlcok textHighBlock;

- (instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)superView withMessageBlock:(MessageCommeBlock)messageBlock;

- (void)startCompile:(IBaseUserM*)touser;

-(void)dismissKeyBoard;

@end
