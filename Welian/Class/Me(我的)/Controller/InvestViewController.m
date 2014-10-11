//
//  InvestViewController.m
//  weLian
//
//  Created by dong on 14-10-9.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestViewController.h"
#import "IconTableViewCell.h"
#import "InvestListController.h"
#import "InvestAuthModel.h"
#import "InvestReqstModel.h"
#import "WLHUDView.h"
#import "AuthTypeView.h"

@interface InvestViewController () <InvestListDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) InvestAuthModel *investM;

@property (nonatomic, strong) InvestReqstModel *investReqstM;

@property (nonatomic, strong) AuthTypeView *authTypeV;
@end

static NSString *idetfid = @"investcell";
@implementation InvestViewController

- (AuthTypeView *)authTypeV
{
    if (_authTypeV == nil) {
        _authTypeV = [[[NSBundle mainBundle] loadNibNamed:@"AuthTypeView" owner:self options:nil] lastObject];
        [_authTypeV setFrame:CGRectMake(0, -40, self.view.bounds.size.width, 20)];
    }
    return _authTypeV;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData)];
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    NSInteger invest = [mode.investorauth integerValue];
    if (invest==0) {
        
    }else{
        [self.tableView setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
        [self.view addSubview:self.authTypeV];
        switch (invest) {
            case 1:
                [self.authTypeV.imageV setImage:[UIImage imageNamed:@"me_tip_yirenzheng"]];
                [self.authTypeV.titeLabel setText:@"恭喜您，您已经是投资认证人了"];
                break;
            case -1:
                [self.authTypeV.imageV setImage:[UIImage imageNamed:@"me_tip_yirenzheng"]];
                [self.authTypeV.titeLabel setText:@"认证失败"];
                break;
            case -2:
                [self.authTypeV.imageV setImage:[UIImage imageNamed:@"me_tip_yirenzheng"]];
                [self.authTypeV.titeLabel setText:@"正在审核中，请耐心等待"];
                break;
                
            default:
                break;
        }

    }
    
    
    self.investReqstM = [[InvestReqstModel alloc] init];
    
    [self addDatainfo];
    self.dataArray = @[@"名片",@"投资案例"];

    [self.tableView registerNib:[UINib nibWithNibName:@"IconTableViewCell" bundle:nil] forCellReuseIdentifier:idetfid];
}

- (void)saveData
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    if (self.investReqstM.photo.length) {
        [dicM setObject:self.investReqstM.photo forKey:@"photo"];
        [dicM setObject:@"jpg" forKey:@"photoname"];
        if (self.investM.items.count) {
            
            self.investReqstM.items = [self.investM.items componentsJoinedByString:@","];
            [dicM setObject:self.investReqstM.items forKey:@"items"];
        }
    }else{
        [WLHUDView showErrorHUD:@"名片必填"];
        return;
    }
    [WLHttpTool investAuthParameterDic:dicM success:^(id JSON) {
        [WLHUDView showSuccessHUD:@""];
    } fail:^(NSError *error) {
        
    }];

}

- (void)addDatainfo
{
    [WLHttpTool getInvestAuthParameterDic:@{@"uid":@0} success:^(id JSON) {
        self.investM = JSON;
        if (self.investM.url.length) {
            
        }
        if (self.investM.investType==InvestAuthTypeRefused) {
            
        }
        DLog(@"%@",JSON);
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60.0;
    }else{
        return 44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:idetfid];
        IconTableViewCell *iconCell = (IconTableViewCell*)cell;
        [iconCell.titleLabel setText:self.dataArray[indexPath.section]];
            
        [iconCell.iconImage sd_setImageWithURL:[NSURL URLWithString:self.investM.url] placeholderImage:[UIImage imageNamed:@"me_touzirenrenzheng_card"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSString *avatarStr = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [self.investReqstM setPhoto:avatarStr];
        }];
        
        
    }else if (indexPath.section==1){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.textLabel setText:self.dataArray[indexPath.section]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self choosePicture];
    }else if (indexPath.section ==1){
        InvestListController *investListVC = [[InvestListController alloc] init];
        [investListVC setDelegate:self];
        [investListVC setInvestM:self.investM];
        [self.navigationController pushViewController:investListVC animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    IconTableViewCell *cell = (IconTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell.iconImage setImage:image];
    [self.investReqstM setPhoto:avatarStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)investListVC:(InvestListController *)investListVC withItmesList:(NSArray *)itmesA
{
    [self.investM setItems:itmesA];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
