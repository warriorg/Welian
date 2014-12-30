//
//  InvestCerVC.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCerVC.h"
#import "InvestCardCell.h"
#import "InvestCollectionVC.h"
#import "AddCaseCell.h"
#import "NameController.h"
#import "InvestIndustry.h"
#import "InvestStages.h"
#import "InvestItems.h"
#import "IIMeInvestAuthModel.h"
#import "InvestItemM.h"
#import "IInvestIndustryModel.h"
#import "IInvestStageModel.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

@interface InvestCerVC ()<UIActionSheetDelegate, UIAlertViewDelegate>
{
    LogInUser *_loginuser;
}
@end


static NSString *invcellid = @"investCardcell";
static NSString *addcasecellid = @"addcasecellid";
static NSString *seeltwocellid = @"seeltwocellid";
static NSString *itemscellid = @"itemscellid";

@implementation InvestCerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 取自己创业者认证
    [WLHttpTool getInvestAuthParameterDic:@{@"uid":@(0)} success:^(id JSON) {
        IIMeInvestAuthModel *meInvestAuth = [IIMeInvestAuthModel objectWithDict:JSON];
        [LogInUser setUserUrl:meInvestAuth.url];
        [LogInUser setuserAuth:meInvestAuth.auth];
        for (IInvestIndustryModel *industryM in meInvestAuth.industry) {
            [InvestIndustry createInvestIndustry:industryM];
        }
        for (IInvestStageModel *stageM in meInvestAuth.stages) {
            [InvestStages createInvestStages:stageM];
        }
        for (InvestItemM *itemM in meInvestAuth.items) {
            [InvestItems createInvestItems:itemM];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
    // 修改认证信息
//    [WLHttpTool investAuthParameterDic:@{} success:^(id JSON) {
//        
//    } fail:^(NSError *error) {
//        
//    }];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestCardCell" bundle:nil] forCellReuseIdentifier:invcellid];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCaseCell" bundle:nil] forCellReuseIdentifier:addcasecellid];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 2;
    }else{
        return 1+[LogInUser getNowLogInUser].rsInvestItems.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 110;
    }else{
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 30;
    }
    return KTableHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return @"    投资案例";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

        InvestCardCell *cell = [tableView dequeueReusableCellWithIdentifier:invcellid];
        
        NSInteger auth = [LogInUser getNowLogInUser].auth.integerValue;
        
        if (auth == 0) {  // 默认状态
            [cell.stateLabel setText:@"上传名片，成为认证投资人"];
            [cell.investCardBut addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePicture)]];

        }else if (auth ==1){ // 认证成功
            [cell.stateLabel setText:@"你已经是认证投资人了"];
            [cell.investCardBut addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAuth)]];
        }else if (auth ==-2){  // 正在审核
            [cell.investCardBut addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAuth)]];
            [cell.stateLabel setText:@"正在认证..."];
            
        }else if (auth ==-1){ // 认证失败
            [cell.investCardBut addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAuth)]];
            [cell.stateLabel setText:@"认证失败"];
        }
        
        [cell.investCardBut sd_setImageWithURL:[NSURL URLWithString:[LogInUser getNowLogInUser].url] placeholderImage:[UIImage imageNamed:@"investor_attestation_add"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        
        return cell;
    }else if(indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seeltwocellid];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:seeltwocellid];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.row ==0) {      // 投资领域
            [cell.textLabel setText:@"投资领域"];
            NSMutableString *industryStr = [NSMutableString string];
            NSArray *investIndustryarray = [LogInUser getNowLogInUser].rsInvestIndustrys.allObjects;
            for (InvestIndustry *induM in investIndustryarray) {
                [industryStr appendString:induM.industryname];
            }
            [cell.detailTextLabel setText:industryStr];
        }else if (indexPath.row ==1){  // 投资阶段
            [cell.textLabel setText:@"投资阶段"];
            NSMutableString *stagesStr = [NSMutableString string];
            NSArray *investIndustryarray = [LogInUser getNowLogInUser].rsInvestStages.allObjects;
            for (InvestStages *stage in investIndustryarray) {
                [stagesStr appendString:stage.stagename];
            }
            [cell.detailTextLabel setText:stagesStr];
        }
        return cell;
    }else if (indexPath.section ==2){
        if (indexPath.row==[LogInUser getNowLogInUser].rsInvestItems.count) {
            AddCaseCell *addcell = [tableView dequeueReusableCellWithIdentifier:addcasecellid];
            return addcell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemscellid];
            if (cell ==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:itemscellid];
            }
            NSArray *itemS = [LogInUser getNowLogInUser].rsInvestItems.allObjects;
            InvestItems *item = itemS[indexPath.row];
            [cell.textLabel setText:item.item];
            return cell;
        }
    }
    return nil;
}

- (void)cancelAuth
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"撤销认证" otherButtonTitles:@"重新认证",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger auth = [LogInUser getNowLogInUser].auth.integerValue;
    if (auth == 0) {
        [self clickSheet:buttonIndex];
    }else{
        if (buttonIndex ==0) {  // 取消认证
//            [[[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"", nil] show];
            
            [WLHttpTool deleteInvestorParameterDic:@{} success:^(id JSON) {
                [LogInUser setuserAuth:@(0)];
                [LogInUser setUserUrl:nil];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }else if (buttonIndex ==1){  // 重新认证
        
        }
        DLog(@"%d",buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSString *avatarStr = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [WLHttpTool investAuthParameterDic:@{@"photo":avatarStr,@"photoname":@"jpg"} success:^(id JSON) {
        NSString *url = [JSON objectForKey:@"url"];
        [LogInUser setuserAuth:@(-2)];
        [LogInUser setUserUrl:url];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {      // 投资领域
            InvestCollectionVC *investVC = [[InvestCollectionVC alloc] initWithType:1];
            [self.navigationController pushViewController:investVC animated:YES];
            
        }else if (indexPath.row==1){  // 投资阶段
            InvestCollectionVC *investVC = [[InvestCollectionVC alloc] initWithType:2];
            
            [self.navigationController pushViewController:investVC animated:YES];
        }
    }else if (indexPath.section==2){
        if (indexPath.row == [LogInUser getNowLogInUser].rsInvestItems.count) {
            
            NameController *caseVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                DLog(@"%@",userInfo);
                NSArray *itemArray = [LogInUser getNowLogInUser].rsInvestItems.allObjects;
                NSMutableArray *arryM = [NSMutableArray array];
                for (InvestItems *item in itemArray) {
                    [arryM addObject:@{@"item":item.item}];
                }
                [arryM addObject:@{@"item":userInfo}];
                [WLHttpTool investAuthParameterDic:@{@"items":arryM} success:^(id JSON) {
                    DLog(@"fdsa");
                    InvestItemM *invesIte = [[InvestItemM alloc] init];
                    [invesIte setItem:userInfo];
                    [InvestItems createInvestItems:invesIte];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                } fail:^(NSError *error) {
                    
                }];
            } withType:IWVerifiedTypeName];
            [self.navigationController pushViewController:caseVC animated:YES];
        }
    }
}

@end
