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
#import "IPhotoUp.h"

@interface InvestCerVC ()<UIActionSheetDelegate, UIAlertViewDelegate>
{
    LogInUser *_loginuser;
    UIImage *_image;
}
@property (nonatomic, strong) UILabel *headLabel;
@end


static NSString *invcellid = @"investCardcell";
static NSString *addcasecellid = @"addcasecellid";
static NSString *seeltwocellid = @"seeltwocellid";
static NSString *itemscellid = @"itemscellid";

@implementation InvestCerVC

- (NSString *)title
{
    return @"投资信息";
}

- (UILabel *)headLabel
{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
        [_headLabel setTextAlignment:NSTextAlignmentCenter];
        _headLabel.font = WLFONT(16);
        
    }
    NSInteger auth = [LogInUser getCurrentLoginUser].investorauth.integerValue;
    if (auth ==1){ // 认证成功
        _headLabel.text = @"  投资人认证成功！";
        _headLabel.textColor = WLRGB(52, 116, 186);
    }else if (auth ==-2){  // 正在审核
        _headLabel.text = @"  名片已上传，正在等待验证...";
        _headLabel.textColor = WLRGB(52, 116, 186);
    }else if (auth ==-1){ // 认证失败
        _headLabel.text = @"  很遗憾，未能通过投资人认证";
        _headLabel.textColor = WLRGB(255, 117, 117);
    }
    return _headLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [WeLianClient loadInvestorWithID:@(0) Success:^(id resultInfo) {
        IIMeInvestAuthModel *meInvestAuth = [IIMeInvestAuthModel objectWithDict:resultInfo];
        [LogInUser setUserUrl:meInvestAuth.url];
        [LogInUser setUserinvestorauth:meInvestAuth.auth];
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

    } Failed:^(NSError *error) {
    
    }];
    // 取自己创业者认证
//    [WLHttpTool getInvestAuthParameterDic:@{@"uid":@(0)} success:^(id JSON) {
//        IIMeInvestAuthModel *meInvestAuth = [IIMeInvestAuthModel objectWithDict:JSON];
//        [LogInUser setUserUrl:meInvestAuth.url];
//        [LogInUser setUserinvestorauth:meInvestAuth.auth];
//        for (IInvestIndustryModel *industryM in meInvestAuth.industry) {
//            [InvestIndustry createInvestIndustry:industryM];
//        }
//        for (IInvestStageModel *stageM in meInvestAuth.stages) {
//            [InvestStages createInvestStages:stageM];
//        }
//        for (InvestItemM *itemM in meInvestAuth.items) {
//            [InvestItems createInvestItems:itemM];
//        }
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];
    
    [self refreshTabelViewHead];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestCardCell" bundle:nil] forCellReuseIdentifier:invcellid];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCaseCell" bundle:nil] forCellReuseIdentifier:addcasecellid];
}

