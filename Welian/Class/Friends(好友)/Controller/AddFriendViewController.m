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

@interface AddFriendViewController ()

@property (strong, nonatomic)  NSArray *datasource;
@property (assign,nonatomic) UISegmentedControl *segmentedControl;
@property (assign,nonatomic) NSInteger selectIndex;

@property (strong, nonatomic) NotstringView *phoneNotView;//手机提醒
@property (strong, nonatomic) NotstringView *weChatNotView;//微信提醒

@end

@implementation AddFriendViewController

//手机通讯录授权提醒
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
        [weakSelf refreshPhone];
    }];
    return _phoneNotView;
}

//微信提醒
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加title内容
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机联系人",@"微信好友"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    //设置默认选择的内容
    [segmentedControl setSelectedSegmentIndex:_selectIndex];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    
    //默认加载的数据
    [self changeDataWithIndex:segmentedControl.selectedSegmentIndex];
//    [self getaddressBook];
    
    //下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPhoneAllFriends) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    //开始刷新
    [self.refreshControl beginRefreshing];
    [self getPhoneAllFriends];
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
    
    if (_segmentedControl.selectedSegmentIndex == 1 && indexPath.section == 0) {
        //邀请好友
//        cell.operateBtn.hidden = YES;
//        cell.logoImageView.image = [UIImage imageNamed:@"me_myfriend_add_wechat_logo"];
//        cell.nameLabel.text = @"邀请微信好友";
//        cell.messageLabel.text = @"";
        cell.dicData = @{@"logo":@"me_myfriend_add_wechat_logo",@"name":@"邀请微信好友"};
    }else{
        cell.needAddUser = _datasource[indexPath.row];
        
//        cell.operateBtn.hidden = NO;
//        cell.logoImageView.image = [UIImage imageNamed:@"me_myfriend_add_wechat_logo"];
//        cell.nameLabel.text = @"陈日莎";
//        cell.messageLabel.text = @"手机联系人:吴雪昭";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segmentedControl.selectedSegmentIndex == 1 && indexPath.section == 0) {
        LogInUser *mode = [LogInUser getNowLogInUser];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:[UserDefaults objectForKey:@"icon"] options:NSDataBase64Encoding64CharacterLineLength];
        
        UIImage *shareImage = [UIImage imageWithData:data];
        
        NSString *messStr = [NSString stringWithFormat:@"%@邀请您一起来玩微链",mode.name];
        NSString *desStr = @"我正在玩微链，认识了不少投资和创业的朋友，嘿，你也来吧！";
        
        //微信邀请
        UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:@""];
        [sheet bk_addButtonWithTitle:@"微信好友" handler:^{
            [[ShareEngine sharedShareEngine] sendWeChatMessage:messStr andDescription:desStr WithUrl:mode.inviteurl andImage:nil WithScene:weChat];
        }];
        [sheet bk_addButtonWithTitle:@"微信朋友圈" handler:^{
            [[ShareEngine sharedShareEngine] sendWeChatMessage:messStr andDescription:desStr WithUrl:mode.inviteurl andImage:shareImage WithScene:weChatFriend];
        }];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [sheet showInView:self.view];
    }else{
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Private
- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    DLog(@"segmentedControlChanged-->%d",sender.selectedSegmentIndex);
    [self changeDataWithIndex:sender.selectedSegmentIndex];
}

//加载数据
- (void)changeDataWithIndex:(NSInteger)index
{
//    self.datasource = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    if(!_datasource){
        if (index == 0) {
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

//刷新通讯录
- (void)refreshPhone
{
    DLog(@"刷新通讯录");
}

//获取通讯录联系人
- (void)getPhoneAllFriends
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    //这个只会在第一次访问时调用
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
        NSMutableArray *address = [NSMutableArray array];
        if (greanted) {
            //获取通讯录
            address = [WLTool getAddressBookArray];
        }
        [self.refreshControl endRefreshing];
        //通讯录联系人
//        [WLHttpTool uploadPhonebookParameterDic:address success:^(id JSON) {
//            LogInUser *loginUser = [LogInUser getNowLogInUser];
//            for (NSDictionary *dic in JSON) {
//                //保存到数据库
//                [loginUser createNeedAddUserWithDict:dic withType:1];
//            }
//            
//            //获取通讯录好友
//            self.datasource = [loginUser allNeedAddUserWithType:1];
//            
//            [self.refreshControl endRefreshing];
//            //切换到第一个
//            [self changeDataWithIndex:0];
//        } fail:^(NSError *error) {
//            [self.refreshControl endRefreshing];
//            [UIAlertView showWithError:error];
//        }];
        
    });
    
}

//- (void)getaddressBook
//{
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, nil);
//    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
//    //这个只会在第一次访问时调用
//    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error){
//        dispatch_semaphore_signal(sema);
//        NSMutableArray *address = [NSMutableArray array];
//        if (greanted) {
//            //获取通讯录
//            address = [WLTool getAddressBookArray];
//        }
//        //只有微信
//        [WLHttpTool uploadPhonebook2ParameterDic:address success:^(id JSON) {
//            NSArray *array = JSON;
//            DLog(@"getaddressBook--->:%@",array);
//            //                for (NSDictionary *dic  in array) {
//            //                    FriendsAddressBook *friendBook = [[FriendsAddressBook alloc] init];
//            //                    [friendBook setKeyValues:dic];
//            //                    if (friendBook.type.integerValue == 0) {
//            //                        [self.friendsBook addObject:friendBook];
//            //                    }else if (friendBook.type.integerValue==1){
//            //                        [self.friendsWeixing addObject:friendBook];
//            //                    }
//            //                }
//        } fail:^(NSError *error) {
//            [UIAlertView showWithError:error];
//        }];
//        
//    });
//}

@end
