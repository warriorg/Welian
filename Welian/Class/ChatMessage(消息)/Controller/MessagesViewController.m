//
//  MessagesViewController.m
//  Welian
//
//  Created by weLian on 15/3/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MessagesViewController.h"
#import "WLCustomSegmentedControl.h"
#import "NotstringView.h"
#import "ChatMessageViewCell.h"
#import "ChatViewController.h"
#import "CommentInfoController.h"
#import "ProjectDetailsViewController.h"
#import "UserInfoViewController.h"

#import "MessageCell.h"
#import "NewFriendViewCell.h"

#import "MessageFrameModel.h"
#import "WLStatusM.h"

@interface MessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) WLCustomSegmentedControl *wlSegmentedControl;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) NotstringView *notHasDataView;//无消息提醒
@property (assign,nonatomic) NSInteger selectType;//选择的类型
@property (assign,nonatomic) BOOL isLookedMessage;//已经查看了消息

@end

@implementation MessagesViewController

- (void)dealloc
{
    [KNSNotification removeObserver:self];
}

//没有聊天记录提醒
- (NotstringView *)notHasDataView
{
    if (!_notHasDataView) {
        _notHasDataView = [[NotstringView alloc] initWithFrame:CGRectMake(0.f, ViewCtrlTopBarHeight, self.view.width, self.view.height - ViewCtrlTopBarHeight) withTitStr:@"没有消息记录" andImageName:@"remind_big_nostring"];
    }
    return _notHasDataView;
}

- (WLCustomSegmentedControl *)wlSegmentedControl
{
    if (!_wlSegmentedControl) {
        _wlSegmentedControl = [[WLCustomSegmentedControl alloc] initWithSectionTitles:@[@"聊天", @"消息",@"好友通知"]];
        _wlSegmentedControl.frame = CGRectMake(0, StatusBarHeight, self.view.width, NaviBarHeight - 0.5);
        _wlSegmentedControl.selectedTextColor = [UIColor whiteColor];
        _wlSegmentedControl.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        _wlSegmentedControl.selectionIndicatorColor = [UIColor whiteColor];
        _wlSegmentedControl.selectionIndicatorHeight = 2;
        _wlSegmentedControl.backgroundColor = kNavBgColor;
        _wlSegmentedControl.showBottomLine = YES;
        _wlSegmentedControl.font = kNormalBlod16Font;
    }
    return _wlSegmentedControl;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //添加聊天用户改变监听
        [KNSNotification addObserver:self selector:@selector(badgeInfoChanged) name:kChatUserChanged object:nil];
        //添加聊天消息数量改变监听
        [KNSNotification addObserver:self selector:@selector(badgeInfoChanged) name:kChatMsgNumChanged object:nil];
        //新的好友改变通知
        [KNSNotification addObserver:self selector:@selector(badgeInfoChanged) name:KNewFriendNotif object:nil];
        //添加新的消息通知
        [KNSNotification addObserver:self selector:@selector(badgeInfoChanged) name:KMessageHomeNotif object:nil];
        //如果是从好友列表进入聊天，首页变换
        [KNSNotification addObserver:self selector:@selector(chatFromUserInfo:) name:kChatFromUserInfo object:nil];
        
        //如果是从当前VC进入聊天
        [KNSNotification addObserver:self selector:@selector(currentChatFromUserInfo:) name:kCurrentChatFromUserInfo object:nil];
        
        self.selectType= 0;
        self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
        self.showCustomNavHeader = YES;//隐藏头部
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ViewCtrlTopBarHeight)];
    headerView.backgroundColor = kNavBgColor;
    [self.view addSubview:headerView];
    [headerView addSubview:self.wlSegmentedControl];
    
    WEAKSELF
    [self.wlSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf selectIndexChanged:index];
    }];
    
    //表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, ViewCtrlTopBarHeight, self.view.width, self.view.height - ViewCtrlTopBarHeight - TabBarHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate  = self;
    //隐藏分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView setDebug:YES];
    
    //添加提醒页面
    [self.tableView addSubview:self.notHasDataView];
    [self.tableView sendSubviewToBack:self.notHasDataView];
    
    //设置默认选择的和设置角标
    [self badgeInfoChanged];