- (void)refreshTabelViewHead
{
    NSInteger auth = [LogInUser getCurrentLoginUser].investorauth.integerValue;
    if (auth != 0) {
        [self.tableView setTableHeaderView:self.headLabel];
    }else{
        [self.tableView setTableHeaderView:nil];
    }
    [self.tableView reloadData];
//    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0]withRowAnimation:UITableViewRowAnimationNone];
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
        return 1+[LogInUser getCurrentLoginUser].rsInvestItems.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 78;
    }else{
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 20;
    }else if (section ==2){
        return 30;
    }
    return KTableHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
         NSInteger auth = [LogInUser getCurrentLoginUser].investorauth.integerValue;
        if (auth == 0) {  // 默认状态
            return @"  上传名片，认证投资人";
        }else if (auth ==1){ // 认证成功
            return @"  如果想重新认证，可重新上传名片";
        }else if (auth ==-2){  // 正在审核
            return @"  如果想重新认证，可重新上传名片";
            
        }else if (auth ==-1){ // 认证失败
            return @"  上传名片，重新认证";
        }
    }
    if (section==2) {
        return @"  投资案例";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

        InvestCardCell *cell = [tableView dequeueReusableCellWithIdentifier:invcellid];
    
        if (_image) {
            [cell.investCardBut setImage:_image];
        }else{
            NSString *urlStr = [LogInUser getCurrentLoginUser].url;
            NSInteger auth = [LogInUser getCurrentLoginUser].investorauth.integerValue;
            if (auth == 0) {  // 默认状态
                urlStr = nil;
                
            }
            [cell.investCardBut sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"investor_attestation_add"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        }
        
        return cell;
    }else if(indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seeltwocellid];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:seeltwocellid];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        cell.detailTextLabel.font = kNormal14Font;
        if (indexPath.row ==0) {      // 投资领域
            [cell.textLabel setText:@"投资领域"];
            NSMutableString *industryStr = [NSMutableString string];
            NSArray *investIndustryarray = [LogInUser getCurrentLoginUser].rsInvestIndustrys.allObjects;
            for (InvestIndustry *induM in investIndustryarray) {
                [industryStr appendFormat:@"%@  ",induM.industryname];
            }
            [cell.detailTextLabel setText:industryStr];
        }else if (indexPath.row ==1){  // 投资阶段
            [cell.textLabel setText:@"投资阶段"];
            NSMutableString *stagesStr = [NSMutableString string];
            NSArray *investIndustryarray = [LogInUser getCurrentLoginUser].rsInvestStages.allObjects;
            for (InvestStages *stage in investIndustryarray) {
                [stagesStr appendFormat:@"%@  ",stage.stagename];
            }
            [cell.detailTextLabel setText:stagesStr];
        }
        return cell;
    }else if (indexPath.section ==2){
        if (indexPath.row==[LogInUser getCurrentLoginUser].rsInvestItems.count) {
            AddCaseCell *addcell = [tableView dequeueReusableCellWithIdentifier:addcasecellid];
            return addcell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemscellid];
            if (cell ==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:itemscellid];
            }
            NSArray *itemS = [[LogInUser getCurrentLoginUser] getAllInvestItems];
            InvestItems *item = itemS[indexPath.row];
            [cell.textLabel setText:item.item];
            return cell;
        }
    }
    return nil;
}

// 撤销认证
- (void)cancelAuth
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_setDestructiveButtonWithTitle:@"撤销认证" handler:^{
        [[[UIAlertView alloc] initWithTitle:@"确认撤销认证？" message:@"撤销之后，如果要再次认证，需要重新提交名片。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil] show];
    }];
    [sheet bk_addButtonWithTitle:@"重新认证" handler:^{
        [self choosePicture];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];

}

// 重新认证
- (void)anewAuth
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [sheet bk_addButtonWithTitle:@"重新认证" handler:^{
        [self choosePicture];
    }];

    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet showInView:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [WeLianClient deleteinvestorWithSuccess:^(id resultInfo) {
            [LogInUser setUserinvestorauth:@(0)];
            [LogInUser setUserUrl:nil];
            _image = nil;
            [self refreshTabelViewHead];
        } Failed:^(NSError *error) {
            
        }];
//        [WLHttpTool deleteInvestorParameterDic:@{} success:^(id JSON) {
//            [LogInUser setUserinvestorauth:@(0)];
//            [LogInUser setUserUrl:nil];
//            [self refreshTabelViewHead];
//        } fail:^(NSError *error) {
//            
//        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //image就是你选取的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [[WeLianClient sharedClient] uploadImageWithImageData:@[imageData] Type:@"investor" FeedID:nil Success:^(id resultInfo) {
        IPhotoUp *photoUp = [[IPhotoUp objectsWithInfo:resultInfo] firstObject];
        if (photoUp.photo&&[photoUp.type isEqualToString:@"investor"]) {
            [WeLianClient investWithParameterDic:@{@"photo":photoUp.photo} Success:^(id resultInfo) {
                [LogInUser setUserinvestorauth:@(-2)];
                _image = image;
//                [LogInUser setUserUrl:photoUp.photo];
                [self refreshTabelViewHead];
            } Failed:^(NSError *error) {
                
            }];
        }
    } Failed:^(NSError *error) {
        
    }];
    
    
