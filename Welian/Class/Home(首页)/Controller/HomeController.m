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
#import "MJRefresh.h"
#import "WLStatusCell.h"
#import "WLUserStatusesResult.h"
#import "WLStatusM.h"
#import "WLBasicTrends.h"
#import "WLStatusCell.h"
#import "WLStatusFrame.h"
#import "StatusInfoController.h"

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
        _dataArry = [NSMutableArray array];
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl beginRefreshing];
        [self.tableView setContentSize:CGSizeMake(0, [UIScreen mainScreen].bounds.size.height)];
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    }
    return self;
}


- (void)beginPullDownRefreshing
{
    UserInfoModel *mo = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    NSInteger uid = [mo.uid integerValue];
    
    [WLHttpTool loadFeedParameterDic:@{@"start":@(0),@"size":@(20),@"uid":@(uid)} success:^(id JSON) {
        WLUserStatusesResult *userStatus = JSON;
        
        // 1.在拿到最新微博数据的同时计算它的frame
//        NSMutableArray *newFrames = [NSMutableArray array];
        [_dataArry removeAllObjects];
        
        for (WLStatusM *statusM in userStatus.data) {
            WLStatusFrame *sf = [[WLStatusFrame alloc] init];
            sf.status = statusM;
            [_dataArry addObject:sf];
        }
        
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
        
        DLog(@"dasdfsadfa");
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    UserInfoModel *mo = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    NSInteger uid = [mo.uid integerValue];
    // 1.最后1条微博的ID
    WLStatusFrame *f = [_dataArry lastObject];
    int start = f.status.fid;
    
    [WLHttpTool loadFeedParameterDic:@{@"start":@(start),@"size":@(20),@"uid":@(uid)} success:^(id JSON) {
        WLUserStatusesResult *userStatus = JSON;
        
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        
        for (WLStatusM *statusM in userStatus.data) {
            WLStatusFrame *sf = [[WLStatusFrame alloc] init];
            sf.status = statusM;
            [newFrames addObject:sf];
        }
        
        // 2.将newFrames整体插入到旧数据的后面
        [_dataArry addObjectsFromArray:newFrames];
        
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
        
        DLog(@"dasdfsadfa");
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, IWTableBorderWidth, 0);
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
    // 1.取出一个cell
    WLStatusCell *cell = [WLStatusCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    // 传递的模型：文字数据 + 子控件frame数据
    cell.statusFrame = _dataArry[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataArry[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StatusInfoController *statusInfo = [[StatusInfoController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:statusInfo animated:YES];
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
