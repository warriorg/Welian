//
//  CommonFriendsController.m
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CommonFriendsController.h"
#import "UserInfoBasicVC.h"
#import "UserInfoViewController.h"

#import "FriendCell.h"

@interface CommonFriendsController ()
{
    NSArray *_friendsA;
}
@end

static NSString *fridcellid = @"fridcellid";

@implementation CommonFriendsController

- (instancetype)initWithStyle:(UITableViewStyle)style withFriends:(NSArray *)friendsArray
{
    _friendsA = friendsArray;
    self = [super initWithStyle:style];
    if (self) {
        
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"共同好友"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _friendsA.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
    UserInfoModel *modeIM = _friendsA[indexPath.row];
    [cell setUserMode:modeIM];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *modeIM = _friendsA[indexPath.row];
//    UserInfoBasicVC *userinfVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:modeIM isAsk:NO];
//    [self.navigationController pushViewController:userinfVC animated:YES];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:modeIM OperateType:nil HidRightBtn:NO];
    [self.navigationController pushViewController:userInfoVC animated:YES];
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