//    [WLHttpTool investAuthParameterDic:@{@"photo":avatarStr} success:^(id JSON) {
//        NSString *url = [JSON objectForKey:@"url"];
//        [LogInUser setUserinvestorauth:@(-2)];
//        [LogInUser setUserUrl:url];
//        [self refreshTabelViewHead];
////        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0]withRowAnimation:UITableViewRowAnimationNone];
//    } fail:^(NSError *error) {
//        
//    }];
    [picker dismissViewControllerAnimated:YES completion:nil];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak InvestCerVC *weakSelf = self;
    if (indexPath.section==0) {
        NSInteger auth = [LogInUser getCurrentLoginUser].investorauth.integerValue;
        if (auth == 0) {  // 默认状态
            [self choosePicture];
        }else if (auth ==1){ // 认证成功
            [self cancelAuth];
        }else if (auth ==-2){  // 正在审核
            [self cancelAuth];
        }else if (auth ==-1){ // 认证失败
            [self anewAuth];
        }
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {      // 投资领域
            InvestCollectionVC *investVC = [[InvestCollectionVC alloc] initWithType:1];
            investVC.investBlock = ^(){
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:investVC animated:YES];
            
        }else if (indexPath.row==1){  // 投资阶段
            InvestCollectionVC *investVC = [[InvestCollectionVC alloc] initWithType:2];
            investVC.investBlock = ^(){
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:investVC animated:YES];
        }
    }else if (indexPath.section==2){ // 投资案例
        if (indexPath.row == [LogInUser getCurrentLoginUser].rsInvestItems.count) {
            
            NameController *caseVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
                
                NSArray *itemArray = [LogInUser getCurrentLoginUser].rsInvestItems.allObjects;
                NSMutableArray *arryM = [NSMutableArray array];
                for (InvestItems *item in itemArray) {
                    [arryM addObject:@{@"item":item.item}];
                }
                [arryM addObject:@{@"item":userInfo}];
                [WeLianClient investWithParameterDic:@{@"items":arryM} Success:^(id resultInfo) {
                    InvestItemM *invesIte = [[InvestItemM alloc] init];
                    [invesIte setItem:userInfo];
                    [invesIte setTime:[NSDate date]];
                    [InvestItems createInvestItems:invesIte];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                } Failed:^(NSError *error) {
                    
                }];
//                [WLHttpTool investAuthParameterDic:@{@"items":arryM} success:^(id JSON) {
//
//                    InvestItemM *invesIte = [[InvestItemM alloc] init];
//                    [invesIte setItem:userInfo];
//                    [invesIte setTime:[NSDate date]];
//                    [InvestItems createInvestItems:invesIte];
//                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//                } fail:^(NSError *error) {
//                    
//                }];
            } withType:IWVerifiedTypeAddress];
            [self.navigationController pushViewController:caseVC animated:YES];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if (indexPath.section==2&&indexPath.row != [LogInUser getCurrentLoginUser].rsInvestItems.count) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSArray *itemArray = [[LogInUser getCurrentLoginUser] getAllInvestItems];
    InvestItems *item = itemArray[indexPath.row];
    NSMutableArray *itemMuArray = [NSMutableArray arrayWithArray:itemArray];
    [itemMuArray removeObject:item];
    
    NSMutableArray *arryM = [NSMutableArray array];
    for (InvestItems *item in itemMuArray) {
        [arryM addObject:@{@"item":item.item}];
    }
    [WeLianClient investWithParameterDic:@{@"items":arryM} Success:^(id resultInfo) {
        [item MR_deleteEntity];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    } Failed:^(NSError *error) {
        
    }];
//    [WLHttpTool investAuthParameterDic:@{@"items":arryM} success:^(id JSON) {
//        [item MR_deleteEntity];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    } fail:^(NSError *error) {
//        
//    }];
}


@end
