//
//  InvestInfoListVC.m
//  Welian
//
//  Created by dong on 15/1/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "InvestInfoListVC.h"
#import "IIMeInvestAuthModel.h"
#import "IInvestStageModel.h"
#import "InvestItemM.h"
#import "IInvestIndustryModel.h"

@interface InvestInfoListVC ()

@property (nonatomic, strong) UIView *headerView;

@end

@implementation InvestInfoListVC

- (UIView *)headerView
{
    if (_headerView ==nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -KTableRowH, SuperSize.width, KTableRowH)];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SuperSize.width-50, KTableRowH)];
        [headerLabel setFont:WLFONT(15)];
        [headerLabel setText:[NSString stringWithFormat:@"%@ 已经是认证投资人",_userName]];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_mycard_tou_big"]];
        [icon setFrame:CGRectMake(20, 16, 15, 15)];
        [_headerView addSubview:icon];
        [_headerView addSubview:headerLabel];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我是投资人"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    if (self.iimeInvestM.auth.integerValue==1) {  // 是认证投资人
        [self.tableView setContentInset:UIEdgeInsetsMake(KTableRowH, 0, 0, 0)];
        [self.tableView addSubview:self.headerView];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger items = self.iimeInvestM.items.count;
    NSInteger indust = self.iimeInvestM.industry.count;
    NSInteger stages = self.iimeInvestM.stages.count;
    NSString *headerStr = @"";
    if (section==0) {
        if (items) {
            headerStr = @"   投资案例";
        }else if (indust){
            headerStr = @"   投资领域";
        }else if (stages){
            headerStr = @"   投资阶段";
        }
    }else if (section ==1){
        if (items) {
            if (indust) {
                headerStr = @"   投资领域";
            }else if (stages){
                headerStr = @"   投资阶段";
            }
        }else{
            headerStr = @"   投资阶段";
        }
    }else if (section ==2){
        headerStr = @"   投资阶段";
    }
    return headerStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if (self.iimeInvestM.items.count) {
        count++;
    }
    if (self.iimeInvestM.industry.count) {
        count++;
    }
    if (self.iimeInvestM.stages.count) {
        count++;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger items = self.iimeInvestM.items.count;
    NSInteger indust = self.iimeInvestM.industry.count;
    NSInteger stages = self.iimeInvestM.stages.count;
    if (section==0) {
        if (items) {
            return items;
        }else if (indust){
            return indust;
        }else if (stages){
            return stages;
        }
    }else if (section ==1) {
        if (items) {
            if (indust) {
                return indust;
            }else if (stages){
                return stages;
            }
        }else{
            return stages;
        }
    }else if (section ==2){
        return stages;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inveslistcellid = @"inveslistcellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inveslistcellid];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:inveslistcellid];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSInteger items = self.iimeInvestM.items.count;
    NSInteger indust = self.iimeInvestM.industry.count;
    NSInteger stages = self.iimeInvestM.stages.count;
    
    if (indexPath.section==0) {
        if (items) {
            InvestItemM *itemM = self.iimeInvestM.items[indexPath.row];
            [cell.textLabel setText:itemM.item];
        }else if (indust){
            IInvestIndustryModel *industM = self.iimeInvestM.industry[indexPath.row];
            [cell.textLabel setText:industM.industryname];
        }else if (stages){
            IInvestStageModel *stageM = self.iimeInvestM.stages[indexPath.row];
            [cell.textLabel setText:stageM.stagename];
        }
    }else if (indexPath.section==1){
        if (items) {
            if (indust) {
                IInvestIndustryModel *industM = self.iimeInvestM.industry[indexPath.row];
                [cell.textLabel setText:industM.industryname];
            }else if (stages){
                IInvestStageModel *stageM = self.iimeInvestM.stages[indexPath.row];
                [cell.textLabel setText:stageM.stagename];
            }
        }else{
            IInvestStageModel *stageM = self.iimeInvestM.stages[indexPath.row];
            [cell.textLabel setText:stageM.stagename];
        }
    }else if (indexPath.section ==2){
        IInvestStageModel *stageM = self.iimeInvestM.stages[indexPath.row];
        [cell.textLabel setText:stageM.stagename];
    }
    
    return cell;
}

@end
