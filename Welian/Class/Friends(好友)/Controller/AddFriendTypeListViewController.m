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
#import "NewFriendViewCell.h"
#import "UserInfoBasicVC.h"

@interface AddFriendTypeListViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController *searchDisplayVC;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) NSMutableArray *filterArray;//搜索出来的数据数组

@end

@implementation AddFriendTypeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加好友";
    
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"手机号/姓名";
    searchBar.delegate = self;
    [searchBar sizeToFit];
    
    UISearchDisplayController *searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayVC.delegate = self;
    searchDisplayVC.searchResultsDataSource = self;
    searchDisplayVC.searchResultsDelegate = self;
//    [searchDisplayVC setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
//                            forKey:@"_searchResultsTableViewStyle"];
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

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _searchDisplayVC.searchResultsTableView && _filterArray.count == 0) {
        UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        sectionHeader.backgroundColor = WLLineColor;
        sectionHeader.font = [UIFont systemFontOfSize:15.f];
        sectionHeader.textColor = [UIColor grayColor];
        sectionHeader.text = [NSString stringWithFormat:@"点击键盘搜索"];
        return sectionHeader;
    }
    return nil;
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
        UserInfoModel *mode = _filterArray[indexPath.row];
        UserInfoBasicVC *userBasic = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
        [self.navigationController pushViewController:userBasic animated:YES];
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
                [self presentViewController:bSearchVC animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _searchDisplayVC.searchResultsTableView) {
        if(_filterArray.count > 0){
            return 0.01f;
        }else{
            return 25.0;
        }
    }else{
        return 10.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

//===============================================
#pragma mark -
#pragma mark UISearchDisplayController相关代理
//===============================================

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
//    [self.filterArray removeAllObjects];
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    return YES;
}

///现在来实现当搜索文本改变时的回调函数。这个方法使用谓词进行比较，并讲匹配结果赋给searchResults数组:
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
//    
//    for (NSDictionary *aaa in self.allArray) {
//        [self.filterArray addObjectsFromArray:[aaa[@"userF"] filteredArrayUsingPredicate:pre]];
//    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_filterArray removeAllObjects];
    [WLHttpTool searchUserParameterDic:@{@"keyword":searchBar.text,@"page":@(1),@"size":@(100)} success:^(id JSON) {
        self.filterArray = JSON;
        if (!_filterArray.count) {
            [WLHUDView showCustomHUD:@"暂无该好友" imageview:nil];
        }
        [_searchDisplayVC.searchResultsTableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_filterArray removeAllObjects];
}

@end
