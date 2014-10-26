//
//  LoginAlertView.h
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginPhoneBlok)(NSString *phoneStr, NSString *passwordStr);

@interface LoginAlertView : UIView

- (id)init;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) LoginPhoneBlok rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;


@end
