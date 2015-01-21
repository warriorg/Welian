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
#import "UIImageView+WebCache.h"
#import "CommentInfoController.h"
#import "MJExtension.h"
#import "HomeView.h"
#import "MessageController.h"
#import "UIBarButtonItem+Badge.h"
#import "CommentMode.h"
#import "MainViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "AFNetworkReachabilityManager.h"

@interface HomeController () <UIActionSheetDelegate>
{
   __block NSMutableArray *_dataArry;
    
    NSIndexPath *_clickIndex;
    NSNumber *_uid;
    NSIndexPath *_seletIndexPath;
}

@property (nonatomic, strong) HomeView *homeView;

@end

@implementation HomeController

- (HomeView *)homeView
{
    if (_homeView == nil) {
        _homeView = [[HomeView alloc] initWithFrame:self.tableView.frame];
        [_homeView setHomeController:self];
        [self.view addSubview:_homeView];
    }
    return _homeView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style anduid:(NSNumber *)uid
{
    _uid = uid;
    self = [super initWithStyle:style];
    if (self) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(beginPullDownRefreshing) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        [self.refreshControl beginRefreshing];
        _dataArry = [NSMutableArray array];
        if (!_uid) {
            NSArray *arrr  = [[WLDataDBTool sharedService] getAllItemsFromTable:KHomeDataTableName];
            
            for (YTKKeyValueItem *aa in arrr) {
                WLStatusFrame *sf = [self dataFrameWith:aa.itemObject];
                [_dataArry addObject:sf];
            }
            
            [self loadFirstFID];    
        }
        
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    }
    return self;
}

#pragma mark - 取第一条ID保存
- (void)loadFirstFID
{
    // 1.第一条微博的ID
    WLStatusFrame *startf = [_dataArry firstObject];
    [LogInUser setUserFirststustid:@(startf.status.fid)];
}


- (void)beginPullDownRefreshing
{
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];

    if (_uid) {
        [darDic setObject:@(0) forKey:@"page"];
        [darDic setObject:_uid forKey:@"uid"];        
    }else {
        [darDic setObject:@(0) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedsParameterDic:darDic andLoadType:_uid success:^(id JSON) {
        
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        // 1.在拿到最新微博数据的同时计算它的frame
        [_dataArry removeAllObjects];
        
        for (NSDictionary *dic in jsonarray) {
            
             WLStatusFrame *sf = [self dataFrameWith:dic];
            [_dataArry addObject:sf];
        }
        if (!_uid) {
            [self loadFirstFID];
            if (!_dataArry.count) {
                [self.homeView setHidden:NO];
            }else{
                [self.homeView setHidden:YES];
            }
        }
        [LogInUser setUserNewstustcount:@(0)];
        [[MainViewController sharedMainViewController] updataItembadge];
        [self.tableView reloadData];

        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
        if (jsonarray.count<KCellConut) {
            [self.tableView setFooterHidden:YES];
        }
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

- (WLStatusFrame*)dataFrameWith:(NSDictionary *)statusDic
{
    WLStatusM *statusM = [WLStatusM objectWithKeyValues:statusDic];
    
    NSArray *feedarray = [statusDic objectForKey:@"forwards"];
    NSArray *zanarray = [statusDic objectForKey:@"zans"];
    
    NSMutableArray *forwardsM = [NSMutableArray array];
    if (feedarray.count) {
        for (NSDictionary *feeddic in feedarray) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:feeddic];
            [forwardsM addObject:mode];
        }
    }
    [statusM setForwardsArray:forwardsM];
    
    NSMutableArray *zanArrayM = [NSMutableArray array];
    if (zanarray.count) {
        for (NSDictionary *zandic in zanarray) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:zandic];
            [zanArrayM addObject:mode];
        }
    }
    [statusM setZansArray:zanArrayM];
    
    NSArray *comments = [statusDic objectForKey:@"comments"];
    NSMutableArray *commentArrayM = [NSMutableArray array];
    if (comments.count) {
        for (NSDictionary *commDic in comments) {
            CommentMode *commMode = [CommentMode objectWithKeyValues:commDic];
            [commentArrayM addObject:commMode];
        }
    }
    [statusM setCommentsArray:commentArrayM];
    
    WLStatusFrame *sf = [[WLStatusFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-60];
    sf.status = statusM;
    return sf;
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    // 1.最后1条微博的ID
    WLStatusFrame *f = [_dataArry lastObject];
    int start = f.status.fid;

    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    if (_uid) {
        [darDic setObject:_uid forKey:@"uid"];
        [darDic setObject:@(start) forKey:@"page"];
    }else{
        [darDic setObject:@(start) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedsParameterDic:darDic andLoadType:_uid success:^(id JSON) {
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        
        for (NSDictionary *dic in jsonarray) {
            WLStatusFrame *sf = [self dataFrameWith:dic];
            [newFrames addObject:sf];
        }
        
        // 2.将newFrames整体插入到旧数据的后面
        [_dataArry addObjectsFromArray:newFrames];
        
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
        
        if (jsonarray.count<KCellConut) {
            [self.tableView setFooterHidden:YES];
        }
        
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPullDownRefreshing) name:KPublishOK object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageHomenotif) name:KMessageHomeNotif object:nil];
    
    if (_uid) {
      [self beginPullDownRefreshing];
    }else{
        [self performSelector:@selector(beginPullDownRefreshing) withObject:nil afterDelay:3.0];
    }
    
    // 1.设置界面属性
    [self buildUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 来了新消息
- (void)messageHomenotif
{
    NSString *badgeStr = [NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].homemessagebadge];
    [self.navigationItem.leftBarButtonItem setBadgeValue:badgeStr];
    [[MainViewController sharedMainViewController] updataItembadge];
}


#pragma mark 设置界面属性
- (void)buildUI
{
    if (!_uid) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_write"] style:UIBarButtonItemStyleBordered target:self action:@selector(publishStatus)];
        
        UIImage *image = [UIImage imageNamed:@"navbar_remind"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0,0,35, 35);
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
        [button addTarget:self action:@selector(messageButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        // Make BarButton Item
        UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = navLeftButton;
        self.navigationItem.leftBarButtonItem.badgeBGColor = [UIColor redColor];
        NSInteger badge = [[LogInUser getCurrentLoginUser].homemessagebadge integerValue];
        if (badge>0) {
            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].homemessagebadge];
        }
    }
    // 背景颜色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:WLLineColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, IWTableBorderWidth, 0);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DLog(@"status===%d",status);
        if (status == AFNetworkReachabilityStatusNotReachable) {
        }else{
        }
    }];

}

