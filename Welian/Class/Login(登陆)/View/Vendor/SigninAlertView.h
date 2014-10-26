//
//  LoginAlertView.h
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SigninPhoneBlok)(NSString *phoneStr);

@interface SigninAlertView : UIView

- (id)init;

- (void)show;

@property (nonatomic, copy) SigninPhoneBlok rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end
