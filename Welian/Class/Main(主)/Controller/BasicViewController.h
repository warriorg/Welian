//
//  BasicViewController.h
//  Welian
//
//  Created by dong on 15/1/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiDodgeKeyboard.h"
#import "WLNavHeaderView.h"

#define kHeaderViewHeight 300.f

@interface BasicViewController : UIViewController

@property (nonatomic, assign) BOOL needlessCancel;
@property (nonatomic, assign) BOOL showCustomNavHeader;
@property (nonatomic, assign) BOOL isJoindThisVC;//进入过当前vc
@property (assign,nonatomic) WLNavHeaderView *navHeaderView;


- (void)leftBtnClicked:(UIButton *)sender;
- (void)rightBtnClicked:(UIButton *)sender;

#pragma mark - 选取头像照片
- (void)choosePicture;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
