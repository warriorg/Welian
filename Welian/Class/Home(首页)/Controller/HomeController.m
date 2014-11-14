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
#import "WLDataDBTool.h"
#import "MJExtension.h"
#import "HomeView.h"
#import "MessageController.h"
#import "UIBarButtonItem+Badge.h"


@interface HomeController () <UIActionSheetDelegate,CommentInfoVCDelegate>
{
    NSMutableArray *_dataArry;
    
    NSIndexPath *_clickIndex;
    NSNumber *_uid;
    NSIndexPath *_selectIndexPath;
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
                WLStatusM *statusM = [WLStatusM objectWithKeyValues:aa.itemObject];
                WLStatusFrame *sf = [[WLStatusFrame alloc] init];
                sf.status = statusM;
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
    WLStatusFrame *f = [_dataArry firstObject];
    NSString *start = [NSString stringWithFormat:@"%d",f.status.fid];
    [UserDefaults setObject:start forKey:KFirstFID];
    [UserDefaults synchronize];
}



- (void)beginPullDownRefreshing
{
    [self.tableView setFooterHidden:YES];
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];

    if (_uid) {
        [darDic setObject:@(0) forKey:@"page"];
        [darDic setObject:_uid forKey:@"uid"];        
    }else {
        [darDic setObject:@(0) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedParameterDic:darDic andLoadType:_uid success:^(id JSON) {
        WLUserStatusesResult *userStatus = JSON;
        
        // 1.在拿到最新微博数据的同时计算它的frame
//        NSMutableArray *newFrames = [NSMutableArray array];
        [_dataArry removeAllObjects];
        
        for (WLStatusM *statusM in userStatus.data) {
            WLStatusFrame *sf = [[WLStatusFrame alloc] init];
            sf.status = statusM;
            [_dataArry addObject:sf];
        }
        if (!_uid) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [self loadFirstFID];
            if (!_dataArry.count) {
                [self.homeView setHidden:NO];
            }else{
                [self.homeView setHidden:YES];
            }
        }
        
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
        if (userStatus.data.count>=KCellConut) {
            [self.tableView setFooterHidden:NO];
        }
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [self.tableView footerEndRefreshing];
    }];
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
    
    [WLHttpTool loadFeedParameterDic:darDic andLoadType:_uid success:^(id JSON) {
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
        
        if (userStatus.data.count<KCellConut) {
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
    
    [self beginPullDownRefreshing];
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
    NSInteger badge = [self.navigationItem.leftBarButtonItem.badgeValue integerValue];
    badge++;
    NSString *badgeStr = [NSString stringWithFormat:@"%d",badge];
    [UserDefaults setObject:badgeStr forKey:KMessagebadge];
    [self.navigationController.tabBarItem setBadgeValue:badgeStr];
    [self.navigationItem.leftBarButtonItem setBadgeValue:badgeStr];
}


#pragma mark 设置界面属性
- (void)buildUI
{
    if (!_uid) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_write"] style:UIBarButtonItemStyleBordered target:self action:@selector(publishStatus)];
        
        // Build your regular UIBarButtonItem with Custom View
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
        NSInteger badge = [[UserDefaults objectForKey:KMessagebadge] integerValue];
        if (badge>0) {
            self.navigationItem.leftBarButtonItem.badgeValue = [UserDefaults objectForKey:KMessagebadge];
//            [self.navigationController.tabBarItem setBadgeValue:[UserDefaults objectForKey:KMessagebadge]];
        }
    }
    // 背景颜色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:WLLineColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, IWTableBorderWidth, 0);
}

#pragma mark - 消息页面
- (void)messageButtonPress:(id)sender
{
    BOOL isAllMessage = YES;
    if ([UserDefaults objectForKey:KMessagebadge]) {
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
    // 2.给cell传递模型数据
    // 传递的模型：文字数据 + 子控件frame数据
    cell.statusFrame = _dataArry[indexPath.row];
    [cell setHomeVC:self];
    
    // 赞
    [cell.dock.attitudeBtn addTarget:self action:@selector(attitudeBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    // 评论
    [cell.dock.commentBtn addTarget:self action:@selector(commentBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    // 更多
    [cell.moreBut addTarget:self action:@selector(moreClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
        CommentInfoController *commentInfo = [[CommentInfoController alloc] init];
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        [commentInfo setStatusFrame:statusF];
        [commentInfo setBeginEdit:YES];
        [self.navigationController pushViewController:commentInfo animated:YES];
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
    CommentInfoController *commentInfo = [[CommentInfoController alloc] init];
    [commentInfo setDelegate:self];
    WLStatusFrame *statusF = _dataArry[indexPath.row];
    [commentInfo setStatusFrame:statusF];
    _selectIndexPath = indexPath;
    [self.navigationController pushViewController:commentInfo animated:YES];
}

- (void)commentInfoController:(CommentInfoController *)commentVC isDelete:(BOOL)isdelete withStatusFrame:(WLStatusFrame *)statusF
{
    if (isdelete) {
        [_dataArry removeObject:statusF];
        [self.tableView deleteRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [_dataArry setObject:statusF atIndexedSubscript:_selectIndexPath.row];
        [self.tableView reloadRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
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
