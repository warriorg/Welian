//
//  AddFriendViewController.m
//  Welian
//
//  Created by weLian on 15/1/8.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "AddFriendViewController.h"
#import "NewFriendViewCell.h"
#import "NotstringView.h"
#import "ShareEngine.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WLTool.h"
#import "UserInfoBasicVC.h"
#import <MessageUI/MessageUI.h>
#import "SEImageCache.h"
#import "NSString+val.h"

@interface AddFriendViewController ()<MFMessageComposeViewControllerDelegate>

@property (strong,nonatomic) NSMutableArray *datasource;
@property (assign,nonatomic) UISegmentedControl *segmentedControl;
@property (assign,nonatomic) NSInteger selectIndex;
@property (strong,nonatomic) NSMutableArray* localPhoneArray;

@property (strong,nonatomic) NotstringView *phoneNotView;//手机提醒
@property (strong,nonatomic) NotstringView *weChatNotView;//微信提醒

@end

@implementation AddFriendViewController

- (void)dealloc
{
    _datasource = nil;
    _localPhoneArray = nil;
    _phoneNotView = nil;
    _weChatNotView = nil;
}

/**
 *  手机通讯录授权提醒
 *
 *  @return 提醒内容页面
 */
- (NotstringView *)phoneNotView
{
    if (!_phoneNotView) {
        _phoneNotView = [[NotstringView alloc] initWithFrame:self.tableView.frame
                                                withTitleStr:@"您未授权同意微链访问通讯录"
                                                    SubTitle:@"请到“设置->隐私->通讯录”中打开微链访问通讯录的权限"
                                                    BtnTitle:@"点击刷新"
                                                BtnImageName:@"login_research"];
    }
    WEAKSELF
    [_phoneNotView setBlock:^{
        [weakSelf changeDataWithIndex:0];
    }];
    return _phoneNotView;
}

/**
 *  微信没有好友提醒
 *
 *  @return 提醒内容页面
 */
- (NotstringView *)weChatNotView
{
    if (!_weChatNotView) {
        _weChatNotView = [[NotstringView alloc] initWithFrame:self.tableView.frame
                                                 withTitleStr:@"没有发现你的微信好友"
                                                     SubTitle:@"点击上面的“微信邀请”，邀请微信好友加入微链"];
    }
    return _weChatNotView;
}

