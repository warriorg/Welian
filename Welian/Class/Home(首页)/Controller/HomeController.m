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
#import "NotstringView.h"

#import "WLPhoto.h"

@interface HomeController () <UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
   __block NSMutableArray *_dataArry;
    
    NSIndexPath *_clickIndex;
    NSNumber *_uid;
    NSIndexPath *_seletIndexPath;
    
    NSInteger _page;
}
@property (nonatomic, strong) HomeView *homeView;

@property (nonatomic, strong) NotstringView *notDataView;

@end

@implementation HomeController

- (NotstringView *)notDataView
{
    if (_notDataView == nil) {
        _notDataView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"你还没发布过动态"];
        [_notDataView setHidden:YES];
        [self.tableView addSubview:_notDataView];
    }
    return _notDataView;
}

- (HomeView *)homeView
{
    if (_homeView == nil) {
        _homeView = [[HomeView alloc] initWithFrame:self.tableView.frame];
        [_homeView setHomeController:self];
        [_homeView setHidden:YES];
        [self.tableView addSubview:_homeView];
    }
    return _homeView;
}

- (void)beginRefreshing
{
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //现实头部导航
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (instancetype)initWithUid:(NSNumber *)uid
{
    _uid = uid;
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.view addSubview:self.tableView];
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(beginPullDownRefreshing)];
        self.tableView.header.updatedTimeHidden = YES;
//        self.tableView.header.stateHidden = YES;
        [self.tableView.header beginRefreshing];
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.footer.hidden = YES;

        _dataArry = [NSMutableArray array];
        if (!_uid) {
            NSArray *againArray = [self getSendAgainStuatArray];
            [_dataArry addObjectsFromArray:againArray];
            NSArray *arrr  = [[WLDataDBTool sharedService] getAllItemsFromTable:KHomeDataTableName];
            [self loadFirstFID:[self dataFrameWith:[[arrr firstObject] itemObject]]];
            for (YTKKeyValueItem *aa in arrr) {
                WLStatusFrame *sf = [self dataFrameWith:aa.itemObject];
                [_dataArry addObject:sf];
            }
        }
    }
    return self;
}

#pragma mark - 取第一条ID保存
- (void)loadFirstFID:(WLStatusFrame *)statusF
{
    // 1.第一条微博的ID
    [LogInUser setUserFirststustid:@(statusF.status.fid)];
}

- (void)endRefreshing
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

