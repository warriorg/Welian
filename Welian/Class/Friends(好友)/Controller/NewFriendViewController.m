//
//  NewFriendViewController.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "NewFriendViewController.h"
#import "WLSegmentedControl.h"
#import "AddFriendsController.h"
#import "NavViewController.h"
#import "AddFriendTypeListViewController.h"
#import "AddFriendViewController.h"
#import "UserInfoViewController.h"

#import "FriendsNewCell.h"
#import "NotstringView.h"
#import "NewFriendViewCell.h"
#import "MyFriendUser.h"

static NSString *cellIdentifier = @"frnewCellid";

@interface NewFriendViewController ()<WLSegmentedControlDelegate>

@property (strong, nonatomic) NotstringView *notView;

@property (strong, nonatomic) NSMutableArray *datasource;
//@property (nonatomic, strong) UserInfoBasicVC *userBasicVC;

@end

@implementation NewFriendViewController

- (NotstringView *)notView
{
    if (!_notView) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitleStr:@"暂无新的好友"];
    }
    return _notView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //标题
    self.title = @"新的好友";
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //返回不取消接口调用
    self.needlessCancel = YES;
    
    //右侧添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addFriendClick)];
    
    //操作按钮
    NSArray *btnImages = @[[UIImage imageNamed:@"me_myfriend_phone_logo"],
                           [UIImage imageNamed:@"me_myfriend_wechat_logo"]];
    
    WLSegmentedControl *segementedControl = [[WLSegmentedControl alloc] initWithFrame:Rect(0.f, 0.f, self.view.width, 82.f) Titles:@[@"手机联系人",@"微信好友"] Images:btnImages Bridges:@[@"0",@"0"] isHorizontal:NO];
    segementedControl.delegate = self;
    self.tableView.tableHeaderView = segementedControl;
    
    //重新设置新的好友中待验证的状态
    [[LogInUser getCurrentLoginUser] updateAllNewFriendsOperateStatus];

    //加载数据
    self.datasource = [NSMutableArray arrayWithArray:[[LogInUser getCurrentLoginUser] allMyNewFriends]];
    if (_datasource.count > 0) {
        [_notView removeFromSuperview];
        [self.tableView reloadData];
    }else{
        [self.tableView addSubview:self.notView];
        [self.tableView sendSubviewToBack:self.notView];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.nFriendUser = _datasource[indexPath.row];
    WEAKSELF
    [cell setNewFriendBlock:^(FriendOperateType type,NewFriendUser *newFriendUser,NSIndexPath *indexPath){
        [weakSelf newFriendOperate:type newFriendUser:newFriendUser indexPath:indexPath];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewFriendUser *friendM = _datasource[indexPath.row];
    BOOL isask = NO;
    if ([friendM.operateType integerValue] == 1 ||[friendM.pushType isEqualToString:@"friendCommand"]) {
        isask = YES;
    }
//    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:(IBaseUserM *)friendM isAsk:isask];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:(IBaseUserM *)friendM OperateType:@(10) HidRightBtn:NO];
    [self.navigationController pushViewController:userInfoVC animated:YES];
//    [userInfoVC setNeedlessCancel:YES];
    WEAKSELF
    userInfoVC.acceptFriendBlock = ^(){
        [weakSelf newFriendOperate:FriendOperateTypeAccept newFriendUser:friendM indexPath:indexPath];
//        [weakUserInfoVC addSucceed];
    };
//    self.userBasicVC = userInfoVC;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendUser *friendUser = _datasource[indexPath.row];
    return [NewFriendViewCell configureWithName:friendUser.name message:friendUser.msg];
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendUser *friendM = _datasource[indexPath.row];
    //删除本地数据库数据
    [friendM MR_deleteEntity];
    [_datasource removeObjectAtIndex:indexPath.row];
    //移除tableView中的数据
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}

#pragma mark - WLSegmentedControlDelegate
/**
 *  点击进入对应的添加好友页面
 *
 *  @param index 0:手机联系人  1：微信联系人
 */
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
{
    //手机和微信添加好友
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] initWithStyle:UITableViewStyleGrouped WithSelectType:index];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

#pragma mark - Private
/**
 *  右上角，添加好友按钮点击，进入添加好友列表页面
 */
- (void)addFriendClick
{
    AddFriendTypeListViewController *addTypeListVC = [[AddFriendTypeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:addTypeListVC animated:YES];
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
            [WLHUDView showHUDWithStr:@"发送中..." dim:NO];
            [WeLianClient requestAddFriendWithID:newFriendUser.uid
                                         Message:[alert textFieldAtIndex:0].text
                                         Success:^(id resultInfo) {
                                             //发送邀请成功，修改状态，刷新列表
                                             NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeWait];
                                             //改变数组，刷新列表
                                             [_datasource replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
                                             //刷新列表
                                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                             [WLHUDView showSuccessHUD:@"好友请求已发送"];
                                         } Failed:^(NSError *error) {
                                             if (error) {
                                                 [WLHUDView showErrorHUD:error.localizedDescription];
                                             }else{
                                                 [WLHUDView showErrorHUD:@"发送失败，请重试"];
                                             }
                                         }];
//            [WLHttpTool requestFriendParameterDic:@{@"fid":newFriendUser.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
//                //发送邀请成功，修改状态，刷新列表
//                NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeWait];
//                //改变数组，刷新列表
//                [_datasource replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
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
        [WLHUDView showHUDWithStr:@"添加中..." dim:NO];
        [WeLianClient confirmAddFriendWithID:newFriendUser.uid
                                     Success:^(id resultInfo) {
                                         [newFriendUser setIsAgree:@(1)];
                                         //更新好友列表数据库
                                         [MyFriendUser createWithNewFriendUser:newFriendUser];
                                         
                                         //发送邀请成功，修改状态，刷新列表
                                         NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeAdded];
//                                         if (self.userBasicVC) {
//                                             [self.userBasicVC addSucceed];
//                                         }
                                         //改变数组，刷新列表
                                         [_datasource replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
                                         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                         
                                         //刷新好友列表
                                         [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
                                         
                                         //接受后，本地创建一条消息
                                         //        WLMessage *textMessage = [[WLMessage alloc] initWithSpecialText:[NSString stringWithFormat:@"你已经添加了%@,现在可以开始聊聊创业那些事了。",friendUser.name] sender:@"" timestamp:[NSDate date]];
                                         //        textMessage.avatorUrl = nil;
                                         //        textMessage.sender = nil;
                                         //        //是否读取
                                         //        textMessage.isRead = NO;
                                         //        textMessage.sended = @"1";
                                         //        textMessage.bubbleMessageType = WLBubbleMessageTypeReceiving;
                                         //
                                         //        //更新聊天好友
                                         //        [friendUser updateIsChatStatus:YES];
                                         //
                                         //        //    //本地聊天数据库添加
                                         //        ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:textMessage FriendUser:friendUser];
                                         //        textMessage.msgId = chatMessage.msgId.stringValue;
                                         //
                                         //        //聊天状态发送改变
                                         //        [KNSNotification postNotificationName:@"ChatUserChanged" object:nil];
                                         
                                         [WLHUDView showSuccessHUD:[NSString stringWithFormat:@"你已添加%@为好友",newFriendUser.name]];
                                     } Failed:^(NSError *error) {
                                         if (error) {
                                             [WLHUDView showErrorHUD:error.localizedDescription];
                                         }else{
                                             [WLHUDView showErrorHUD:@"添加失败，请重试"];
                                         }
                                     }];
        
//        [WLHttpTool addFriendParameterDic:@{@"fid":newFriendUser.uid} success:^(id JSON) {
//            
//            [newFriendUser setIsAgree:@(1)];
//            //更新好友列表数据库
//            [MyFriendUser createWithNewFriendUser:newFriendUser];
//            
//            //发送邀请成功，修改状态，刷新列表
//            NewFriendUser *nowFriendUser = [newFriendUser updateOperateType:FriendOperateTypeAdded];
//            if (self.userBasicVC) {
//                [self.userBasicVC addSucceed];
//            }
//            //改变数组，刷新列表
//            [_datasource replaceObjectAtIndex:indexPath.row withObject:nowFriendUser];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            
//            //刷新好友列表
//            [KNSNotification postNotificationName:KupdataMyAllFriends object:self];
//            
//            //接受后，本地创建一条消息
//            //        WLMessage *textMessage = [[WLMessage alloc] initWithSpecialText:[NSString stringWithFormat:@"你已经添加了%@,现在可以开始聊聊创业那些事了。",friendUser.name] sender:@"" timestamp:[NSDate date]];
//            //        textMessage.avatorUrl = nil;
//            //        textMessage.sender = nil;
//            //        //是否读取
//            //        textMessage.isRead = NO;
//            //        textMessage.sended = @"1";
//            //        textMessage.bubbleMessageType = WLBubbleMessageTypeReceiving;
//            //
//            //        //更新聊天好友
//            //        [friendUser updateIsChatStatus:YES];
//            //
//            //        //    //本地聊天数据库添加
//            //        ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:textMessage FriendUser:friendUser];
//            //        textMessage.msgId = chatMessage.msgId.stringValue;
//            //
//            //        //聊天状态发送改变
//            //        [KNSNotification postNotificationName:@"ChatUserChanged" object:nil];
//            
//            [WLHUDView showSuccessHUD:@"添加成功！"];
//        } fail:^(NSError *error) {
//            
//        }];
    }
}

@end
