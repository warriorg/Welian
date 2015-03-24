//
//  MessagesViewController.m
//  Welian
//
//  Created by weLian on 15/3/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MessagesViewController.h"
#import "HMSegmentedControl.h"
#import "NotstringView.h"
#import "ChatMessageViewCell.h"
#import "ChatViewController.h"
#import "CommentInfoController.h"
#import "ProjectDetailsViewController.h"
#import "UserInfoBasicVC.h"

#import "MessageCell.h"
#import "NewFriendViewCell.h"

#import "MessageFrameModel.h"
#import "WLStatusM.h"

@interface MessagesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (assign,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) NotstringView *notHasDataView;//无消息提醒
@property (assign,nonatomic) NSInteger selectType;//选择的类型

@end

@implementation MessagesViewController

//没有聊天记录提醒
- (NotstringView *)notHasDataView
{
    if (!_notHasDataView) {
        _notHasDataView = [[NotstringView alloc] initWithFrame:CGRectMake(0.f, ViewCtrlTopBarHeight, self.view.width, self.view.height - ViewCtrlTopBarHeight) withTitStr:@"没有消息记录" andImageName:@"remind_big_nostring"];
    }
    return _notHasDataView;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, StatusBarHeight, self.view.width, NaviBarHeight - 0.5)];
        _segmentedControl.sectionTitles = @[@"聊天", @"消息",@"好友通知"];
        _segmentedControl.selectedTextColor = [UIColor whiteColor];
        _segmentedControl.textColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorHeight = 2;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.backgroundColor = kNavBgColor;
    }
    return _segmentedControl;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //添加聊天用户改变监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatUsersChanged:) name:@"ChatUserChanged" object:nil];
        //添加聊天消息数量改变监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeInfoChanged) name:@"ChatMsgNumChanged" object:nil];
        
        //如果是从好友列表进入聊天，首页变换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatFromUserInfo:) name:@"ChatFromUserInfo" object:nil];
        
        self.selectType= 0;
        self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
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
    [headerView addSubview:self.segmentedControl];
    
    WEAKSELF
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf selectIndexChanged:index];
    }];
    
    //设置角标
    [self badgeInfoChanged];
    
    //表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, ViewCtrlTopBarHeight, self.view.width, self.view.height - ViewCtrlTopBarHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate  = self;
    //隐藏分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //设置默认选择的
    [self selectIndexChanged:_selectType];
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
                [statusM setFid:[messagedata.feedid intValue]];
                [statusM setTopid:[messagedata.feedid intValue]];
                CommentInfoController *commentVC = [[CommentInfoController alloc] init];
                [commentVC setStatusM:statusM];
                [self.navigationController pushViewController:commentVC animated:YES];
            }
        }
            break;
        case 2:
        {
            NewFriendUser *friendM = _datasource[indexPath.row];
            BOOL isask = NO;
            if ([friendM.operateType integerValue] == 1 ||[friendM.pushType isEqualToString:@"friendCommand"]) {
                isask = YES;
            }
            UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:(IBaseUserM *)friendM isAsk:isask];
            [userInfoVC setNeedlessCancel:YES];
            WEAKSELF
            userInfoVC.acceptFriendBlock = ^(){
                [weakSelf newFriendOperate:FriendOperateTypeAccept newFriendUser:friendM indexPath:indexPath];
                //        [weakUserInfoVC addSucceed];
            };
            [self.navigationController pushViewController:userInfoVC animated:YES];
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
                //更新首页角标
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMsgNumChanged" object:nil];
                //刷新列表
//                self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
//                [self.tableView reloadData];
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
    self.selectType = index;
    switch (_selectType) {
        case 0:
        {
            [self loadChatMessageData];
        }
            break;
        case 1:
        {
            [self loadMessageData];
        }
            break;
        case 2:
        {
            [self loadNewFriendData];
        }
            break;
        default:
            break;
    }
}

//获取好友消息
- (void)loadNewFriendData
{
    //加载数据
    self.datasource = [NSMutableArray arrayWithArray:[[LogInUser getCurrentLoginUser] allMyNewFriends]];
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [_tableView addSubview:self.notHasDataView];
        [_tableView sendSubviewToBack:self.notHasDataView];
    }
    [_tableView reloadData];
}

//获取普通消息
- (void)loadMessageData
{
    NSArray *messages = [[LogInUser getCurrentLoginUser] getAllMessages];
    NSMutableArray *messageModels = [NSMutableArray array];
    for (HomeMessage *homeM  in messages) {
        if (!homeM.isLook.boolValue) {
            homeM.isLook = @(1);
            MessageFrameModel *messageFrameM = [[MessageFrameModel alloc] init];
            messageFrameM.messageDataM = homeM;
            [messageModels addObject:messageFrameM];
        }
    }
    self.datasource = [NSArray arrayWithArray:messageModels];
    
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [self.tableView addSubview:self.notHasDataView];
        [self.tableView sendSubviewToBack:_notHasDataView];
    }
    [_tableView reloadData];
}

//获取聊天消息
- (void)loadChatMessageData
{
    self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [self.tableView addSubview:self.notHasDataView];
        [self.tableView sendSubviewToBack:_notHasDataView];
    }
    [_tableView reloadData];
}

//聊天列表改变
- (void)chatUsersChanged:(NSNotification *)notification
{
    self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [_tableView addSubview:self.notHasDataView];
        [_tableView sendSubviewToBack:_notHasDataView];
    }
    [_tableView reloadData];
}

//从用户信息中发送消息
- (void)chatFromUserInfo:(NSNotification *)notification
{
    //切换首页Tap
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTapToChatList" object:nil];
    
    NSNumber *uid = @([[[notification userInfo] objectForKey:@"uid"] integerValue]);
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    MyFriendUser *user = [loginUser getMyfriendUserWithUid:uid];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:chatVC animated:YES];
}

//角标改变
- (void)badgeInfoChanged
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    //聊天
    NSInteger unReadChatMsg = [loginUser allUnReadChatMessageNum];
    //设置角标
//    _segmentedControl.sectionBadges = @[@(unReadChatMsg),loginUser.homemessagebadge,loginUser.newfriendbadge];
    //重绘内容
    [_segmentedControl setSelectedSegmentIndex:_selectType animated:YES];
    switch (_selectType) {
        case 0:
        {
            [self loadChatMessageData];
        }
            break;
        case 1:
        {
            [self loadMessageData];
        }
            break;
        case 2:
        {
            [self loadNewFriendData];
        }
            break;
        default:
            break;
    }
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
            [WLHttpTool requestFriendParameterDic:@{@"fid":newFriendUser.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
                //发送邀请成功，修改状态，刷新列表
                NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeWait];
                //改变数组，刷新列表
                NSMutableArray *allDatas = [NSMutableArray arrayWithArray:_datasource];
                [allDatas replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
                self.datasource = [NSArray arrayWithArray:allDatas];
                //刷新列表
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }];
        [alert show];
    }
    
    if (type == FriendOperateTypeAccept) {
        //接受好友请求
        [WLHttpTool addFriendParameterDic:@{@"fid":newFriendUser.uid} success:^(id JSON) {
            
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
            [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
            
            //接受后，本地创建一条消息
            //本地创建好像
            [ChatMessage createChatMessageForAddFriend:myFriendUser];
            
            [WLHUDView showSuccessHUD:@"添加成功！"];
        } fail:^(NSError *error) {
            
        }];
    }
}

@end
