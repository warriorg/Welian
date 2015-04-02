//
//  MyFriendsController.m
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MyFriendsController.h"
#import "NewFriendController.h"
#import "UserInfoBasicVC.h"
#import "AddFriendsController.h"
#import "NavViewController.h"
#import "FriendsFriendController.h"
#import "NewFriendViewController.h"
#import "AddFriendViewController.h"
#import "AddFriendTypeListViewController.h"
#import "UserInfoViewController.h"

#import "NewFriendsCell.h"
#import "FriendCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "MyFriendsOperateViewCell.h"
#import "UIImage+ImageEffects.h"
#import "MyFriendUser.h"
#import "NewFriendUser.h"

@interface MyFriendsController () <UISearchBarDelegate,UISearchDisplayDelegate,ABPeoplePickerNavigationControllerDelegate>//,WLSegmentedControlDelegate>

{
    NSInteger _count;
}

@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;//搜索框控件控制器
@property (strong, nonatomic)  UISearchBar *searchBar;//搜索条
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组
@property (nonatomic,strong) NSMutableArray *filterArray;//搜索出来的数据数组

@property (nonatomic, retain) NSOperationQueue *searchQueue;

@end

static NSString *myFriendsOperatecellid = @"MyFriendsOperatecellid";
//static NSString *newFriendcellid = @"newFriendcellid";
static NSString *fridcellid = @"fridcellid";
@implementation MyFriendsController

- (NSString *)title
{
    return @"一度好友";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载好友
    [self loadMyAllFriends];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新的好友改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewFriendsList) name:KNewFriendNotif object:nil];
    //刷新所有好友通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMyAllFriends) name:KupdataMyAllFriends object:nil];
    //获取数据库好友信息
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSArray *myFriends = [loginUser getAllMyFriendUsers];
    _count = myFriends.count;
    self.allArray = [WLHttpTool getChineseStringArr:myFriends];
    
    //添加ui
    [self addUI];
    //获取好友列表
    [self loadMyAllFriends];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addUI
{
    self.filterArray = [NSMutableArray array];
    
    //添加好友
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me_add_friend"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    //搜索栏
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.searchDisplayVC setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
                             forKey:@"_searchResultsTableViewStyle"];
    [self.tableView setTableHeaderView:self.searchBar];
    [self.searchBar setBackgroundImage:[UIImage resizedImage:@"searchbar_bg"]];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMyAllFriends) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSectionIndexColor:KBasesColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, 40)];
    [footLabel setBackgroundColor:[UIColor clearColor]];
    [footLabel setTextColor:[UIColor lightGrayColor]];
    [footLabel setFont:[UIFont systemFontOfSize:15]];
    [footLabel setText:[NSString stringWithFormat:@"%ld位好友",(long)_count]];
    [footLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tableView setTableFooterView:footLabel];
    
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];

    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
}