- (void)beginPullDownRefreshing
{
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    _page = 1;
    if (_uid) {
        [darDic setObject:@(_page) forKey:@"page"];
        [darDic setObject:_uid forKey:@"uid"];        
    }else {
        [darDic setObject:@(0) forKey:@"start"];
    }
    
    [WLHttpTool loadFeedsParameterDic:darDic andLoadType:_uid success:^(id JSON) {
        
        NSArray *jsonarray = [NSArray arrayWithArray:JSON];
        if (!_uid) {
            [LogInUser setUserNewstustcount:@(0)];
        }
        // 1.在拿到最新微博数据的同时计算它的frame
        [_dataArry removeAllObjects];
        
        NSArray *againArray = [self getSendAgainStuatArray];
        [_dataArry addObjectsFromArray:againArray];
        
        for (NSDictionary *dic in jsonarray) {
             WLStatusFrame *sf = [self dataFrameWith:dic];
            [_dataArry addObject:sf];
        }
        _page++;
        if (!_uid) {
            [self loadFirstFID:[self dataFrameWith:[jsonarray firstObject]]];
            if (!_dataArry.count) {
                [self.homeView setHidden:NO];
            }else{
                [self.homeView setHidden:YES];
            }
        }else if(_uid.integerValue == 0){
            if (!_dataArry.count) {
                [self.notDataView setHidden:NO];
            }else{
                [self.notDataView setHidden:YES];
            }
        }
        [[MainViewController sharedMainViewController] updataItembadge];
        [self.tableView reloadData];

        [self endRefreshing];
        if (jsonarray.count<KCellConut) {
            [self.tableView.footer setHidden:YES];
        }else{
            [self.tableView.footer setHidden:NO];
        }
    } fail:^(NSError *error) {
        [self endRefreshing];
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
            IBaseUserM *mode = [IBaseUserM objectWithKeyValues:feeddic];
            [forwardsM addObject:mode];
        }
    }
    [statusM setForwardsArray:forwardsM];
    
    NSMutableArray *zanArrayM = [NSMutableArray array];
    if (zanarray.count) {
        for (NSDictionary *zandic in zanarray) {
            IBaseUserM *mode = [IBaseUserM objectWithKeyValues:zandic];
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
    NSArray *joinedusers = [statusDic objectForKey:@"joinedusers"];
    NSMutableArray *joinArrayM = [NSMutableArray array];
    if (statusM.type==5||statusM.type==12) {
        IBaseUserM *meInfoM = [[IBaseUserM alloc] init];
        meInfoM.name = statusM.user.name;
        meInfoM.uid = statusM.user.uid;
        meInfoM.avatar = statusM.user.avatar;
        [joinArrayM addObject:meInfoM];
        
        if (joinedusers.count) {
            for (NSDictionary *joDic in joinedusers) {
                IBaseUserM *joMode = [IBaseUserM objectWithKeyValues:joDic];
                [joinArrayM addObject:joMode];
            }
        }
    }
    [statusM setJoineduserArray:joinArrayM];
    
    WLStatusFrame *sf = [[WLStatusFrame alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-60];
    sf.status = statusM;
    return sf;
}

#pragma mark 加载更多数据
- (void)loadMoreData
{
    NSMutableDictionary *darDic = [NSMutableDictionary dictionary];
    [darDic setObject:@(KCellConut) forKey:@"size"];
    if (_uid) {
        [darDic setObject:_uid forKey:@"uid"];
        [darDic setObject:@(_page) forKey:@"page"];
    }else{
        // 1.最后1条微博的ID
        WLStatusFrame *f = [_dataArry lastObject];
        int start = f.status.fid;
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
        _page++;
        [self.tableView reloadData];
        
        [self endRefreshing];
        if (jsonarray.count<KCellConut) {
            [self.tableView.footer setHidden:YES];
        }
    } fail:^(NSError *error) {
        [self endRefreshing];
    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [KNSNotification addObserver:self selector:@selector(beginPullDownRefreshing) name:KPublishOK object:nil];
    
    [KNSNotification addObserver:self selector:@selector(messageHomenotif) name:KMessageHomeNotif object:nil];
    
    //刷新所有好友通知
    [KNSNotification addObserver:self selector:@selector(loadMyAllFriends) name:KupdataMyAllFriends object:nil];
    
    // 1.设置界面属性
    [self buildUI];
    
    // 获取所有好友
    [self loadMyAllFriends];
    
    //每次程序启动获取一次活动里面的城市列表
    [self loadAcitvityCitys];
}

- (void)dealloc
{
    [KNSNotification removeObserver:self];
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
    if (!_uid||(_uid!=nil &&_uid.integerValue==0)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_write"] style:UIBarButtonItemStyleBordered target:self action:@selector(publishStatus)];
    }
    // 背景颜色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:WLLineColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, IWTableBorderWidth, 0);
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self showStatusNotReachable];
        }else{
            [self beginPullDownRefreshing];
            self.tableView.tableHeaderView = nil;
        }
    }];

}

/**
 *  显示最新微博的数量（提示）
 */
- (void)showStatusNotReachable
{
    // 1.创建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    btn.backgroundColor = RGB(255, 238, 238);
    [btn setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    // 3.设置文字
    [btn setTitle:@"网络无法连接，请检查网络配置" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    // 4.设置frame
    CGFloat btnW = self.view.frame.size.width;
    CGFloat btnH = 44;
    CGFloat btnY = 64 - btnH;
    btn.frame = CGRectMake(0, btnY, btnW, btnH);
    
    // 5.添加按钮
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 6.执行动画
    // 6.1.利用1s往下走
    CGFloat duration = 0.7;
    [UIView animateWithDuration:duration animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, btnH);
    } completion:^(BOOL finished) {
        [self.tableView setTableHeaderView:btn];
    }];
}

