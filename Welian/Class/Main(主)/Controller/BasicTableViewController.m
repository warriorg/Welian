//
//  BasicTableViewController.m
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BasicTableViewController.h"
#import "UIImageView+WebCache.h"

@interface BasicTableViewController ()  <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation BasicTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self.tableView setSectionHeaderHeight:KTableHeaderHeight];
        [self.tableView setSectionFooterHeight:0.0];
        [self.tableView setRowHeight:KTableRowH];
        [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KTableHeaderHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - 选取头像照片
- (void)choosePicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clickSheet:buttonIndex];
}

- (void)clickSheet:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setAllowsEditing:YES];
    if (buttonIndex==0) { //拍照
        // 判断相机可以使用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"摄像头不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
        
    }else if(buttonIndex ==1) {  // 从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"相册不可用！！！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles:nil, nil] show];
            return;
        }
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

- (void)dealloc
{
    if (!self.needlessCancel) {
        [WLHUDView hiddenHud];
        [WLHttpTool cancelAllRequestHttpTool];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
