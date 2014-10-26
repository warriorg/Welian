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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.allArray.count) {
        [self loadNewDataArray];
    }
}


// 刷新数据
- (void)loadNewDataArray
{
    page = 0;
    [WLHttpTool loadInvestorUserParameterDic:@{@"page":@(page),@"size":@(20)} success:^(id JSON) {
        [self hideRefreshView];        
        [self.allArray removeAllObjects];
        NSArray *arr = JSON;
        self.allArray = [NSMutableArray arrayWithArray:JSON];

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchQueue = [[NSOperationQueue alloc] init];
    [self.searchQueue setMaxConcurrentOperationCount:1];
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setDelegate:self];
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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestorUserCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    [self.searchDisplayVC.searchResultsTableView setBackgroundColor:WLLineColor];
    [self.searchDisplayVC.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchDisplayVC.searchResultsTableView registerNib:[UINib nibWithNibName:@"InvestorUserCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [cell setInvestorM:invesM];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

@end