#pragma mark - 发表状态
- (void)publishStatus
{
    PublishStatusController *publishVC = [[PublishStatusController alloc] init];
    publishVC.publishDicBlock = ^(NSDictionary *reqDataDic, NSString *fidStr){
        [self sendAgainStuat:reqDataDic withFidStr:fidStr];
    };
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
    
    // 重新发送
    [cell.contentAndDockView.dock.sendAgainBtn addTarget:self action:@selector(sendAgainBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    // 更多
    [cell.moreBut addTarget:self action:@selector(moreClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 重新发送按钮
- (void)sendAgainBtnClick:(UIButton*)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath)
    {
        WLStatusFrame *statusF = _dataArry[indexPath.row];
        YTKKeyValueItem *itemDic = [[WLDataDBTool sharedService] getYTKKeyValueItemById:statusF.status.sendId fromTable:KSendAgainDataTableName];
        [self sendStuat:itemDic.itemObject withIndexPath:indexPath];
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
        if (statuF.status.type==13) { // 删除自己发布的
            [[WLDataDBTool sharedService] deleteObjectById:statuF.status.sendId fromTable:KSendAgainDataTableName];
            [_dataArry removeObject:statuF];
            [self.tableView deleteRowsAtIndexPaths:@[_clickIndex] withRowAnimation:UITableViewRowAnimationFade];
            if (_uid) {
                [self.notDataView setHidden:_dataArry.count];
            }else{
                [self.homeView setHidden:_dataArry.count];
            }
        }else{
            [WLHttpTool deleteFeedParameterDic:@{@"fid":@(statuF.status.fid)} success:^(id JSON) {
                
                [_dataArry removeObject:statuF];
                [self.tableView deleteRowsAtIndexPaths:@[_clickIndex] withRowAnimation:UITableViewRowAnimationFade];
                if (_uid) {
                    [self.notDataView setHidden:_dataArry.count];
                }else{
                    [self.homeView setHidden:_dataArry.count];
                }
            } fail:^(NSError *error) {
                
            }];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataArry[indexPath.row] cellHigh]+5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataArry[indexPath.row] cellHigh]+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self pushCommentInfoVC:indexPath];
}

#pragma mark - 进入详情页
- (void)pushCommentInfoVC:(NSIndexPath*)indexPath
{
    WLStatusFrame *statusF = _dataArry[indexPath.row];
    
    if (statusF.status.type==2 ||statusF.status.type==4 || statusF.status.type==5||statusF.status.type==6||statusF.status.type==12 || statusF.status.type ==13) return;
    
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

//加载好友列表
-(void)loadMyAllFriends
{
    LogInUser *nowLoginUser = [LogInUser getCurrentLoginUser];
    if(nowLoginUser){
        //获取好友列表
        [WeLianClient getFriendListWithID:nowLoginUser.uid
                                  Success:^(id resultInfo) {
                                      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                          NSArray *myFriends = [nowLoginUser getAllMyFriendUsers];
                                          //循环，删除本地数据库多余的缓存数据
                                          for (int i = 0; i < [myFriends count]; i++){
                                              MyFriendUser *myFriendUser = myFriends[i];
                                              //判断返回的数组是否包含
                                              BOOL isHave = [resultInfo bk_any:^BOOL(id obj) {
                                                  //判断是否包含对应的
                                                  return [[obj uid] integerValue] == [myFriendUser uid].integerValue;
                                              }];
                                              //删除新的好友本地数据库
                                              NewFriendUser *newFuser = [nowLoginUser getNewFriendUserWithUid:myFriendUser.uid];
                                              //本地不存在，不是好友关系
                                              if(!isHave){
                                                  if (newFuser) {
                                                      //更新好友请求列表数据为 添加
                                                      [newFuser updateOperateType:0];
                                                  }
                                                  
                                                  //如果uid大于100的为普通好友，刷新的时候可以删除本地，系统好友，保留
                                                  if(myFriendUser.uid.integerValue > 100){
                                                      //不包含，删除当前数据
                                                      //                    [myFriendUser MR_deleteEntityInContext:nowLoginUser.managedObjectContext];
                                                      //更新设置为不是我的好友
                                                      [myFriendUser updateIsNotMyFriend];
                                                  }
                                              }else{
                                                  //好友
                                                  if (newFuser) {
                                                      //更新好友请求列表数据为 添加
                                                      [newFuser updateOperateType:2];
                                                  }
                                              }
                                          }
                                          
                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                              NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"isNow",@(YES)];
                                              LogInUser *loginUser = [LogInUser MR_findFirstWithPredicate:pre inContext:localContext];
                                              
                                              //循环添加数据库数据
                                              for (IBaseUserM *baseUser in resultInfo) {
                                                  baseUser.friendship = @(1);//设置为好友关系
                                                  
                                                  NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",loginUser,@"uid",baseUser.uid];
                                                  MyFriendUser *myFriend = [MyFriendUser MR_findFirstWithPredicate:pre inContext:localContext];
                                                  if (!myFriend) {
                                                      myFriend = [MyFriendUser MR_createEntityInContext:localContext];
                                                  }
                                                  myFriend.uid = baseUser.uid;
                                                  myFriend.name = baseUser.name;
                                                  myFriend.avatar = baseUser.avatar;
                                                  myFriend.company = baseUser.company;
                                                  myFriend.position = baseUser.position;
                                                  myFriend.investorauth = baseUser.investorauth;
                                                  myFriend.friendship = baseUser.friendship;
                                                  myFriend.checked = baseUser.checked;
                                                  myFriend.mobile = baseUser.mobile;
                                                  myFriend.cityname = baseUser.cityname;
                                                  myFriend.isMyFriend = @(YES);
                                                  [loginUser addRsMyFriendsObject:myFriend];
                                              }
                                              
                                          } completion:^(BOOL contextDidSave, NSError *error) {
                                          }];
                                      });
                                  } Failed:^(NSError *error) {
//                                      [self.refreshControl endRefreshing];
//                                      [WLHUDView hiddenHud];
                                  }];
        
        
        