//    [self selectIndexChanged:_selectType];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_selectType) {
        case 1:
        {
            MessageCell *cell = [MessageCell cellWithTableView:tableView];
            MessageFrameModel *messageFrameModel = _datasource[indexPath.row];
            cell.messageFrameModel = messageFrameModel;
//            cell.layer.borderColorFromUIColor = RGB(231.f, 231.f, 231.f);
//            cell.layer.borderWidths = @"{0,0,0.5,0}";
            return cell;
        }
            break;
        case 2:
        {
            static NSString *CELL_Identifier = @"New_Friend_Cell";
            NewFriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_Identifier];
            if (!cell) {
                cell = [[NewFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_Identifier];
            }
            cell.indexPath = indexPath;
            cell.nFriendUser = _datasource[indexPath.row];
            WEAKSELF
            [cell setNewFriendBlock:^(FriendOperateType type,NewFriendUser *newFriendUser,NSIndexPath *indexPath){
                [weakSelf newFriendOperate:type newFriendUser:newFriendUser indexPath:indexPath];
            }];
            return cell;
        }
            break;
        default:
        {
            static NSString *CELL_Identifier = @"Message_ViewCell";
            ChatMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_Identifier];
            if (!cell) {
                cell = [[ChatMessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_Identifier];
            }
            cell.myFriendUser = _datasource[indexPath.row];
            //    [cell setDebug:YES];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (_selectType) {
        case 1:
        {
            MessageFrameModel *messageFrameModel = _datasource[indexPath.row];
            HomeMessage *messagedata = messageFrameModel.messageDataM;
            //更新查看状态
            [messagedata updateHomeMessageIsLook];
//            [self selectIndexChanged:1];
            //刷新当前行为已读
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if ([messagedata.type isEqualToString:@"projectComment"]||[messagedata.type isEqualToString:@"projectCommentZan"]) {
                //进入项目详情
                //查询数据库是否存在
                ProjectInfo *projectInfo = [ProjectInfo getProjectInfoWithPid:messagedata.feedid Type:@(0)];
                ProjectDetailsViewController *projectDetailVC = nil;
                if (projectInfo) {
                    projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectInfo:projectInfo];
                }else{
                    projectDetailVC = [[ProjectDetailsViewController alloc] initWithProjectPid:messagedata.feedid];
                }
                [self.navigationController pushViewController:projectDetailVC animated:YES];
            }else{
                //动态详情
                YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:[NSString stringWithFormat:@"%@",messagedata.feedid] fromTable:KWLStutarDataTableName];
                
                WLStatusM *statusM = [WLStatusM objectWithKeyValues:item.itemObject];
                [statusM setFid:messagedata.feedid];
                [statusM setTopid:messagedata.feedid];
                CommentInfoController *commentVC = [[CommentInfoController alloc] init];
                [commentVC setStatusM:statusM];
                [self.navigationController pushViewController:commentVC animated:YES];
            }
        }
            break;
        case 2:
        {
            NewFriendUser *friendM = _datasource[indexPath.row];
            NSNumber *opereateType = nil;
            if ([friendM.operateType integerValue] == 1 ||[friendM.pushType isEqualToString:@"friendCommand"]) {
                opereateType = @(1);
            }else{
                opereateType = friendM.operateType;
            }
//            UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:(IBaseUserM *)friendM isAsk:isask];
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:(IBaseUserM *)friendM OperateType:opereateType HidRightBtn:NO];
            [self.navigationController pushViewController:userInfoVC animated:YES];
