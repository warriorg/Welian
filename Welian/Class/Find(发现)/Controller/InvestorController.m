//
//  InvestorController.m
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorController.h"


@interface InvestorController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayVC;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *searArray;

@property (nonatomic, strong) UITableView *distableView;
@property (nonatomic, strong) NSArray *disArray;
@end

@implementation InvestorController

- (UITableView*)distableView
{
    if (nil == _distableView) {
        _distableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-216) style:UITableViewStylePlain];
        [_distableView setDataSource:self];
        [_distableView setDelegate: self];
        [_distableView setBackgroundColor:[UIColor redColor]];
    }
    
    return _distableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 加载数据
    [self loadData];
    // 加载UI
    [self loadUIview];
}

- (void)loadData
{
    self.disArray = @[@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111",@"1111"];
    
//    UserInfoModel *mo = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];

    
//    [WLHttpTool loadFeedParameterDic:@{@"start":@(0),@"size":@(20),@"uid":@(uid)} success:^(id JSON) {
//        self.dataArray = [NSArray arrayWithArray:JSON];
//        [self.tableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];
    
}


#pragma mark -     // 加载UI
- (void)loadUIview
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setPlaceholder:@"搜索"];
    [self.searchBar setDelegate:self];
    
    [self.tableView setTableHeaderView:self.searchBar];
    [self.searchBar sizeToFit];
    self.searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.searchDisplayVC setSearchResultsDataSource:self];
    [self.searchDisplayVC setSearchResultsDelegate:self];
    [self.searchDisplayVC setSearchResultsTitle:@"132"];
    [self.searchDisplayVC setDelegate:self];
    [self.searchDisplayVC setActive:NO animated:YES];
    
}



- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}


- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.view addSubview:self.distableView];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self.distableView removeFromSuperview];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [self.view addSubview:self.distableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{}


- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.distableView removeFromSuperview];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.distableView removeFromSuperview];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.distableView removeFromSuperview];
}



#pragma mark - table 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        
        return self.dataArray.count;
    }else if (tableView == self.distableView){
        return self.disArray.count;
    }else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellindanfi = @"cellindanf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindanfi];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindanfi];
    }
    
    if (tableView == self.distableView) {
        [cell.textLabel setText:self.disArray[indexPath.row]];
    }else if (tableView == self.tableView){
        NSDictionary *da = self.dataArray[indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"%d",[da objectForKey:@"fid"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.distableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.searchBar setText:cell.textLabel.text];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
