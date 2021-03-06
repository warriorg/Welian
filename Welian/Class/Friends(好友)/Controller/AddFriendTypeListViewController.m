//
//  AddFriendTypeListViewController.m
//  Welian
//
//  Created by weLian on 15/1/8.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "AddFriendTypeListViewController.h"
#import "AddFriendViewController.h"
#import "BSearchFriendsController.h"
#import "NavViewController.h"
#import "UserInfoViewController.h"
#import "UIImage+ImageEffects.h"
#import "NewFriendViewCell.h"

@interface AddFriendTypeListViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController *searchDisplayVC;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) NSMutableArray *filterArray;//搜索出来的数据数组
@property (assign, nonatomic) BOOL isFromMeVC;

@end

@implementation AddFriendTypeListViewController

- (NSString *)title
{
    return @"添加好友";
}

- (instancetype)initWithStyle:(UITableViewStyle)style fromMe:(BOOL)isFromMeVC
{
    self = [super initWithStyle:style];
    if (self) {
        self.isFromMeVC = isFromMeVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //显示导航条
    if (_isFromMeVC) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.hidden = NO;
    }
    
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"手机号/姓名";
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage resizedImage:@"searchbar_bg"]];
    [searchBar sizeToFit];
    
    UISearchDisplayController *searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayVC.delegate = self;
    searchDisplayVC.searchResultsDataSource = self;
    searchDisplayVC.searchResultsDelegate = self;
//    [searchDisplayVC setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
//                            forKey:@"_searchResultsTableViewStyle"];
    [searchDisplayVC setActive:NO animated:YES];
    searchDisplayVC.searchResultsTableView.backgroundColor = WLLineColor;
    searchDisplayVC.searchResultsTableView.separatorInset = UIEdgeInsetsZero;
    self.searchDisplayVC = searchDisplayVC;
    [self.tableView setTableHeaderView:searchBar];
    
    self.datasource = @[@{@"logo":@"me_myfriend_add_phone_logo",@"name":@"手机联系人"},
                        @{@"logo":@"me_myfriend_add_wechat_logo",@"name":@"微信好友"},
                        @{@"logo":@"me_myfriend_add_renda_logo",@"name":@"雷达搜索"}];
}

//===============================================
#pragma mark -
#pragma mark - tableView相关代理
//===============================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchDisplayVC.searchResultsTableView) {
        return _filterArray.count;
    }else{
        return _datasource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"AddFriendTypeListCellIdentifier";
    
    NewFriendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewFriendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == _searchDisplayVC.searchResultsTableView) {
        //搜索的好友
        cell.userInfoModel = _filterArray[indexPath.row];
    }else{
        cell.dicData = _datasource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _searchDisplayVC.searchResultsTableView) {
        IBaseUserM *mode = _filterArray[indexPath.row];

        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:(IBaseUserM *)mode OperateType:nil HidRightBtn:NO];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:
            case 1:
            {
                //手机和微信添加好友
                AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] initWithStyle:UITableViewStyleGrouped WithSelectType:indexPath.row];
                [self.navigationController pushViewController:addFriendVC animated:YES];
            }
                break;
            case 2:
            {
                //雷达搜索
                BSearchFriendsController *bSearchVC = [[BSearchFriendsController alloc] init];
                NavViewController *nav = [[NavViewController alloc] initWithRootViewController:bSearchVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchDisplayVC.searchResultsTableView) {
        IBaseUserM *mode = _filterArray[indexPath.row];
        return [NewFriendViewCell configureWithName:mode.name message:[NSString stringWithFormat:@"%@ %@",mode.company,mode.position]];
    }else{
        return 60.f;
    }
}

//===============================================
#pragma mark -
#pragma mark UISearchDisplayController相关代理
//===============================================

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.filterArray removeAllObjects];
    if ([self.filterArray count] == 0) {
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        for( UIView *subview in tableView1.subviews ) {
            if( [subview class] == [UILabel class] ) {
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                lbl.text = @"";
            }
        }
    }
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_filterArray removeAllObjects];
    [WeLianClient searchUserWithKeyword:searchBar.text
                                   Page:@(1)
                                   Size:@(1000)
                                Success:^(id resultInfo) {
                                    self.filterArray = resultInfo;
                                    if (!_filterArray.count) {
                                        [WLHUDView showCustomHUD:@"暂无该好友" imageview:nil];
                                    }
                                    [_searchDisplayVC.searchResultsTableView reloadData];
                                } Failed:^(NSError *error) {
                                    
                                }];
//    [WLHttpTool searchUserParameterDic:@{@"keyword":searchBar.text,@"page":@(1),@"size":@(100)} success:^(id JSON) {
//        self.filterArray = JSON;
//        if (!_filterArray.count) {
//            [WLHUDView showCustomHUD:@"暂无该好友" imageview:nil];
//        }
//        [_searchDisplayVC.searchResultsTableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_filterArray removeAllObjects];
}

@end
