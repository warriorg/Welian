//
//  BasicViewController.h
//  Welian
//
//  Created by dong on 15/1/4.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiDodgeKeyboard.h"

@interface BasicViewController : UIViewController

@property (nonatomic, assign) BOOL needlessCancel;


#pragma mark - 选取头像照片
- (void)choosePicture;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