//        [WLHttpTool loadFriendWithSQL:NO ParameterDic:@{@"uid":@(0)} success:^(id JSON) {
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSArray *myFriends = [nowLoginUser getAllMyFriendUsers];
//                NSArray  *json = [NSArray arrayWithArray:JSON];
//                //循环，删除本地数据库多余的缓存数据
//                for (int i = 0; i < [myFriends count]; i++){
//                    MyFriendUser *myFriendUser = myFriends[i];
//                    //判断返回的数组是否包含
//                    BOOL isHave = [json bk_any:^BOOL(id obj) {
//                        //判断是否包含对应的
//                        return [[obj objectForKey:@"uid"] integerValue] == [myFriendUser uid].integerValue;
//                    }];
//                    //删除新的好友本地数据库
//                    NewFriendUser *newFuser = [nowLoginUser getNewFriendUserWithUid:myFriendUser.uid];
//                    //本地不存在，不是好友关系
//                    if(!isHave){
//                        if (newFuser) {
//                            //更新好友请求列表数据为 添加
//                            [newFuser updateOperateType:0];
//                        }
//                        
//                        //如果uid大于100的为普通好友，刷新的时候可以删除本地，系统好友，保留
//                        if(myFriendUser.uid.integerValue > 100){
//                            //不包含，删除当前数据
//                            //                    [myFriendUser MR_deleteEntityInContext:nowLoginUser.managedObjectContext];
//                            //更新设置为不是我的好友
//                            [myFriendUser updateIsNotMyFriend];
//                        }
//                    }else{
//                        //好友
//                        if (newFuser) {
//                            //更新好友请求列表数据为 添加
//                            [newFuser updateOperateType:2];
//                        }
//                    }
//                }
//                
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"isNow",@(YES)];
//                        LogInUser *loginUser = [LogInUser MR_findFirstWithPredicate:pre inContext:localContext];
//                        
//                        //循环添加数据库数据
//                        for (NSDictionary *modic in json) {
//                            FriendsUserModel *friendM = [FriendsUserModel objectWithKeyValues:modic];
//                            friendM.friendship = @(1);
//                            
//                            NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",loginUser,@"uid",friendM.uid];
//                            MyFriendUser *myFriend = [MyFriendUser MR_findFirstWithPredicate:pre inContext:localContext];
//                            if (!myFriend) {
//                                myFriend = [MyFriendUser MR_createEntityInContext:localContext];
//                            }
//                            myFriend.uid = friendM.uid;
//                            myFriend.mobile = friendM.mobile;
//                            myFriend.position = friendM.position;
//                            myFriend.provinceid = friendM.provinceid;
//                            myFriend.provincename = friendM.provincename;
//                            myFriend.cityid = friendM.cityid;
//                            myFriend.cityname = friendM.cityname;
//                            myFriend.friendship = friendM.friendship;
//                            myFriend.shareurl = friendM.shareurl;
//                            myFriend.avatar = friendM.avatar;
//                            myFriend.name = friendM.name;
//                            myFriend.address = friendM.address;
//                            myFriend.email = friendM.email;
//                            myFriend.investorauth = friendM.investorauth;
////                            myFriend.startupauth = friendM.startupauth;
//                            myFriend.company = friendM.company;
//                            myFriend.status = friendM.status;
//                            myFriend.isMyFriend = @(YES);
//                            [loginUser addRsMyFriendsObject:myFriend];
//                        }
//                        
//                    } completion:^(BOOL contextDidSave, NSError *error) {
//
//                    }];
//                    
//                });
//            });
//            
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [WLHUDView hiddenHud];
//        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

