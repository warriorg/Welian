//
//  UserInfoController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoController.h"
#import "InfoHeaderView.h"
#import "NameController.h"

@interface UserInfoController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) InfoHeaderView *infoHeader;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation UserInfoController

- (InfoHeaderView*)infoHeader
{
    if (nil == _infoHeader) {
        
        _infoHeader = [[[NSBundle mainBundle] loadNibNamed:@"InfoHeaderView" owner:self options:nil] lastObject];
    }
    return _infoHeader;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加入weLian"];
    self.dataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"姓名":@"",@"单位":@"",@"职务":@""}];
    [self.view addSubview:self.tableView];
}


#pragma mark ---tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSArray *array = self.dataDic.allKeys;
    [cell.textLabel setText:array[indexPath.row]];
    [cell.detailTextLabel setText:[self.dataDic objectForKey:array[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 170.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.infoHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"姓名"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"姓名"]];
        [self.navigationController pushViewController:nameVC animated:YES];
        
    }else if (indexPath.row ==1){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"单位"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"单位"]];
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if (indexPath.row == 2){
        NameController *nameVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDic setObject:userInfo forKey:@"职务"];
            [self.tableView reloadData];
        }];
        [nameVC setUserInfoStr:self.dataDic[@"职务"]];
        [self.navigationController pushViewController:nameVC animated:YES];
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