- (id)initWithStyle:(UITableViewStyle)style WithSelectType:(NSInteger)selectIndex
{
    self = [super initWithStyle:style];
    if (self) {
        self.selectIndex = selectIndex;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [WLHUDView hiddenHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //返回不取消接口调用
    self.needlessCancel = YES;
    
    //更新所有待验证的消息为需要发送好友请求状态
    [[LogInUser getNowLogInUser] updateAllNeedAddFriendOperateStatus];
    
    //添加title内容
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机联系人",@"微信好友"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    //设置默认选择的内容
    [segmentedControl setSelectedSegmentIndex:_selectIndex];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(changeDataWithIndex:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    //询问调用通讯录
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    //这个只会在第一次访问时调用
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
        //默认加载的数据
        [self changeDataWithIndex:_selectIndex];
    });
    CFRelease(addressBookRef);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        //手机联系人
        return 1;
    }else{
        //微信联系人
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //微信联系人
    if (_segmentedControl.selectedSegmentIndex == 1 && section == 0) {
        return 1;
    }else{
        return _datasource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"AddFriendCellIdentifier";
    
    NewFriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.indexPath = indexPath;
    if (_segmentedControl.selectedSegmentIndex == 1 && indexPath.section == 0) {
        //邀请好友
        cell.dicData = @{@"logo":@"me_myfriend_add_wechat_logo",@"name":@"邀请微信好友"};
    }else{
        cell.needAddUser = _datasource[indexPath.row];
        WEAKSELF
        [cell setNeedAddBlock:^(NSInteger type,NeedAddUser *needAddUser,NSIndexPath *indexPath){
            [weakSelf needAddClickedWith:type needAddUser:needAddUser indexPath:indexPath];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segmentedControl.selectedSegmentIndex == 1 && indexPath.section == 0) {
        //微信邀请
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
        [sheet bk_addButtonWithTitle:@"微信好友" handler:^{
            [self shareWithType:0];
        }];
        [sheet bk_addButtonWithTitle:@"微信朋友圈" handler:^{
            [self shareWithType:1];
        }];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet showInView:self.view];
    }else{
        NeedAddUser *needAddUser = _datasource[indexPath.row];
        if(needAddUser.friendship.integerValue != 0 || needAddUser.uid != nil){
            //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
//            if (needAddUser.userType.integerValue == 1) {
                //手机联系人
                BOOL isask = YES;
                if(needAddUser.friendship.integerValue == 1 || needAddUser.friendship.integerValue == 2){
                    isask = NO;
                }
                UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:(IBaseUserM *)needAddUser isAsk:isask];
                //    __weak NewFriendController *newFVC = self;
                __weak UserInfoBasicVC *weakUserInfoVC = userInfoVC;
                WEAKSELF
                userInfoVC.acceptFriendBlock = ^(){
                    [weakSelf needAddClickedWith:2 needAddUser:needAddUser indexPath:indexPath];
                    [weakUserInfoVC addSucceed];
                };
                [self.navigationController pushViewController:userInfoVC animated:YES];
//            }else{
//                //微信好友
//                
//            }
        }else{
            //邀请手机通讯录
            if (needAddUser.userType.integerValue == 1) {
                //手机联系人  发送短信邀请
                [self showMessageView:needAddUser.mobile title:@"邀请好友" body:@"我正在玩微链，认识了不少投资和创业的朋友，嘿，你也来吧！http://welian.com"];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex == 1 && section > 0) {
        return 10.f;
    }else{
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_datasource.count > 0) {
        NeedAddUser *needAddUser = _datasource[indexPath.row];
        NSString *name = @"";
        NSString *msg = @"";
        if (needAddUser.userType.integerValue == 1) {
            //手机联系人
            name = needAddUser.wlname.length > 0 ? needAddUser.wlname : needAddUser.name;
            msg = needAddUser.friendship.integerValue == 0 ? [NSString stringWithFormat:@"手机号码：%@",needAddUser.mobile] : [NSString stringWithFormat:@"手机联系人：%@",needAddUser.name];
        }else{
            //微信联系人
            name = needAddUser.wlname.length > 0 ? needAddUser.wlname : needAddUser.name;
            msg = needAddUser.friendship.integerValue == 0 ? [NSString stringWithFormat:@"微信好友：%@",needAddUser.wlname.length > 0 ? needAddUser.wlname : needAddUser.name] : [NSString stringWithFormat:@"微信好友：%@",needAddUser.name.length > 0 ? needAddUser.name : needAddUser.wlname];
        }
        return [NewFriendViewCell configureWithName:name message:msg];
    }else{
        return 60.f;
    }
}

#pragma mark - Private
- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
//    DLog(@"segmentedControlChanged-->%d",sender.selectedSegmentIndex);
    //取消请求
    [WLHUDView hiddenHud];
    [WLHttpTool cancelAllRequestHttpTool];
    
    self.selectIndex = sender.selectedSegmentIndex;
    [self changeDataWithIndex:_selectIndex];
}

/**
 *  切换加载的数据内容
 *
 *  @param index 获取数据的方式：0-手机联系人 1：微信联系人
 */
- (void)changeDataWithIndex:(NSInteger)index
{
    //刷新动画
//    [self refreshAnimation];
    //先刷新页面
    [self reloadUIData];
    //调用接口
    if (_selectIndex == 0) {
        //获取通讯录好友
        [self getPhoneAllFriends];
    }else{
        //获取微信好友
        [self getWxFriends];
    }
}

/**
 *  加载刷新页面数据
 */
- (void)reloadUIData
{
    //清除提醒
    [_phoneNotView removeFromSuperview];
    [_weChatNotView removeFromSuperview];
    
    //获取通讯录好友
    self.datasource = _selectIndex == 0 ? [NeedAddUser allNeedAddUserWithType:1] : [NeedAddUser allNeedAddUserWithType:2];
    if(_datasource.count == 0){
        if (_selectIndex == 0) {
            [_weChatNotView removeFromSuperview];
            [self.view addSubview:self.phoneNotView];
        }else{
            [_phoneNotView removeFromSuperview];
            [self.view addSubview:self.weChatNotView];
            [self.view sendSubviewToBack:_weChatNotView];
        }
    }
    [self.tableView reloadData];
}

//刷新动画
- (void)refreshAnimation
{
    //开始刷新
    //    [self.refreshControl beginRefreshing];
    [self.refreshControl beginRefreshing];
    
    [self.tableView setContentOffset:CGPointMake(0,-self.refreshControl.frame.size.height-40) animated:YES];
    
    // 延迟0.5秒执行：
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        //刷新
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
    });
}

/**
 *  获取系统通讯录联系人列表数据
 */
- (void)getPhoneAllFriends
{
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized){
        //如果没有授权
        [self.refreshControl endRefreshing];
        [self reloadUIData];
    }else{
        if([NeedAddUser allNeedAddUserWithType:1].count <= 0){
            //通讯录联系人
            [WLHUDView showHUDWithStr:@"加载中.." dim:NO];
        }
        if (!_localPhoneArray) {
            self.localPhoneArray = [WLTool getAddressBookArray];
        }
        
        // 2) 在全局队列上异步调用方法，加载并更新图像
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [WLHttpTool uploadPhonebookParameterDic:_localPhoneArray success:^(id JSON) {
                [WLHUDView hiddenHud];
                for (NSDictionary *dic in JSON) {
                    //保存到数据库
                    [NeedAddUser createNeedAddUserWithDict:dic withType:1];
                }
                
                [self.refreshControl endRefreshing];
                [self reloadUIData];
            } fail:^(NSError *error) {
                [self.refreshControl endRefreshing];
            }];
        });
    }
}