//重新刷新好友信息数量
- (void)loadNewFriendsList
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)loadMyAllFriends
{
    LogInUser *nowLoginUser = [LogInUser getCurrentLoginUser];
    if (!nowLoginUser.rsMyFriends.count) {
        [WLHUDView showCustomHUD:@"加载好友..." imageview:nil];
    }
    [WLHttpTool loadFriendWithSQL:NO ParameterDic:@{@"uid":@(0)} success:^(id JSON) {
        NSArray *myFriends = [nowLoginUser getAllMyFriendUsers];
        NSArray  *json = [NSArray arrayWithArray:JSON];
        //循环，删除本地数据库多余的缓存数据
        for (int i = 0; i < [myFriends count]; i++){
            MyFriendUser *myFriendUser = myFriends[i];
            //判断返回的数组是否包含
            BOOL isHave = [json bk_any:^BOOL(id obj) {
                //判断是否包含对应的
                return [[obj objectForKey:@"uid"] integerValue] == [myFriendUser uid].integerValue;
            }];
            //删除新的好友本地数据库
            NewFriendUser *newFuser = [nowLoginUser getNewFriendUserWithUid:myFriendUser.uid];
            //本地不存在，不是好友关系
            if(!isHave){
                if (newFuser) {
                    //更新好友请求列表数据为 添加
                    [newFuser updateOperateType:0];
                }
                
                //如果uid大于100的为普通好友，刷新的时候可以删除本地，系统好友，保留
                if(myFriendUser.uid.integerValue > 100){
                    //不包含，删除当前数据
//                    [myFriendUser MR_deleteEntityInContext:nowLoginUser.managedObjectContext];
                    //更新设置为不是我的好友
                    [myFriendUser updateIsNotMyFriend];
                }
            }else{
                //好友
                if (newFuser) {
                    //更新好友请求列表数据为 添加
                    [newFuser updateOperateType:2];
                }
            }
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"isNow",@(YES)];
            LogInUser *loginUser = [LogInUser MR_findFirstWithPredicate:pre inContext:localContext];
            
            //循环添加数据库数据
            for (NSDictionary *modic in json) {
                FriendsUserModel *friendM = [FriendsUserModel objectWithKeyValues:modic];
                friendM.friendship = @(1);
                
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",loginUser,@"uid",friendM.uid];
                MyFriendUser *myFriend = [MyFriendUser MR_findFirstWithPredicate:pre inContext:localContext];
                if (!myFriend) {
                    myFriend = [MyFriendUser MR_createEntityInContext:localContext];
                }
                myFriend.uid = friendM.uid;
                myFriend.mobile = friendM.mobile;
                myFriend.position = friendM.position;
                myFriend.provinceid = friendM.provinceid;
                myFriend.provincename = friendM.provincename;
                myFriend.cityid = friendM.cityid;
                myFriend.cityname = friendM.cityname;
                myFriend.friendship = friendM.friendship;
                myFriend.shareurl = friendM.shareurl;
                myFriend.avatar = friendM.avatar;
                myFriend.name = friendM.name;
                myFriend.address = friendM.address;
                myFriend.email = friendM.email;
                myFriend.investorauth = friendM.investorauth;
                myFriend.startupauth = friendM.startupauth;
                myFriend.company = friendM.company;
                myFriend.status = friendM.status;
                myFriend.isMyFriend = @(YES);
                [loginUser addRsMyFriendsObject:myFriend];
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            [self.refreshControl endRefreshing];
            [WLHUDView hiddenHud];
            
            NSArray *myFriends = [nowLoginUser getAllMyFriendUsers];
            self.allArray = [WLHttpTool getChineseStringArr:myFriends];
            _count = myFriends.count;
            if (self.allArray.count) {
                UILabel *fff = (UILabel*)self.tableView.tableFooterView;
                [fff setText:[NSString stringWithFormat:@"%ld位好友",(long)_count]];
                [self.tableView reloadData];
            }
        }];
        
    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [WLHUDView hiddenHud];
    }];
}

//添加好友
- (void)addFriendClick
{
    AddFriendTypeListViewController *addTypeListVC = [[AddFriendTypeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:addTypeListVC animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableView Datasource&delegate
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return nil;
    }else{
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.allArray.count];
        [arrayM addObject:UITableViewIndexSearch];
        for (NSDictionary *dickey in self.allArray) {
            
            [arrayM addObject:[dickey objectForKey:@"key"]];
            
        }
        return arrayM;
    }
}

