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

@interface HomeController () <UIActionSheetDelegate>
{
    NSMutableArray *_dataArry;
    NSString *_type;
    
    NSIndexPath *_clickIndex;
}
@end

@implementation HomeController

- (instancetype)initWithStyle:(UITableViewStyle)style withType:(NSString *)type
{
    _type = type;
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
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(20) forKey:@"size"];
    if ([_type isEqualToString:@"0"]) {
        [darDic setObject:@(0) forKey:@"page"];
        [darDic setObject:@(0) forKey:@"uid"];
        
    }else if ([_type isEqualToString:@"1"]){
        [darDic setObject:@(0) forKey:@"start"];
        [darDic setObject:@(uid) forKey:@"uid"];
    }
    
    [WLHttpTool loadFeedParameterDic:darDic success:^(id JSON) {
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

    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(20) forKey:@"size"];
    if ([_type isEqualToString:@"0"]) {
        [darDic setObject:@(start) forKey:@"page"];
        [darDic setObject:@(0) forKey:@"uid"];
        
    }else if ([_type isEqualToString:@"1"]){
        [darDic setObject:@(start) forKey:@"start"];
        [darDic setObject:@(uid) forKey:@"uid"];
    }
    
    
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
    if ([_type isEqualToString:@"0"]) {
        
    }else if ([_type isEqualToString:@"1"]){
    
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_write"] style:UIBarButtonItemStyleBordered target:self action:@selector(publishStatus)];
    }
    
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
    
    // 转发
    [cell.dock.repostBtn addTarget:self action:@selector(transmitButClick:event:) forControlEvents:UIControlEventTouchUpInside];
    // 赞
    [cell.dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    // 评论
    [cell.dock.commentBtn addTarget:self action:@selector(commentBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    // 更多
    [cell.moreBut addTarget:self action:@selector(moreClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 转发
- (void)transmitButClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        WLStatusFrame *statF = _dataArry[indexPath.row];
        DLog(@"%@",statF.status.user.name);
    }
}

#pragma mark - 赞
- (void)attitudeBtnClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        [but setEnabled:NO];
        WLStatusFrame *statF = _dataArry[indexPath.row];
        if (statF.status.iszan==1) {
            [WLHttpTool deleteFeedZanParameterDic:@{@"fid":@(statF.status.fid)} success:^(id JSON) {
                [statF.status setIszan:0];
                statF.status.zan -= 1;
                [_dataArry replaceObjectAtIndex:indexPath.row withObject:statF];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }else{
        
            [WLHttpTool addFeedZanParameterDic:@{@"fid":@(statF.status.fid)} success:^(id JSON) {
                [statF.status setIszan:1];
                statF.status.zan +=1;
                [_dataArry replaceObjectAtIndex:indexPath.row withObject:statF];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [but setEnabled:YES];
            } fail:^(NSError *error) {
                [but setEnabled:YES];
            }];
        }
        
        DLog(@"%@",statF.status.user.name);
    }
    
}

#pragma mark- 评论
- (void)commentBtnClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        WLStatusFrame *statF = _dataArry[indexPath.row];
        DLog(@"%@",statF.status.user.name);
    }
}

#pragma mark - 更多按钮
- (void)moreClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        _clickIndex = indexPath;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除该条动态" otherButtonTitles:nil,nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        WLStatusFrame *statuF = _dataArry[_clickIndex.row];
        
        [WLHttpTool deleteFeedParameterDic:@{@"fid":@(statuF.status.fid)} success:^(id JSON) {
            
            [_dataArry removeObjectAtIndex:_clickIndex.row];
            [self.tableView deleteRowsAtIndexPaths:@[_clickIndex] withRowAnimation:UITableViewRowAnimationFade];
        } fail:^(NSError *error) {
            
        }];
    }
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
