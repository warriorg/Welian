//
//  NewFriendController.m
//  weLian
//
//  Created by dong on 14/10/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NewFriendController.h"
#import "FriendsNewCell.h"
//#import "NewFriendModel.h"
#import "MJExtension.h"
#import "UserInfoBasicVC.h"
#import "AddFriendsController.h"
#import "NavViewController.h"
#import "NotstringView.h"
#import "NewFriendUser.h"
#import "MyFriendUser.h"
#import "FriendsUserModel.h"

static NSString *frnewCellid = @"frnewCellid";
@interface NewFriendController ()<UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    NSIndexPath *_selectIndexPath;
}

@property (nonatomic, strong) NotstringView *notView;

@end

@implementation NewFriendController

- (NotstringView *)notView
{
    if (_notView == nil ) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitStr:@"还没有新的好友，点击右上角添加好友。" andImageName:@"remind_big_nostring"];
    }
    return _notView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self setTitle:@"好友请求"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsNewCell" bundle:nil] forCellReuseIdentifier:frnewCellid];
    [self.tableView setBackgroundColor:IWGlobalBg];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendClick)];
    
    NSArray *newFarray = [LogInUser getNowLogInUser].rsNewFriends.allObjects;
    
    for (NewFriendUser *newfriend in newFarray) {
        newfriend.isLook = @(1);
       MyFriendUser *myF = [MyFriendUser getMyfriendUserWithUid:newfriend.uid];
        if (myF) {
            newfriend.isAgree = @(1);
        }else{
            newfriend.isAgree = @(0);
        }
    }
    [MOC save];
    
    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    
    _dataArray =  [NSMutableArray arrayWithArray:[newFarray sortedArrayUsingDescriptors:@[bookNameDes]]];
    if (_dataArray.count) {
        
        [self.tableView reloadData];
    }else{
        [self.tableView addSubview:self.notView];
    }
}

- (void)addFriendClick
{
    [self presentViewController:[[NavViewController alloc] initWithRootViewController:[[AddFriendsController alloc] initWithStyle:UITableViewStylePlain]] animated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsNewCell *cell = [tableView dequeueReusableCellWithIdentifier:frnewCellid];
    
    NewFriendUser *newFM = _dataArray[indexPath.row];
//    cell.friendM = newFM;
    float width = [[UIScreen mainScreen] bounds].size.width - 40 - 50 - 60;
    //计算第一个label的高度
    CGSize size1 = [newFM.name calculateSize:CGSizeMake(width, FLT_MAX) font:cell.nameLabel.font];
    //计算第二个label的高度
    CGSize size2 = [newFM.msg calculateSize:CGSizeMake(width, FLT_MAX) font:cell.massgeLabel.font];
    
    float height = size1.height + size2.height + 18;
    if (height > 60) {
        return height;
    }else{
        return 60;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsNewCell *cell = [tableView dequeueReusableCellWithIdentifier:frnewCellid];
    NewFriendUser *newFM = _dataArray[indexPath.row];
    [cell setFriendM:newFM];
    [cell.accBut addTarget:self action:@selector(sureAddFriend:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewFriendUser *friendM = _dataArray[indexPath.row];
    BOOL isask = YES;
    if ([friendM.isAgree boolValue]||[friendM.pushType isEqualToString:@"friendCommand"]) {
        isask = NO;
    }
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:friendM isAsk:isask];
    __weak NewFriendController *newFVC = self;
    __weak UserInfoBasicVC *weakUserInfoVC = userInfoVC;
    userInfoVC.acceptFriendBlock = ^(){
        [newFVC jieshouFriend:indexPath];
        [weakUserInfoVC addSucceed];
    };
    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}


#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendUser *friendM = _dataArray[indexPath.row];
    [[LogInUser getNowLogInUser] removeRsNewFriendsObject:_dataArray[indexPath.row]];
    [_dataArray removeObject:friendM];
    //移除tableView中的数据
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}


- (void)sureAddFriend:(UIButton *)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        _selectIndexPath = indexPath;
        NewFriendUser *newFM = _dataArray[indexPath.row];
        if ([newFM.pushType isEqualToString:@"friendRequest"]) {
            [self jieshouFriend:indexPath];
        }else if ([newFM.pushType isEqualToString:@"friendCommand"]){

            LogInUser *mode = [LogInUser getNowLogInUser];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",newFM.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",mode.company,mode.position]];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NewFriendUser *newFM = _dataArray[_selectIndexPath.row];
        [WLHttpTool requestFriendParameterDic:@{@"fid":newFM.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }
}



- (void)jieshouFriend:(NSIndexPath*)indexPath
{
    NewFriendUser *friendM = _dataArray[indexPath.row];
    [WLHttpTool addFriendParameterDic:@{@"fid":friendM.uid} success:^(id JSON) {
        [friendM setIsAgree:@(1)];
        FriendsUserModel *friend = [FriendsUserModel objectWithDict:[friendM keyValues]];
        [MyFriendUser createMyFriendUserModel:friend];
        [MOC save];

        [_dataArray setObject:friendM atIndexedSubscript:indexPath.row];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
        
        [WLHUDView showSuccessHUD:@"添加成功！"];
    } fail:^(NSError *error) {
        
    }];

}
@end