//解决加入索引图标混乱
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (index == 0) {
////        [tableView scrollRectToVisible:tableView.tableHeaderView.frame animated:NO];
//        [tableView scrollsToTop];
//    }
//    //返回的是section
//    return index;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return 1;
    }else{
//        return self.allArray.count+1;
         return self.allArray.count;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return self.filterArray.count;
    }else{
        NSDictionary *userF = self.allArray[section];
        return [[userF objectForKey:@"userF"] count];
//        if (section==0) {
//            return 1;
//        }else{
//            NSDictionary *userF = self.allArray[section-1];
//            return [[userF objectForKey:@"userF"] count];
//        }
    }
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.tableView) {
        NSDictionary *dick = self.allArray[section];
        UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        sectionHeader.backgroundColor = WLLineColor;
        sectionHeader.font = [UIFont systemFontOfSize:15];
        sectionHeader.textColor = [UIColor grayColor];
        sectionHeader.text = [NSString stringWithFormat:@"   %@",[dick objectForKey:@"key"]];
        return sectionHeader;
    }else{
        UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        sectionHeader.backgroundColor = WLLineColor;
        sectionHeader.font = [UIFont systemFontOfSize:15];
        sectionHeader.textColor = [UIColor grayColor];
        sectionHeader.text = [NSString stringWithFormat:@"    搜索结果"];
        return sectionHeader;

    }
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
        FriendsUserModel *modeIM = self.filterArray[indexPath.row];
        [fcell setUserMode:modeIM];
        return fcell;
    }else{
//        if (indexPath.section==0) {
//            MyFriendsOperateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myFriendsOperatecellid];
//            if(!cell){
//                cell = [[MyFriendsOperateViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myFriendsOperatecellid];
//            }
//            cell.segementedControl.delegate = self;
//            NSString *badgeStr = [NSString stringWithFormat:@"%@",[LogInUser getCurrentLoginUser].newfriendbadge];
//            cell.segementedControl.bridges = @[badgeStr == nil ? @"0": badgeStr,@"0",@"0",@"0"];
//            return cell;
//        }else{
//            
//            
//        }
        FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
#warning  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++标星好友
        
        NSDictionary *usersDic = self.allArray[indexPath.section];
        NSArray *modear = usersDic[@"userF"];
        FriendsUserModel *modeIM = modear[indexPath.row];
        
        [fcell setUserMode:modeIM];
        return fcell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsUserModel *userMode;
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        userMode = self.filterArray[indexPath.row];
//        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userMode isAsk:NO];
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:userMode OperateType:nil];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
//        if (indexPath.section==0) {
////            if (indexPath.row==0) {
////                NewFriendController *friendNewVC = [[NewFriendController alloc] initWithStyle:UITableViewStyleGrouped];
////                
////                [self.navigationController pushViewController:friendNewVC animated:YES];
////                
////                [self.navigationController.tabBarItem setBadgeValue:nil];
////                [UserDefaults removeObjectForKey:KFriendbadge];
////                
////            }else if (indexPath.row==1){
////                FriendsFriendController *friendsfVC = [[FriendsFriendController alloc] initWithStyle:UITableViewStylePlain];
////                [self.navigationController pushViewController:friendsfVC animated:YES];
////                
////            }
//            return;
//        }else{
//            
//        }
        NSDictionary *usersDic = self.allArray[indexPath.section];
        NSArray *modear = usersDic[@"userF"];
        userMode = modear[indexPath.row];
        [userMode setFriendship:@(1)];
//        UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userMode isAsk:NO];
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:userMode OperateType:nil];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (tableView == self.tableView&&indexPath.section==0) {
    //        return 82.f;
    //    }
    return 60.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section==0&&tableView==self.tableView) {
    //        return 0.0;
    //    }else{
    //        return 25.0;
    //    }
    return 25.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - 搜索本地好友
- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.filterArray removeAllObjects];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    return YES;
}

///现在来实现当搜索文本改变时的回调函数。这个方法使用谓词进行比较，并讲匹配结果赋给searchResults数组:
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
    
    for (NSDictionary *aaa in self.allArray) {
        [self.filterArray addObjectsFromArray:[aaa[@"userF"] filteredArrayUsingPredicate:pre]];
    }
}


////代理函数 获取当前下标
//- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index
//{
//    DLog(@"选中的类型--》 %d",(int)index);
//    switch (index) {
//        case 0:
//        {
//            //新的好友
//            NewFriendViewController *newFriendVC = [[NewFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
//            [self.navigationController pushViewController:newFriendVC animated:YES];
//            [self.navigationController.tabBarItem setBadgeValue:nil];
//            [LogInUser setUserNewfriendbadge:@(0)];
//            //            [UserDefaults removeObjectForKey:KFriendbadge];
//        }
//            break;
//        case 1:
//        case 2:
//        {
//            //1.手机联系人
//            //2.微信好友
//            AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] initWithStyle:UITableViewStyleGrouped WithSelectType:(index == 1 ? 0 : 1)];
//            [self.navigationController pushViewController:addFriendVC animated:YES];
//        }
//            break;
//        case 3:
//        {
//            //好友的好友
//            FriendsFriendController *friendsfVC = [[FriendsFriendController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:friendsfVC animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