/**
 *  获取系统微信好友列表数据
 */
- (void)getWxFriends
{
    if ([NeedAddUser allNeedAddUserWithType:2].count <= 0) {
        [WLHUDView showHUDWithStr:@"加载中.." dim:NO];
    }
    [WLHttpTool loadWxFriendParameterDic:[NSMutableArray array]
                                 success:^(id JSON) {
                                     [WLHUDView hiddenHud];
                                     for (NSDictionary *dic in JSON) {
                                         //保存到数据库
                                         [NeedAddUser createNeedAddUserWithDict:dic withType:2];
                                     }
                                     [self.refreshControl endRefreshing];
                                     [self reloadUIData];
                                 } fail:^(NSError *error) {
                                     [self.refreshControl endRefreshing];
                                 }];
}

/**
 *  需要添加的好友操作
 *
 *  @param type        操作类型
 *  @param needAddUser 需要添加的好友
 *  @param indexPath   当前操作对应的tableView
 */
- (void)needAddClickedWith:(NSInteger)type needAddUser:(NeedAddUser *)needAddUser indexPath:(NSIndexPath *)indexPath
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    if(type == 0){
        //发送邀请
        DLog(@"发送邀请");
        if (needAddUser.userType.integerValue == 1) {
            //手机联系人  发送短信邀请
            [self showMessageView:needAddUser.mobile title:@"邀请好友" body:@"我正在玩微链，认识了不少投资和创业的朋友，嘿，你也来吧！http://welian.com"];
        }
    }else if(type != 1){
        //添加
        DLog(@"添加好友");
        //添加好友，发送添加成功，状态变成待验证
        LogInUser *loginUser = [LogInUser getNowLogInUser];
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"好友验证" message:[NSString stringWithFormat:@"发送至好友：%@",needAddUser.wlname]];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"我是%@的%@",loginUser.company,loginUser.position]];
        [alert bk_addButtonWithTitle:@"取消" handler:nil];
        [alert bk_addButtonWithTitle:@"发送" handler:^{
            //发送好友请求
            [WLHttpTool requestFriendParameterDic:@{@"fid":needAddUser.uid,@"message":[alert textFieldAtIndex:0].text} success:^(id JSON) {
                //发送邀请成功，修改状态，刷新列表
                NeedAddUser *addUser = [needAddUser updateFriendShip:4];
                //改变数组，刷新列表
                [_datasource replaceObjectAtIndex:indexPath.row withObject:addUser];
                //刷新列表
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }];
        [alert show];
    }
}

/**
 *  分享到微信
 *
 *  @param type 分享方式：0：微信好友、1：微信朋友圈
 */
- (void)shareWithType:(NSInteger)type
{
    LogInUser *mode = [LogInUser getNowLogInUser];
    NSString *messStr = [NSString stringWithFormat:@"%@邀请您一起来玩微链",mode.name];
    NSString *desStr = @"我正在玩微链，认识了不少投资和创业的朋友，嘿，你也来吧！";
    [WLHUDView showHUDWithStr:@"" dim:NO];
    [[SEImageCache sharedInstance] imageForURL:[NSURL URLWithString:mode.avatar] completionBlock:^(UIImage *image, NSError *error) {
        [WLHUDView hiddenHud];
        [[ShareEngine sharedShareEngine] sendWeChatMessage:messStr andDescription:desStr WithUrl:mode.inviteurl andImage:image WithScene:type == 0 ? weChat : weChatFriend];
    }];
}

#pragma mark - 短信邀请
/**
 *  短信邀请
 *
 *  @param phone 电话号码
 *  @param title 标题
 *  @param body  邀请的内容
 */
- (void)showMessageView:(NSString *)phone title:(NSString *)title body:(NSString *)body
{
    [WLHUDView showCustomHUD:@"加载中..." imageview:nil];
    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = [NSArray arrayWithObject:phone];
    controller.body = body;
    controller.messageComposeDelegate = self;
    [controller setTitle:title];//修改短信界面标题
    [self presentViewController:controller animated:YES completion:^{
        [WLHUDView hiddenHud];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
            DLog(@"取消发送短信");
        }
            break;
        case MessageComposeResultFailed:// send failed
            DLog(@"短信发送失败");
            break;
        case MessageComposeResultSent:
        {
            //do something
            DLog(@"短信发送成功");
        }
            break;
        default:
            break;
    }
    
}

@end
