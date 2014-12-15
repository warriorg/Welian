//
//  WorksListController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WorksListController.h"
#import "NavViewController.h"
#import "AddWorkOrEducationController.h"
#import "SchoolModel.h"
#import "CompanyModel.h"
#import "NoListView.h"

@interface WorksListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NoListView *nolistView;
@end

@implementation WorksListController

- (NoListView*)nolistView
{
    if (_nolistView == nil) {
        _nolistView = [[[NSBundle mainBundle] loadNibNamed:@"NoListView" owner:self options:nil] lastObject];
        [_nolistView setFrame:self.view.bounds];
        [_nolistView setCenter:self.view.center];
    }
    return _nolistView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginPullDownRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    // 加载ui
    [self loadUIview];
}

- (void)beginPullDownRefreshing
{
    // 加载数据
    [self loadDataArray];
}


#pragma mark - 加载数据
- (void)loadDataArray
{
    if (self.wlUserLoadType == WLSchool) {
        [WLHttpTool loadUserSchoolParameterDic:@{} success:^(id JSON) {
            [self.refreshControl endRefreshing];
            self.dataArray = JSON;
            if (self.dataArray.count) {
                [self.tableView reloadData];
                [self.nolistView removeFromSuperview];
            }else{
                if (self.nolistView.superview==nil) {
                    
                    [self.tableView addSubview:self.nolistView];
                }
            }
        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
        }];
    }else if (self.wlUserLoadType == WLCompany){
        [WLHttpTool loadUserCompanyParameterDic:@{} success:^(id JSON) {
            [self.refreshControl endRefreshing];
            
            self.dataArray = JSON;
            if (self.dataArray.count) {
                [self.tableView reloadData];
                [self.nolistView removeFromSuperview];
            }else{
                if (self.nolistView.superview==nil) {
                    [self.tableView addSubview:self.nolistView];
                }
            }

        } fail:^(NSError *error) {
            [self.refreshControl endRefreshing];
        }];
    }
    
}

#pragma mark - 加载页面UI
- (void)loadUIview
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWorkExperience)];
    
    if (self.dataArray.count==0) {
        
    }else {
        [self.tableView setRowHeight:60.0];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}


#pragma mark - tableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    if (self.wlUserLoadType == WLSchool) {
        SchoolModel *schoolM = self.dataArray[indexPath.section];
        [cell.textLabel setText:schoolM.schoolname];
        if (schoolM.endyear==-1) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld年%ld月  -  至今",(long)schoolM.startyear,(long)schoolM.startmonth]];
        }else{
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld年%ld月  -  %ld年%ld月",(long)schoolM.startyear,(long)schoolM.startmonth,(long)schoolM.endyear,(long)schoolM.endmonth]];
        }
        
    }else if (self.wlUserLoadType == WLCompany){
        CompanyModel *companyM = self.dataArray[indexPath.section];
        [cell.textLabel setText:companyM.companyname];
        if (companyM.endyear==-1) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld年%ld月  -  至今",(long)companyM.startyear,(long)companyM.startmonth]];
        }else{
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld年%ld月  -  %ld年%ld月",(long)companyM.startyear,(long)companyM.startmonth,(long)companyM.endyear,(long)companyM.endmonth]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    if (self.wlUserLoadType == WLSchool) {
        SchoolModel *scmode = self.dataArray[indexPath.section];
        [WLHttpTool deleteUserSchoolParameterDic:@{@"usid":@(scmode.usid)} success:^(id JSON) {
            
            [self.dataArray removeObjectAtIndex:indexPath.section];
            if (self.dataArray.count==0) {
                [self.tableView addSubview:self.nolistView];
            }
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
            //移除tableView中的数据
            [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationRight];
            
        } fail:^(NSError *error) {
            
        }];
    }else if (self.wlUserLoadType == WLCompany){
        CompanyModel *commode = self.dataArray[indexPath.section];
        [WLHttpTool deleteUserCompanyParameterDic:@{@"ucid":@(commode.ucid)} success:^(id JSON) {
            
            [self.dataArray removeObjectAtIndex:indexPath.section];
            
            if (self.dataArray.count==0) {
                [self.tableView addSubview:self.nolistView];
            }
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
            //移除tableView中的数据
            [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationRight];
            
        } fail:^(NSError *error) {
            
        }];
    }

}



#pragma mark - 添加工作经历
- (void)addWorkExperience
{
    AddWorkOrEducationController *addWkOrEdVC;
    
    if (self.wlUserLoadType==WLSchool) {
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:1];
    }else if (self.wlUserLoadType == WLCompany){
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:2];
    }
    NavViewController *navVC = [[NavViewController alloc] initWithRootViewController:addWkOrEdVC];
    [self presentViewController:navVC animated:YES completion:^{
        
    }];
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
