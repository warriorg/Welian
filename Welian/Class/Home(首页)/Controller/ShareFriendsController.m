//
//  ShareFriendsController.m
//  Welian
//
//  Created by dong on 15/3/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ShareFriendsController.h"
#import "FriendCell.h"
#import "UIImage+ImageEffects.h"

@interface ShareFriendsController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *allArray;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;//搜索框控件控制器
@property (strong, nonatomic)  UISearchBar *searchBar;//搜索条
@property (nonatomic,strong) NSMutableArray *filterArray;//搜索出来的数据数组

@property (nonatomic, retain) NSOperationQueue *searchQueue;

@end

static NSString *fridcellid = @"fridcellid";
@implementation ShareFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSelf)];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    [self.searchBar setSearchBarStyle:UISearchBarStyleProminent];
    [self.searchBar setBackgroundImage:[UIImage resizedImage:@"searchbar_bg"]];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.tableView setTableHeaderView:self.searchBar];
    
    [WLHttpTool loadFriendWithSQL:YES ParameterDic:nil success:^(id JSON) {
        
        self.allArray = [JSON objectForKey:@"array"];
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - tableView代理
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.allArray.count];
        [arrayM addObject:UITableViewIndexSearch];
        for (NSDictionary *dickey in self.allArray) {
            [arrayM addObject:[dickey objectForKey:@"key"]];
        }
        return arrayM;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {

        return self.allArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        
        NSDictionary *userF = self.allArray[section];
        return [[userF objectForKey:@"userF"] count];
    }else{
        return self.filterArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 25)];
//    [headerView setBackgroundColor:WLRGB(231, 234, 238)];
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SuperSize.width-20, 25)];
//    //    headerLabel setTextAlignment:<#(NSTextAlignment)#>
//    [headerLabel setBackgroundColor:[UIColor clearColor]];
//    [headerLabel setFont:WLFONT(15)];
//    [headerLabel setTextColor:WLRGB(125, 125, 125)];
//    NSDictionary *dick = self.allArray[section];
//    [headerLabel setText:[dick objectForKey:@"key"]];
//    [headerView addSubview:headerLabel];
//    
//    return headerView;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        NSDictionary *dick = self.allArray[section];
        return [dick objectForKey:@"key"];
    }else{
        return @"搜索到：";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
    if (tableView == self.tableView) {
        NSDictionary *usersDic = self.allArray[indexPath.section];
        NSArray *modear = usersDic[@"userF"];
        IBaseUserM *modeIM = modear[indexPath.row];
        [fcell setUserMode:modeIM];
    }else{
        IBaseUserM *modeIm = self.filterArray[indexPath.row];
        fcell.userMode = modeIm;
    }
    
    return fcell;
}


#pragma mark - 搜索
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

- (void)cancelSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