//获取活动城市列表
- (void)loadAcitvityCitys
{
    [WeLianClient getActiveCitiesSuccess:^(id resultInfo) {
        if ([resultInfo count] > 0) {
            NSArray *citys = [NSArray arrayWithArray:resultInfo];
            //写入到本地
            BOOL state = [citys writeToFile:[[ResManager documentPath] stringByAppendingString:@"/ActivityCitys.plist"] atomically:YES];
            if (state == YES) {
                DLog(@"getActiveCities write successfully");
            }else{
                DLog(@"getActiveCities fail to write");
            }
        }
    } Failed:^(NSError *error) {
        DLog(@"getActiveCities error:%@",error.description);
    }];
//    [WLHttpTool getActiveCitiesParameterDic:[NSDictionary dictionary]
//                                    success:^(id JSON) {
//                                        NSArray *citys = [NSArray arrayWithArray:JSON];
//                                        //写入到本地
//                                        BOOL state = [citys writeToFile:[[ResManager documentPath] stringByAppendingString:@"/ActivityCitys.plist"] atomically:YES];
//                                        if (state == YES) {
//                                            DLog(@"write successfully");
//                                        }else{
//                                            DLog(@"fail to write");
//                                        }
//                                    } fail:^(NSError *error) {
//                                        DLog(@"getActiveCitiesParameterDic error:%@",error.description);
//                                    }];
}

#pragma mark - 加载缓存重新发送的动态
- (NSMutableArray *)getSendAgainStuatArray
{
    NSMutableArray *sendFrameArray = [NSMutableArray array];
    
    if (!_uid) {
        NSArray *arrr  = [[WLDataDBTool sharedService] getAllItemsFromTable:KSendAgainDataTableName];
        
        for (YTKKeyValueItem *aa in arrr) {
            WLStatusFrame *sf = [self relodStatusFrameWithDic:aa.itemObject withFidStr:aa.itemId];
            [sendFrameArray addObject:sf];
        }
    }
    
    return sendFrameArray;
}


#pragma mark - 重新发布动态
- (void)sendAgainStuat:(NSDictionary *)reqDataDic withFidStr:(NSString *)fidStr
{
    WLStatusFrame *newsf = [self relodStatusFrameWithDic:reqDataDic withFidStr:fidStr];
    [_dataArry insertObject:newsf atIndex:0];
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self sendStuat:reqDataDic withIndexPath:indexPath];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (WLStatusFrame *)relodStatusFrameWithDic:(NSDictionary *)reqDataDic withFidStr:(NSString *)fidStr
{
    LogInUser *meuser = [LogInUser getCurrentLoginUser];
    NSArray *photsArray = [reqDataDic objectForKey:@"photos"];
    NSMutableArray *photosA = [NSMutableArray array];
    for (NSDictionary *imageDic in photsArray) {
        NSData *photoData = [[NSData alloc] initWithBase64EncodedString:[imageDic objectForKey:@"photo"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        [photosA addObject:@{@"imageData":photoData}];
    }
    NSMutableDictionary *frameDic = [NSMutableDictionary dictionaryWithDictionary:reqDataDic];
    [frameDic setObject:photosA forKey:@"photos"];
    
    WLStatusFrame *newsf = [self dataFrameWith:frameDic];
    WLStatusM *statusM = newsf.status;
    statusM.sendId = fidStr;
    statusM.sendType = 1;
    statusM.type = 13;
    WLBasicTrends *meBasic =  [[WLBasicTrends alloc] init];
    meBasic.name = meuser.name;
    meBasic.avatar = meuser.avatar;
    meBasic.uid = meuser.uid;
    meBasic.position = meuser.position;
    meBasic.company = meuser.company;
    meBasic.friendship = meuser.firststustid.intValue;
    statusM.user = meBasic;
    newsf.status = statusM;
    return newsf;
}


- (void)sendStuat:(NSDictionary *)reqDataDic withIndexPath:(NSIndexPath *)indexPath
{
    WLStatusFrame *statusFrame = _dataArry[indexPath.row];
    WLStatusM *statusM = statusFrame.status;
    statusM.sendType = 2;
    statusFrame.status = statusM;
    [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusFrame];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WEAKSELF
    [WLHttpTool addFeedParameterDic:reqDataDic success:^(id JSON) {
        [[WLDataDBTool sharedService] deleteObjectById:statusFrame.status.sendId fromTable:KSendAgainDataTableName];
        [weakSelf beginPullDownRefreshing];
    } fail:^(NSError *error) {
        
        WLStatusM *statusM = statusFrame.status;
        statusM.sendType = 1;
        statusFrame.status = statusM;
        [_dataArry replaceObjectAtIndex:indexPath.row withObject:statusFrame];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [WLHUDView showErrorHUD:@"发布失败！"];
    }];
}
@end
