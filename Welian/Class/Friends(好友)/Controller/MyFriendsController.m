//
//  MyFriendsController.m
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MyFriendsController.h"
#import "NewFriendsCell.h"
#import "FriendCell.h"
#import "UserInfoBasicVC.h"
#import "AddFriendsController.h"
#import "NavViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WLDataDBTool.h"
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "NewFriendController.h"

@interface MyFriendsController () <UISearchBarDelegate,UISearchDisplayDelegate,SWTableViewCellDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;//搜索框控件控制器
@property (strong, nonatomic)  UISearchBar *searchBar;//搜索条
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组
@property (nonatomic,strong) NSMutableArray *filterArray;//搜索出来的数据数组

@property (nonatomic, retain) NSOperationQueue *searchQueue;

@property (nonatomic, strong) NSArray *friendsNewArrayM;

@end

static NSString *newFriendcellid = @"newFriendcellid";
static NSString *fridcellid = @"fridcellid";
@implementation MyFriendsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadMyAllFriends];
    [self loadNewFriendsList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewFriendsList) name:KNewFriendNotif object:nil];
    [WLHttpTool loadFriendWithSQL:YES ParameterDic:nil success:^(id JSON) {
        self.allArray = JSON;
        if (self.allArray.count) {
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
    [self addUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNewFriendNotif object:nil];
}

- (void)addUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendClick)];
    self.filterArray = [NSMutableArray array];
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.tableView setTableHeaderView:self.searchBar];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMyAllFriends) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    //    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
//    [self.tableView setBackgroundColor:WLLineColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSectionIndexColor:KBasesColor];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, 40)];
    [footLabel setBackgroundColor:[UIColor clearColor]];
    [footLabel setTextColor:[UIColor lightGrayColor]];
    [footLabel setFont:[UIFont systemFontOfSize:15]];
    [footLabel setText:[NSString stringWithFormat:@"%d位好友",self.allArray.count]];
    [footLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tableView setTableFooterView:footLabel];
    
    [self.searchDisplayVC.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewFriendsCell" bundle:nil] forCellReuseIdentifier:newFriendcellid];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
    self.friendsNewArrayM = [[WLDataDBTool sharedService] getAllItemsFromTable:KNewFriendsTableName];
}

- (void)loadNewFriendsList
{
    [WLHttpTool loadFriendRequestParameterDic:@{@"page":@(0),@"size":@(100)} success:^(id JSON) {
        NSArray *newArray = JSON;
        if (newArray.count) {
            
            for (NSDictionary *modic in newArray) {
                NSMutableDictionary *newFMDic = [NSMutableDictionary dictionaryWithDictionary:modic];
                [newFMDic setObject:@"0" forKey:@"isAgree"];
                [[WLDataDBTool sharedService] putObject:newFMDic withId:[newFMDic objectForKey:@"fid"] intoTable:KNewFriendsTableName];
                self.friendsNewArrayM = [[WLDataDBTool sharedService] getAllItemsFromTable:KNewFriendsTableName];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    

}


-(void)loadMyAllFriends
{
    [WLHttpTool loadFriendWithSQL:NO ParameterDic:@{@"uid":@(0)} success:^(id JSON) {

        [self.refreshControl endRefreshing];
        self.allArray = JSON;
        if (self.allArray.count) {
            UILabel *fff = (UILabel*)self.tableView.tableFooterView;
            [fff setText:[NSString stringWithFormat:@"%d位好友",self.allArray.count]];
            [self.tableView reloadData];
        }

    } fail:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}


- (void)addFriendClick
{
    [self presentViewController:[[NavViewController alloc] initWithRootViewController:[[AddFriendsController alloc] initWithStyle:UITableViewStylePlain]] animated:YES completion:^{
        
    }];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

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

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        [tableView scrollRectToVisible:tableView.tableHeaderView.frame animated:NO];
    }
    //返回的是section
    return index-1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return 1;
    }else{
        return self.allArray.count+1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return self.filterArray.count;
    }else{
        
        if (section==0) {
            return 2;
        }else{
            NSDictionary *userF = self.allArray[section-1];
            
            return [[userF objectForKey:@"userF"] count];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        return nil;
    }else{
        if (section==0) {
            return @"{search}";
        }else{
            NSDictionary *dick = self.allArray[section-1];
            return [NSString stringWithFormat:@"   %@",[dick objectForKey:@"key"]];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.0;
    }else{
        return 20.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
        UserInfoModel *modeIM = self.filterArray[indexPath.row];
        [fcell setUserMode:modeIM];
        [fcell setDelegate:self];
        return fcell;
    }else{
        if (indexPath.section==0) {
            NewFriendsCell *ncell = [tableView dequeueReusableCellWithIdentifier:newFriendcellid];
            if (indexPath.row==0) {
                [ncell.titLabel setText:@"新的好友"];
                [ncell.iconImage setImage:[UIImage imageNamed:@"me_myfriend_add"]];
                
                [ncell.tipLabel setEnabled:NO];
                [ncell.tipLabel setTitle:[NSString stringWithFormat:@"%@",self.navigationController.tabBarItem.badgeValue] forState:UIControlStateDisabled];
                
                if ([self.navigationController.tabBarItem.badgeValue integerValue]) {
                    
                    [ncell.tipLabel setHidden:NO];
                }else{
                    [ncell.tipLabel setHidden:YES];
                }
            }else{
                [ncell.titLabel setText:@"好友的好友"];
                [ncell.iconImage setImage:[UIImage imageNamed:@"me_myfriend_more"]];
                [ncell.tipLabel setHidden:YES];
                [ncell.titLabel sizeToFit];
            }
            return ncell;
        }else{
            
            FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
            [fcell setRightUtilityButtons:[self rightButtons]];
            [fcell setDelegate:self];
            
            NSDictionary *usersDic = self.allArray[indexPath.section-1];
            NSArray *modear = usersDic[@"userF"];
            UserInfoModel *modeIM = modear[indexPath.row];
            
            [fcell setUserMode:modeIM];
            return fcell;
        }
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *userMode;
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        userMode = self.filterArray[indexPath.row];

    }else{
        if (indexPath.section==0) {
            [self.navigationController.tabBarItem setBadgeValue:nil];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            NewFriendController *friendNewVC = [[NewFriendController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:friendNewVC animated:YES];
        }else{
            NSDictionary *usersDic = self.allArray[indexPath.section-1];
            NSArray *modear = usersDic[@"userF"];
            userMode = modear[indexPath.row];
            
            UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:userMode];
            
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
        
    }
}


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



- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor lightGrayColor] normalIcon:[UIImage imageNamed:@"me_myfriend_star"] selectedIcon:[UIImage imageNamed:@"me_myfriend_star_pre"]];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            DLog(@"utility buttons closed");
            break;
        case 1:
            DLog(@"left utility buttons open");
            break;
        case 2:
            DLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            DLog(@"left button 0 was pressed");
            break;
        case 1:
            DLog(@"left button 1 was pressed");
            break;
        case 2:
            DLog(@"left button 2 was pressed");
            break;
        case 3:
            DLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    return YES;
}



//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"aa";
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
