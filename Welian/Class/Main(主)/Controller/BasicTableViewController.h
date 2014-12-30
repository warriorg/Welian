//
//  BasicTableViewController.h
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface BasicTableViewController : UITableViewController
#pragma mark - 选取头像照片
- (void)choosePicture;

- (void)clickSheet:(NSInteger)buttonIndex;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
