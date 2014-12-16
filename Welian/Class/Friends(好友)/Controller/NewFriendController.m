//
//  NewFriendController.m
//  weLian
//
//  Created by dong on 14/10/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NewFriendController.h"
#import "FriendsNewCell.h"
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "UserInfoBasicVC.h"
#import "AddFriendsController.h"
#import "NavViewController.h"

static NSString *frnewCellid = @"frnewCellid";
@interface NewFriendController ()<UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    NSIndexPath *_selectIndexPath;
}
@end

@implementation NewFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self setTitle:@"好友请求"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsNewCell" bundle:nil] forCellReuseIdentifier:frnewCellid];
    [self.tableView setBackgroundColor:IWGlobalBg];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendClick)];
    
    NSArray *arrr = [[WLDataDBTool sharedService] getAllItemsFromTable:KNewFriendsTableName];
    NSMutableArray *aaaYT = [NSMutableArray array];
    for (YTKKeyValueItem *aa in arrr) {
        NSMutableDictionary *itaaDic = [NSMutableDictionary dictionaryWithDictionary:aa.itemObject];
        [itaaDic setObject:@"1" forKey:@"isLook"];
        [[WLDataDBTool sharedService] putObject:itaaDic withId:aa.itemId intoTable:KNewFriendsTableName];
        
        NewFriendModel *statusM = [NewFriendModel objectWithKeyValues:aa.itemObject];
        YTKKeyValueItem *item =[[WLDataDBTool sharedService] getYTKKeyValueItemById:[NSString stringWithFormat:@"%@",statusM.uid] fromTable:KMyAllFriendsKey];
        if (item) {
            statusM.isAgree = @"1";
        }else{
            statusM.isAgree = nil;
        }
        [aaaYT addObject:statusM];
    }
    
    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    
    _dataArray =  [NSMutableArray arrayWithArray:[aaaYT sortedArrayUsingDescriptors:@[bookNameDes]]];
    [self.tableView reloadData];
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
    
    NewFriendModel *newFM = _dataArray[indexPath.row];
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
    NewFriendModel *newFM = _dataArray[indexPath.row];
    [cell setFriendM:newFM];
    [cell.accBut addTarget:self action:@selector(sureAddFriend:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewFriendModel *friendM = _dataArray[indexPath.row];
    UserInfoModel *basMode = [[UserInfoModel alloc]init];
    [basMode setKeyValues:[friendM keyValues]];
    BOOL isask = YES;
    if ([friendM.isAgree isEqualToString:@"1"]||[friendM.type isEqualToString:@"friendCommand"]) {
        isask = NO;
    }
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:basMode isAsk:isask];
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
    NewFriendModel *friendM = _dataArray[indexPath.row];
    [[WLDataDBTool sharedService] deleteObjectById:[NSString stringWithFormat:@"%@",friendM.uid] fromTable:KNewFriendsTableName];
    [_dataArray removeObject:friendM];
    //移除tableView中的数据
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if (![friendM.isAgree isEqualToString:@"1"]) {
        [WLHttpTool deleteFriendRequestParameterDic:@{@"fid":friendM.uid} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }
    
}


- (void)sureAddFriend:(UIButton *)but event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        _selectIndexPath = indexPath;
        NewFriendModel *newFM = _dataArray[indexPath.row];
        if ([newFM.type isEqualToString:@"friendRequest"]) {
            [self jieshouFriend:indexPath];
        }else if ([newFM.type isEqualToString:@"friendCommand"]){
            
            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",newFM.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@",mode.name]];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NewFriendModel *newFM = _dataArray[_selectIndexPath.row];
        [WLHttpTool requestFriendParameterDic:@{@"fid":newFM.uid,@"message":[alertView textFieldAtIndex:0].text} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }
}



- (void)jieshouFriend:(NSIndexPath*)indexPath
{
    NewFriendModel *friendM = _dataArray[indexPath.row];
    [WLHttpTool addFriendParameterDic:@{@"fid":friendM.uid} success:^(id JSON) {
        [friendM setIsAgree:@"1"];
        
        [[WLDataDBTool sharedService] putObject:[friendM keyValues] withId:[NSString stringWithFormat:@"%@",friendM.uid] intoTable:KNewFriendsTableName];
        [_dataArray setObject:friendM atIndexedSubscript:indexPath.row];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        UserInfoModel *basMode = [[UserInfoModel alloc]init];
        [basMode setKeyValues:[friendM keyValues]];
        [basMode setUid:friendM.uid];
        [[WLDataDBTool sharedService] putObject:[basMode keyValues] withId:[NSString stringWithFormat:@"%@",basMode.uid] intoTable:KMyAllFriendsKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
        
        [WLHUDView showSuccessHUD:@"添加成功！"];
    } fail:^(NSError *error) {
        
    }];

}
@end
