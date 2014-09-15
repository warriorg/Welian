//
//  UserInfoController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoController.h"
#import "InfoHeaderView.h"
#import "NameController.h"
#import "MainViewController.h"

@interface UserInfoController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) InfoHeaderView *infoHeader;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation UserInfoController

- (InfoHeaderView*)infoHeader
{
    if (nil == _infoHeader) {
        
        _infoHeader = [[[NSBundle mainBundle] loadNibNamed:@"InfoHeaderView" owner:self options:nil] lastObject];
        [_infoHeader.pictureBut addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoHeader;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加入weLian"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveAndLogin)];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"姓名":@"",@"单位":@"",@"职务":@""}];
    [self.view addSubview:self.tableView];
}

#pragma mark - 保存并登陆
- (void)saveAndLogin
{
    [UserDefaults setObject:UIImageJPEGRepresentation(self.infoHeader.pictureBut.imageView.image, 0.5) forKey:UserIconImage];
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self.view.window setRootViewController:mainVC];
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
    [self.infoHeader.pictureBut setImage:image forState:UIWindowLevelNormal];
    [self.infoHeader.pictureBut.layer setCornerRadius:self.infoHeader.pictureBut.bounds.size.width*0.5];
    [self.infoHeader.pictureBut.layer setMasksToBounds:YES];
    [self.infoHeader.pictureBut.layer setBorderWidth:2];
    [self.infoHeader.pictureBut.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}


#pragma mark ---tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSArray *array = self.dataDic.allKeys;
    [cell.textLabel setText:array[indexPath.row]];
    [cell.detailTextLabel setText:[self.dataDic objectForKey:array[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 170.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.infoHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"姓名"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"姓名"]];
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if (indexPath.row ==1){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"单位"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"单位"]];
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if (indexPath.row == 2){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"职务"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"职务"]];
        [self.navigationController pushViewController:nameVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