#pragma mark - 消息页面
- (void)messageButtonPress:(id)sender
{
    BOOL isAllMessage = YES;
    if ([LogInUser getCurrentLoginUser].homemessagebadge.integerValue) {
        isAllMessage = NO;
    }
    
    MessageController *messageVC = [[MessageController alloc] initWithStyle:UITableViewStyleGrouped isAllMessage:isAllMessage];
    
    [self.navigationController pushViewController:messageVC animated:YES];
    
    self.navigationItem.leftBarButtonItem.badgeValue = nil;
    [self.navigationController.tabBarItem setBadgeValue:nil];
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
    [cell setHomeVC:self];
    
    // 2.给cell传递模型数据
    // 传递的模型：文字数据 + 子控件frame数据
    cell.statusFrame = _dataArry[indexPath.row];
    cell.feedzanBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusF];
        [self.tableView reloadData];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.feedTuiBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusF];
        [self.tableView reloadData];
    };
    //    // 评论
    [cell.contentAndDockView.dock.commentBtn addTarget:self action:@selector(commentBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    // 更多
    [cell.moreBut addTarget:self action:@selector(moreClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
        [self pushCommentInfoVC:indexPath];
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
            
            [_dataArry removeObject:statuF];
            [self.tableView deleteRowsAtIndexPaths:@[_clickIndex] withRowAnimation:UITableViewRowAnimationFade];
        } fail:^(NSError *error) {
            
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataArry[indexPath.row] cellHigh]+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushCommentInfoVC:indexPath];
}

#pragma mark - 进入详情页
- (void)pushCommentInfoVC:(NSIndexPath*)indexPath
{
    WLStatusFrame *statusF = _dataArry[indexPath.row];
    
    if (statusF.status.type==2) return;
    
    CommentInfoController *commentInfo = [[CommentInfoController alloc] init];
    [commentInfo setStatusM:statusF.status];
    commentInfo.feedzanBlock = ^(WLStatusM *statusM){
        
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusF];
        [self.tableView reloadData];
    };
    commentInfo.feedTuiBlock = ^(WLStatusM *statusM){
        
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusF];
        [self.tableView reloadData];
    };
    commentInfo.commentBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusF];
        [self.tableView reloadData];
    };
    
    commentInfo.deleteStustBlock = ^(WLStatusM *statusM){
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [statusF setStatus:statusM];
        [_dataArry removeObject:statusF];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    _seletIndexPath = indexPath;
    [self.navigationController pushViewController:commentInfo animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    // Dispose of any resources that can be recreated.
}

@end
