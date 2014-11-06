//
//  CertificationController.m
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CertificationController.h"
#import "PioneeringController.h"
#import "InvestViewController.h"
#import "InvestAuthModel.h"


@interface CertificationController ()
{
    NSDictionary *_dataDic;
    InvestAuthModel *_invesM;
}
@end

@implementation CertificationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = @[@"投资人认证"];
    [self addDatainfo];
}

- (void)addDatainfo
{
    [WLHttpTool getInvestAuthParameterDic:@{@"uid":@0} success:^(id JSON) {
        _dataDic = JSON;
        _invesM = [[InvestAuthModel alloc] init];
        if (_dataDic.allKeys) {
            [_invesM setUrl:[_dataDic objectForKey:@"url"]];
            [_invesM setAuth:[_dataDic objectForKey:@"auth"]];
            [_invesM setItems:[_dataDic objectForKey:@"items"]];
            _invesM.itemsArray = [[_dataDic objectForKey:@"items"] componentsSeparatedByString:@","];
            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            [mode setInvestorauth:[_dataDic objectForKey:@"auth"]];
            [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
            [self.tableView reloadData];
        }

    } fail:^(NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (nil == cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell.imageView setImage:[UIImage imageNamed:@"me_renzheng_tou"]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
        UIButton *tayBut = [[UIButton alloc] initWithFrame:CGRectMake(220, 13, 70, 22)];
        [tayBut setEnabled:NO];
        [cell.contentView addSubview:tayBut];
        [tayBut setHidden:NO];
        NSInteger inves = [mode.investorauth integerValue];
        DLog(@"%@", [mode.investorauth class]);
        switch (inves) {
            case 0:
                [tayBut setHidden:YES];
                break;
            case 1:
                [tayBut setImage:[UIImage imageNamed:@"me_renzheng_certification_bg"] forState:UIControlStateDisabled];
                break;
            case -1:
                [tayBut setImage:[UIImage imageNamed:@"me_renzheng_certification_failed_bg"] forState:UIControlStateDisabled];
                break;
            case -2:
                [tayBut setImage:[UIImage imageNamed:@"me_renzheng_uncertification_bg"] forState:UIControlStateDisabled];
                break;
            default:
                break;
        }
    }
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        InvestViewController *invesVC = [[InvestViewController alloc] initWithStyle:UITableViewStyleGrouped andData:_invesM];
        [invesVC setTitle:self.dataArray[indexPath.row]];
        [self.navigationController pushViewController:invesVC animated:YES];
    }else if (indexPath.row==1){
    
        PioneeringController *pioneVC = [[PioneeringController alloc] init];
        [pioneVC setTitle:self.dataArray[indexPath.row]];
        [self.navigationController pushViewController:pioneVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
