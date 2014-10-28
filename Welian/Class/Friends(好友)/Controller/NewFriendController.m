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
#import "WLDataDBTool.h"
#import "UserInfoBasicVC.h"

static NSString *frnewCellid = @"frnewCellid";
@interface NewFriendController ()
{
    NSMutableArray *_dataArray;
}
@end

@implementation NewFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self setTitle:@"好友请求"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsNewCell" bundle:nil] forCellReuseIdentifier:frnewCellid];
    [self.tableView setBackgroundColor:IWGlobalBg];
    NSArray *arrr = [[WLDataDBTool sharedService] getAllItemsFromTable:KNewFriendsTableName];
    
    for (YTKKeyValueItem *aa in arrr) {
        NewFriendModel *statusM = [NewFriendModel objectWithKeyValues:aa.itemObject];
        [_dataArray addObject:statusM];
    }
    [self.tableView reloadData];
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
    return 60;
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
    [basMode setUid:friendM.fid];

    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:basMode];
    
    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}


#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendModel *friendM = _dataArray[indexPath.row];
    // Remove the row from data model
    [[WLDataDBTool sharedService] deleteObjectById:[NSString stringWithFormat:@"%@",friendM.fid] fromTable:KNewFriendsTableName];
    
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
        NewFriendModel *friendM = _dataArray[indexPath.row];
        [WLHttpTool addFriendParameterDic:@{@"fid":friendM.fid} success:^(id JSON) {
            [friendM setIsAgree:@"1"];
            
            [[WLDataDBTool sharedService] putObject:[friendM keyValues] withId:[NSString stringWithFormat:@"%@",friendM.fid] intoTable:KNewFriendsTableName];
            [_dataArray setObject:friendM atIndexedSubscript:indexPath.row];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            UserInfoModel *basMode = [[UserInfoModel alloc]init];
            [basMode setKeyValues:[friendM keyValues]];
            [basMode setUid:friendM.fid];
            [[WLDataDBTool sharedService] putObject:[basMode keyValues] withId:[NSString stringWithFormat:@"%@",basMode.uid] intoTable:KMyAllFriendsKey];
            
        } fail:^(NSError *error) {
            
        }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
