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

@interface WorksListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *nostringImage;
@end

@implementation WorksListController

- (UIImageView *)nostringImage
{
    if (_nostringImage==nil) {
        _nostringImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
        [_nostringImage setFrame:self.tableView.frame];
    }
    return _nostringImage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginPullDownRefreshing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.dataArray = [NSMutableArray array];
    if (self.wlUserLoadType == WLSchool) {
        [WLHttpTool loadUserSchoolParameterDic:@{} success:^(id JSON) {
            [self.refreshControl endRefreshing];
            self.dataArray = JSON;
            if (self.dataArray.count) {
                
                
            }else{
                if (self.nostringImage.superview==nil) {
                    
//                    [self.tableView addSubview:self.nostringImage];
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
                
                
            }else{
                if (self.nostringImage.superview==nil) {
                    [self.tableView addSubview:self.nostringImage];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
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
    
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    [cell.textLabel setText:dataDic[@"name"]];
    [cell.detailTextLabel setText:dataDic[@"date"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [self.dataArray removeObjectAtIndex:indexPath.section];
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
    //移除tableView中的数据
    [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationRight];

}



#pragma mark - 添加工作经历
- (void)addWorkExperience
{
    AddWorkOrEducationController *addWkOrEdVC;
    
    if (self.wlUserLoadType==WLSchool) {
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:0];
    }else if (self.wlUserLoadType == WLCompany){
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:1];
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
