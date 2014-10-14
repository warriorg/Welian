//
//  CommentInfoController.m
//  weLian
//
//  Created by dong on 14-10-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommentInfoController.h"
#import "WLStatusFrame.h"
#import "WLStatusM.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "MessageKeyboardView.h"

#import "ZBMessageManagerFaceView.h"

@interface CommentInfoController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArrayM;
}
@property (nonatomic, strong) WLStatusCell *statusCell;
@property (nonatomic, strong) NSMutableDictionary *reqestDic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) MessageKeyboardView *messageView;

@end

@implementation CommentInfoController

- (WLStatusCell*)statusCell
{
    if (_statusCell == nil) {
        _statusCell = [WLStatusCell cellWithTableView:nil];
        [_statusCell.dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    [_statusCell setStatusFrame:self.statusFrame];
    return _statusCell;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50) style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, IWIconWHSmall+2*IWCellBorderWidth, 0, 0)];
        [_tableView setBackgroundColor:WLLineColor];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
//        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.reqestDic = [NSMutableDictionary dictionary];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadNewCommentListData) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.tableView addSubview:self.refreshControl];
    
    
    [self loadNewCommentListData];
    
    [self.view addSubview:self.tableView];
    
    self.messageView = [[MessageKeyboardView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 50) andSuperView:self.view withMessageBlock:^(NSString *comment) {

        [WLHttpTool addFeedCommentParameterDic:@{@"fid":@(self.statusFrame.status.fid),@"touid":@([self.statusFrame.status.user.uid intValue]),@"comment":comment} success:^(id JSON) {
           
            self.statusFrame.status.commentcount++;
            
            [self loadNewCommentListData];
        } fail:^(NSError *error) {
            
        }];
        
    }];
    [self.view addSubview:self.messageView];
    

    [self.tableView addFooterWithTarget:self action:@selector(loadMoreCommentData)];
}


- (void)loadNewCommentListData
{
    [self.tableView setFooterHidden:YES];
    [self.reqestDic setObject:@(self.statusFrame.status.fid) forKey:@"fid"];
    [self.reqestDic setObject:@(KCellConut) forKey:@"size"];
    [self.reqestDic setObject:@(1) forKey:@"page"];
    [WLHttpTool loadFeedCommentParameterDic:self.reqestDic success:^(id JSON) {

        _dataArrayM = JSON;
        [self hiddenRefresh];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadMoreCommentData
{
    CommentCellFrame *commF = _dataArrayM.lastObject;
    [self.reqestDic setObject:commF.commentM.fcid forKey:@"fid"];
    
    [WLHttpTool loadFeedCommentParameterDic:self.reqestDic success:^(id JSON) {
        
        [_dataArrayM addObjectsFromArray:JSON];
        [self hiddenRefresh];
        
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.messageView dismissKeyBoard];
}

- (void)hiddenRefresh
{
    [self.refreshControl endRefreshing];
    [self.tableView footerEndRefreshing];
    
    if (_dataArrayM.count<KCellConut) {
        [self.tableView setFooterHidden:YES];
    }else{
        [self.tableView setFooterHidden:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.statusFrame.cellHeight+20;
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.statusCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCellFrame *commFrame = _dataArrayM[indexPath.row];
    return commFrame.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    // 传递的模型：文字数据 + 子控件frame数据
    cell.commentCellFrame = _dataArrayM[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCellFrame *commFrame = _dataArrayM[indexPath.row];
    [self.messageView startCompile:commFrame.commentM.user];
}



#pragma mark - 赞
- (void)attitudeBtnClick:(UIButton*)but
{
    [but setEnabled:NO];
    if (self.statusFrame.status.iszan==1) {
        [WLHttpTool deleteFeedZanParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
            [self.statusFrame.status setIszan:0];
            self.statusFrame.status.zan -= 1;
            self.statusCell;
            [but setEnabled:YES];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }else{
        
        [WLHttpTool addFeedZanParameterDic:@{@"fid":@(self.statusFrame.status.fid)} success:^(id JSON) {
            [self.statusFrame.status setIszan:1];
            self.statusFrame.status.zan +=1;
            self.statusCell;
            [but setEnabled:YES];
        } fail:^(NSError *error) {
            [but setEnabled:YES];
        }];
    }
}




@end
