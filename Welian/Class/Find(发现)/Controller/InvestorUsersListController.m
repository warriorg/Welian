//
//  InvestorUsersListController.m
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorUsersListController.h"
#import "MJRefresh.h"
#import "InvestorUserCell.h"
#import "UIImageView+WebCache.h"
#import "InvestorUserM.h"
#import "UserInfoBasicVC.h"
#import "InvestorUser.h"

@interface InvestorUsersListController () <UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSInteger page;
}
@property (nonatomic,strong) UISearchDisplayController *searchDisplayVC;//搜索框控件控制器
@property (strong, nonatomic)  UISearchBar *searchBar;//搜索条
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组
@property (nonatomic,strong) NSMutableArray *filterArray;//搜索出来的数据数组

@property (nonatomic, retain) NSOperationQueue *searchQueue;

@end

static NSString *identifier = @"investorcellid";
@implementation InvestorUsersListController

// 刷新数据
- (void)loadNewDataArray
{
    page = 1;
    [WLHttpTool loadInvestorUserParameterDic:@{@"page":@(page),@"size":@(20)} success:^(id JSON) {
        [self hideRefreshView];        

        NSArray *arr = JSON;
        [InvestorUser deleteAll];
        for (InvestorUserM *invest in JSON) {
            [InvestorUser createInvestor:invest];
        }
        [self.allArray removeAllObjects];
        self.allArray = [NSMutableArray arrayWithArray:[InvestorUser allInvestorUsers]];
        [self.tableView reloadData];
        if (arr.count<20) {
            [self.tableView setFooterHidden:YES];
        }else{
            [self.tableView setFooterHidden:NO];
        }
    } fail:^(NSError *error) {
        [self hideRefreshView];
    }];
}

// 加载更多
- (void)loadMoreDataArray
{
    [WLHttpTool loadInvestorUserParameterDic:@{@"page":@(page),@"size":@(20)} success:^(id JSON) {
        
        [self hideRefreshView];
        [self.allArray addObjectsFromArray:JSON];
        
        [self.tableView reloadData];
        NSArray *arr = JSON;
        if (arr.count<20) {
            [self.tableView setFooterHidden:YES];
        }else{
            [self.tableView setFooterHidden:NO];
        }
        page++;
    } fail:^(NSError *error) {
        [self hideRefreshView];
    }];
}

- (void)hideRefreshView
{
    [self.refreshControl endRefreshing];
    [self.tableView footerEndRefreshing];
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.allArray = [NSMutableArray arrayWithArray:[InvestorUser allInvestorUsers]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchQueue = [[NSOperationQueue alloc] init];
    [self.searchQueue setMaxConcurrentOperationCount:1];
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
    [self.searchBar setSearchBarStyle:UISearchBarStyleProminent];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.tableView setTableHeaderView:self.searchBar];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadNewDataArray) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
//    [self.tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
    [self.tableView setFooterHidden:YES];
    [self.tableView setBackgroundColor:WLLineColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestorUserCell" bundle:nil] forCellReuseIdentifier:identifier];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.searchDisplayVC.searchResultsTableView setBackgroundColor:WLLineColor];
    [self.searchDisplayVC.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"InvestorUserCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self loadNewDataArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.tableView) {
        
        return self.allArray.count;
    }else{
        return self.filterArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    InvestorUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    InvestorUserM *invesM = self.allArray[indexPath.row];
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        invesM = self.filterArray[indexPath.row];
    }
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:invesM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    [cell.nameLabel setText:invesM.name];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@  %@",invesM.position,invesM.company]];
    [cell.caseLabel setText:[NSString stringWithFormat:@"投资案例:%@",invesM.items?invesM.items:@"暂无"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InvestorUserM *invesM = self.allArray[indexPath.row];
    if (tableView == self.searchDisplayVC.searchResultsTableView) {
        invesM = self.filterArray[indexPath.row];
    }
    UserInfoModel *mode = [[UserInfoModel alloc] init];
    [mode setName:invesM.name];
    [mode setUid:invesM.uid];
    [mode setCompany:invesM.company];
    [mode setPosition:invesM.position];
    [mode setAvatar:invesM.avatar];
    [mode setFriendship:invesM.friendship];
    [mode setInvestorauth:invesM.investorauth];
    [mode setStartupauth:invesM.startupauth];
    [mode setProvincename:invesM.provincename];
    [mode setCityname:invesM.cityname];
    
    UserInfoBasicVC *userInfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:mode isAsk:NO];
    
    [self.navigationController pushViewController:userInfoVC animated:YES];
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if  ([searchString isEqualToString:@""] == NO)
    {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //异步
//            [self loadSearchDataArray:searchString];
//        });
        

        [self.searchQueue cancelAllOperations];
        [self.searchQueue addOperationWithBlock:^{
            
            [self loadSearchDataArray:searchString];
            
        }];
        
        return NO;
    }
    else
    {
        [self.filterArray removeAllObjects];
        return YES;
    }
    
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.searchQueue cancelAllOperations];
}

- (void)loadSearchDataArray:(NSString *)searchString
{
    
    [WLHttpTool loadInvestorUserParameterDic:@{@"page":@(page),@"size":@(200000),@"keyword":searchString} success:^(id JSON) {
        
        [self.filterArray removeAllObjects];
        self.filterArray = [NSMutableArray arrayWithArray:JSON];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchDisplayVC.searchResultsTableView reloadData];
        });
        

    } fail:^(NSError *error) {
        
    }];
}

@end
