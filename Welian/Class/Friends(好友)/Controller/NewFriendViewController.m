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
#import "FriendsNewCell.h"
#import "UserInfoBasicVC.h"
#import "NotstringView.h"
#import "NewFriendViewCell.h"

static NSString *cellIdentifier = @"frnewCellid";

@interface NewFriendViewController ()<WLSegmentedControlDelegate>

@property (strong, nonatomic) NotstringView *notView;

@property (strong, nonatomic)  NSArray *datasource;

@end

@implementation NewFriendViewController

- (NotstringView *)notView
{
    if (!_notView) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitStr:@"暂无新的好友" andImageName:nil];
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
    
    //右侧添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addFriendClick)];
    
    //操作按钮
    NSArray *btnImages = @[[UIImage imageNamed:@"me_myfriend_phone_logo"],
                           [UIImage imageNamed:@"me_myfriend_wechat_logo"]];
    
    WLSegmentedControl *segementedControl = [[WLSegmentedControl alloc] initWithFrame:Rect(0.f, 0.f, self.view.width, 82.f) Titles:@[@"手机联系人",@"微信好友"] Images:btnImages Bridges:@[@"0",@"0"]];
    segementedControl.delegate = self;
    self.tableView.tableHeaderView = segementedControl;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsNewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
//    [self.tableView setBackgroundColor:IWGlobalBg];
    
    //默认选择手机联系人
    [self wlSegmentedControlSelectAtIndex:0];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
//    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    FriendsNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    NewFriendUser *newFM = _datasource[indexPath.row];
//    [cell setFriendM:newFM];
//    [cell.accBut addTarget:self action:@selector(sureAddFriend:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NewFriendUser *friendM = _dataArray[indexPath.row];
//    BOOL isask = YES;
//    if ([friendM.isAgree boolValue]||[friendM.pushType isEqualToString:@"friendCommand"]) {
//        isask = NO;
//    }
//    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:friendM isAsk:isask];
//    __weak NewFriendController *newFVC = self;
//    __weak UserInfoBasicVC *weakUserInfoVC = userInfoVC;
//    userInfoVC.acceptFriendBlock = ^(){
//        [newFVC jieshouFriend:indexPath];
//        [weakUserInfoVC addSucceed];
//    };
//    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewFriendViewCell configureWith];
//    FriendsNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    NewFriendUser *newFM = _datasource[indexPath.row];
//    //    cell.friendM = newFM;
//    float width = [[UIScreen mainScreen] bounds].size.width - 40 - 50 - 60;
//    //计算第一个label的高度
//    CGSize size1 = [newFM.name calculateSize:CGSizeMake(width, FLT_MAX) font:cell.nameLabel.font];
//    //计算第二个label的高度
//    CGSize size2 = [newFM.msg calculateSize:CGSizeMake(width, FLT_MAX) font:cell.massgeLabel.font];
//    
//    float height = size1.height + size2.height + 18;
//    if (height > 60) {
//        return height;
//    }else{
//        return 60;
//    }
//    return 60;
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewFriendUser *friendM = _dataArray[indexPath.row];
//    [[LogInUser getNowLogInUser] removeRsNewFriendsObject:_dataArray[indexPath.row]];
//    [_dataArray removeObject:friendM];
    //移除tableView中的数据
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}

#pragma mark - WLSegmentedControlDelegate
//切换
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
{
    self.datasource = [[[LogInUser getNowLogInUser] rsMyFriends] allObjects];
    if (_datasource) {
        [self.tableView reloadData];
    }else{
        [self.tableView addSubview:self.notView];
    }
}

#pragma mark - Private
//右上角，添加好友按钮
- (void)addFriendClick
{
    [self presentViewController:[[NavViewController alloc] initWithRootViewController:[[AddFriendsController alloc] initWithStyle:UITableViewStylePlain]] animated:YES completion:^{
        
    }];
}

@end
