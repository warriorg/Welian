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

@interface BasicViewController : UIViewController

@property (nonatomic, assign) BOOL needlessCancel;
@property (nonatomic, assign) BOOL showCustomNavHeader;
@property (assign,nonatomic) WLNavHeaderView *navHeaderView;


- (void)leftBtnClicked:(UIButton *)sender;
- (void)rightBtnClicked:(UIButton *)sender;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

#pragma mark - 选取头像照片
- (void)choosePicture;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
