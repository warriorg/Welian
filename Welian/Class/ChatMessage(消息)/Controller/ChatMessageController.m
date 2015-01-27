//
//  ChatMessageController.m
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatMessageController.h"
#import "ChatMessageViewCell.h"
#import "ChatViewController.h"
#import "NotstringView.h"

@interface ChatMessageController ()

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NotstringView *notHasDataView;//无消息提醒

@end

@implementation ChatMessageController

- (void)dealloc{
    _datasource = nil;
}

//没有聊天记录提醒
- (NotstringView *)notHasDataView
{
    if (!_notHasDataView) {
        _notHasDataView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitStr:@"没有消息记录" andImageName:@"remind_big_nostring"];
    }
    return _notHasDataView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //添加聊天用户改变监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatUsersChanged:) name:@"ChatUserChanged" object:nil];
        //添加聊天消息数量改变监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatUsersChanged:) name:@"ChatMsgNumChanged" object:nil];
        
        //如果是从好友列表进入聊天，首页变换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatFromUserInfo:) name:@"ChatFromUserInfo" object:nil];
        
        self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [self.tableView addSubview:self.notHasDataView];
        [self.tableView sendSubviewToBack:_notHasDataView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    // Dispose of any resources that can be recreated.
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
    static NSString *CELL_Identifier = @"ChatViewCell";
    ChatMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_Identifier];
    if (!cell) {
        cell = [[ChatMessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_Identifier];
    }
    cell.myFriendUser = _datasource[indexPath.row];
//    [cell setDebug:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //在切换界面的过程中禁止滑动手势，避免界面卡死
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
    
    //进入聊天页面
    MyFriendUser *friendUser = _datasource[indexPath.row];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithUser:friendUser];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
        //修改聊天状态
        MyFriendUser *friendUser = _datasource[indexPath.row];
        [friendUser updateIsChatStatus:NO];
        
        //更新当前聊天的所有消息为已读状态
//        [friendUser updateAllMessageReadStatus];
        [friendUser updateUnReadMessageNumber:@(0)];
        
        //更新首页角标
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMsgNumChanged" object:nil];
        
        //刷新列表
        self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
        [self.tableView reloadData];
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [(NSMutableArray *)_datasource removeObjectAtIndex:indexPath.row];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - private
//聊天列表改变
- (void)chatUsersChanged:(NSNotification *)notification
{
    self.datasource = [[LogInUser getCurrentLoginUser] chatUsers];
    
    if (_datasource.count > 0) {
        [_notHasDataView removeFromSuperview];
    }else{
        [self.tableView addSubview:self.notHasDataView];
        [self.tableView sendSubviewToBack:_notHasDataView];
    }
    [self.tableView reloadData];
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

@end
