//
//  ForgetAlertView.h
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ForgetPhoneBlok)(NSString *phoneStr);

@interface ForgetAlertView : UIView

- (id)initWithDeputStr:(NSString *)deputStr andTextFidePlesh:(NSString *)placeholder;

- (void)show;

@property (nonatomic, copy) ForgetPhoneBlok rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;



@end
