//
//  HomeController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HomeController.h"
#import "PublishStatusController.h"
#import "NavViewController.h"
#import "WLHUDView.h"
#import "SVPullToRefresh.h"

@interface HomeController ()
{
    NSMutableArray *_dataArry;
}
@end

@implementation HomeController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl beginRefreshing];
        [self.tableView setContentSize:CGSizeMake(0, [UIScreen mainScreen].bounds.size.height)];
        
    }
    return self;
}


- (void)beginPullDownRefreshing
{
    UserInfoModel *mo = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    NSInteger uid = [mo.uid integerValue];
    [WLHttpTool loadFeedParameterDic:@{@"start":@(0),@"size":@(20),@"uid":@(uid)} success:^(id JSON) {
        [self.refreshControl endRefreshing];
        
        [self.tableView.infiniteScrollingView stopAnimating];
        
        _dataArry = [NSMutableArray arrayWithArray:JSON];
        if (_dataArry.count) {
            __weak HomeController *weakSelf = self;
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                [weakSelf beginPullDownRefreshing];
            }];
        }
        [self.tableView reloadData];
        DLog(@"dasdfsadfa");
    } fail:^(NSError *error) {
        
    }];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self beginPullDownRefreshing];
    // 1.设置界面属性
    [self buildUI];
    
}

#pragma mark 设置界面属性
- (void)buildUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_write"] style:UIBarButtonItemStyleBordered target:self action:@selector(publishStatus)];
    
    // 背景颜色
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
}



#pragma mark - 发表状态
- (void)publishStatus
{
    PublishStatusController *publishVC = [[PublishStatusController alloc] init];
    [self presentViewController:[[NavViewController alloc] initWithRootViewController:publishVC] animated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *da = _dataArry[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%d",[da objectForKey:@"fid"]]];
    return cell;
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