//            [userInfoVC setNeedlessCancel:YES];
            WEAKSELF
            userInfoVC.acceptFriendBlock = ^(){
                [weakSelf newFriendOperate:FriendOperateTypeAccept newFriendUser:friendM indexPath:indexPath];
                //        [weakUserInfoVC addSucceed];
            };
        }
            break;
        default:
        {
            //进入聊天页面
            MyFriendUser *friendUser = _datasource[indexPath.row];
            //更新当前未查看消息数量
            [friendUser updateUnReadMessageNumber:@(0)];
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:friendUser];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectType) {
        case 1:
        {
            if (_datasource.count > 0) {
                MessageFrameModel *messageFrameModel = _datasource[indexPath.row];
                return messageFrameModel.cellHigh;
            }else{
                return 60.f;
            }
        }
            break;
        case 2:
        {
            if (_datasource.count > 0) {
                NewFriendUser *friendUser = _datasource[indexPath.row];
                return [NewFriendViewCell configureWithName:friendUser.name message:friendUser.msg];
            }else{
                return 60.f;
            }
        }
            break;
        default:
            return 60.f;
            break;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (_selectType) {
            case 0:
            {
                //修改聊天状态
                MyFriendUser *friendUser = _datasource[indexPath.row];
                [friendUser updateIsChatStatus:NO];
                
                //更新当前聊天的所有消息为已读状态
                //        [friendUser updateAllMessageReadStatus];
                [friendUser updateUnReadMessageNumber:@(0)];
            }
                break;
            case 1:
            {
                MessageFrameModel *messageFrameModel = _datasource[indexPath.row];
                HomeMessage *messagedata = messageFrameModel.messageDataM;
                [messagedata MR_deleteEntity];
            }
                break;
            case 2:
            {
                NewFriendUser *friendM = _datasource[indexPath.row];
                //删除本地数据库数据
                [friendM MR_deleteEntity];
            }
                break;
            default:
                break;
        }
        [self badgeInfoChanged];
//        NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
//        [allDatas removeObjectAtIndex:indexPath.row];
//        self.datasource = [NSArray arrayWithArray:allDatas];
//        //移除tableView中的数据
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - private
- (void)selectIndexChanged:(NSInteger)index
{
    //设置是否在新的好友通知页面
    [UserDefaults setBool:NO forKey:kIsLookAtNewFriendVC];
    //改变普通消息的查看状态
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    if (_isLookedMessage) {
        //更新状态
        [loginUser updateALLNotLookMessages];
    }
    
    //更新待验证的好友状态
    [loginUser updateAllNewFriendsOperateStatus];
    
    //设置未查看普通消息
    self.isLookedMessage = NO;
    self.selectType = index;
    switch (_selectType) {
        case 0:
        {
            [self loadChatMessageData];
        }
            break;
        case 1:
        {
            //更新角标
            self.isLookedMessage = YES;
            loginUser.homemessagebadge = @(0);
            //更新角标
            [self currentBadgeChanged];
            [self loadMessageData];
        }
            break;
        case 2:
        {
            //设置角标改变
            [self setNewUserBadgeChange];
            [self loadNewFriendData];
        }
            break;
        default:
            break;
    }
}

- (void)setNewUserBadgeChange
{
    //设置是否在新的好友通知页面
    [UserDefaults setBool:YES forKey:kIsLookAtNewFriendVC];
    //设置新的好友角标
    [LogInUser setUserNewfriendbadge:@(0)];
    
    [self currentBadgeChanged];
}

//当前页面角标改变
- (void)currentBadgeChanged
{
    //更新主页面总的角标
    [KNSNotification postNotificationName:kUpdateMainMessageBadge object:nil];
    //更新当前列表角标
    [self updateCurrentBadgeInfo];
}

//获取好友消息
- (void)loadNewFriendData
{
    //加载数据
    self.datasource = [NSMutableArray arrayWithArray:[[LogInUser getCurrentLoginUser] allMyNewFriends]];
    if (_datasource.count > 0) {
        _notHasDataView.hidden = YES;
    }else{
        _notHasDataView.hidden = NO;
    }
    [_tableView reloadData];
}

//获取普通消息
- (void)loadMessageData
{
    NSArray *messages = [[LogInUser getCurrentLoginUser] getAllMessages];
    NSMutableArray *messageModels = [NSMutableArray array];
    for (HomeMessage *homeM  in messages) {
//        if (!homeM.isLook.boolValue) {
////            homeM.isLook = @(1);
//            
//        }
        MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
        messageFrameM.messageDataM = homeM;
        [messageModels addObject:messageFrameM];
    }
    self.datasource = [NSArray arrayWithArray:messageModels];
    
    if (_datasource.count > 0) {
        _notHasDataView.hidden = YES;
    }else{
        _notHasDataView.hidden = NO;
    }
    [_tableView reloadData];
}

//获取聊天消息
- (void)loadChatMessageData
{
    self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    
    if (_datasource.count > 0) {
        _notHasDataView.hidden = YES;
    }else{
        _notHasDataView.hidden = NO;
    }
    [_tableView reloadData];
}

//聊天列表改变
- (void)chatUsersChanged:(NSNotification *)notification
{
    self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    
    if (_datasource.count > 0) {
        _notHasDataView.hidden = YES;
    }else{
        _notHasDataView.hidden = NO;
    }
    [_tableView reloadData];
}

//从用户信息中发送消息
- (void)chatFromUserInfo:(NSNotification *)notification
{
    //切换首页Tap
    [KNSNotification postNotificationName:kChangeTapToChatList object:nil];
    
    //切换到聊天列表也没
    [_wlSegmentedControl setSelectedSegmentIndex:0];
    [self selectIndexChanged:0];
    
    NSNumber *uid = @([[[notification userInfo] objectForKey:@"uid"] integerValue]);
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    MyFriendUser *user = [loginUser getMyfriendUserWithUid:uid];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:chatVC animated:YES];
}

//当前VC tab切换聊天
- (void)currentChatFromUserInfo:(NSNotification *)notification
{
    //切换到聊天列表也没
    [_wlSegmentedControl setSelectedSegmentIndex:0 animated:YES];
    [self selectIndexChanged:0];
    
//    NSNumber *uid = @([[[notification userInfo] objectForKey:@"uid"] integerValue]);
//    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
//    MyFriendUser *user = [loginUser getMyfriendUserWithUid:uid];
//    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
//    [self.navigationController pushViewController:chatVC animated:YES];
}

