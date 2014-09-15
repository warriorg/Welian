//
//  MeInfoController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MeInfoController.h"
#import "NameController.h"
#import "WorksListController.h"

@interface MeInfoController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray *_data;
}
@property (nonatomic, strong) UIImageView *iconImage;
@end

@implementation MeInfoController

- (UIImageView*)iconImage
{
    if (nil == _iconImage) {
        NSData *imageData = [UserDefaults objectForKey:UserIconImage];
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
//        [_iconImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _iconImage;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self loadPlist];
        // 2.设置tableView每组头部的高度
        self.tableView.sectionHeaderHeight = 15;
        self.tableView.sectionFooterHeight = 0;
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    return self;
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"meinfoPlist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_data[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (nil ==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section==0) {
        [self.iconImage setFrame:CGRectMake(0, 0, 40, 40)];
        [cell setAccessoryView:self.iconImage];
    }
    
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    [cell.textLabel setText:dict[@"title"]];
    [cell.detailTextLabel setText:dict[@"content"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }
    return 47;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        [self choosePicture];
        
    }else{
        UIViewController *controller;
        if (indexPath.section==2) {
            controller = [[WorksListController alloc] init];
            
        }else {
            controller = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                
            }];
            
        }
        [controller setTitle:dict[@"title"]];
        [self.navigationController pushViewController:controller animated:YES];

    }
    
}

#pragma mark - 选取头像照片
- (void)choosePicture
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self.iconImage setImage:image];
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}



@end
