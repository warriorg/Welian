//
//  CodeNumberView.h
//  DXAlertView
//
//  Created by dong on 14/10/22.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CoderBlock)(NSString *codeStr);

@interface CodeNumberView : UIView

- (instancetype)initWithPhoneNumber:(NSString*)phoneStr;
- (void)show;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) CoderBlock rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end