//角标改变
- (void)badgeInfoChanged
{
    //更新角标
    [self updateCurrentBadgeInfo];
    //更新数据
    [self selectIndexChanged:_selectType];
}

- (void)updateCurrentBadgeInfo
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    //聊天
    NSInteger unReadChatMsg = [loginUser allUnReadChatMessageNum];
    //设置角标
    _wlSegmentedControl.sectionBadges = @[@(unReadChatMsg),loginUser.homemessagebadge,loginUser.newfriendbadge];
}

/**
 *  新的好友关系操作
 *
 *  @param type          按钮操作类型
 *  @param newFriendUser 新的好友对象
 *  @param indexPath     对应的tableview
 */
- (void)newFriendOperate:(FriendOperateType)type newFriendUser:(NewFriendUser *)newFriendUser indexPath:(NSIndexPath *)indexPath
{
    if (type == FriendOperateTypeAdd) {
        //添加好友，发送添加成功，状态变成待验证
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",newFriendUser.name]];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
        [alert bk_addButtonWithTitle:@"取消" handler:nil];
        [alert bk_addButtonWithTitle:@"发送" handler:^{
            //发送好友请求
            [WeLianClient requestAddFriendWithID:newFriendUser.uid
                                         Message:[alert textFieldAtIndex:0].text
                                         Success:^(id resultInfo) {
                                             //发送邀请成功，修改状态，刷新列表
                                             NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeWait];
                                             
                                             //改变数组，刷新列表
                                             NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
                                             [allDatas replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
                                             self.datasource = [NSArray arrayWithArray:allDatas];
                                             //刷新列表
                                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                         } Failed:^(NSError *error) {
                                             
                                         }];
//            [WLHttpTool requestFriendParameterDic:@{@"fid":newFriendUser.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
//                //发送邀请成功，修改状态，刷新列表
//                NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeWait];
//                
//                //改变数组，刷新列表
//                NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
//                [allDatas replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
//                self.datasource = [NSArray arrayWithArray:allDatas];
//                //刷新列表
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            } fail:^(NSError *error) {
//                
//            }];
        }];
        [alert show];
    }
    
    if (type == FriendOperateTypeAccept) {
        //接受好友请求
        [WeLianClient confirmAddFriendWithID:newFriendUser.uid
                                     Success:^(id resultInfo) {
                                         [newFriendUser setIsAgree:@(1)];
                                         //更新好友列表数据库
                                         MyFriendUser *myFriendUser = [MyFriendUser createWithNewFriendUser:newFriendUser];
                                         
                                         //发送邀请成功，修改状态，刷新列表
                                         NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeAdded];
                                         //            if (self.userBasicVC) {
                                         //                [self.userBasicVC addSucceed];
                                         //            }
                                         //改变数组，刷新列表
                                         NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
                                         [allDatas replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
                                         
                                         self.datasource = [NSArray arrayWithArray:allDatas];
                                         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                         
                                         //刷新好友列表
                                         [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
                                         
                                         //通知接受好友请求
                                         [KNSNotification postNotificationName:[NSString stringWithFormat:kAccepteFriend,newFriendUser.uid] object:nil];
                                         
                                         //接受后，本地创建一条消息
                                         //本地创建好像
                                         [ChatMessage createChatMessageForAddFriend:myFriendUser];
                                         
                                         [WLHUDView showSuccessHUD:@"添加成功！"];
                                     } Failed:^(NSError *error) {
                                         
                                     }];
        
//        [WLHttpTool addFriendParameterDic:@{@"fid":newFriendUser.uid} success:^(id JSON) {
//            
//            [newFriendUser setIsAgree:@(1)];
//            //更新好友列表数据库
//            MyFriendUser *myFriendUser = [MyFriendUser createWithNewFriendUser:newFriendUser];
//            
//            //发送邀请成功，修改状态，刷新列表
//            NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeAdded];
////            if (self.userBasicVC) {
////                [self.userBasicVC addSucceed];
////            }
//            //改变数组，刷新列表
//            NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
//            [allDatas replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
//            
//            self.datasource = [NSArray arrayWithArray:allDatas];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//            //刷新好友列表
//            [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
//            
//            //通知接受好友请求
//            [KNSNotification postNotificationName:[NSString stringWithFormat:kAccepteFriend,newFriendUser.uid] object:nil];
//            
//            //接受后，本地创建一条消息
//            //本地创建好像
//            [ChatMessage createChatMessageForAddFriend:myFriendUser];
//            
//            [WLHUDView showSuccessHUD:@"添加成功！"];
//        } fail:^(NSError *error) {
//            
//        }];
    }
}

@end
