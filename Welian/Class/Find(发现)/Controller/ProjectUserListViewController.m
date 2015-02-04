//
//  ProjectUserListViewController.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectUserListViewController.h"

@interface ProjectUserListViewController ()

@property (strong,nonatomic) NSArray *datasource;

@end

@implementation ProjectUserListViewController

- (void)dealloc
{
    _datasource = nil;
    _projectDetailInfo = nil;
}

- (NSString *)title
{
    switch (_infoType) {
        case UserInfoTypeProjectGroup:
            return @"团队成员";
            break;
        case UserInfoTypeProjectZan:
            return @"赞过的人";
            break;
        default:
            return @"朋友列表";
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏tableiView分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //上提加载更多
//    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
    
    switch (_infoType) {
        case UserInfoTypeProjectGroup:
            [self initGroupUserData];
            break;
        case UserInfoTypeProjectZan:
            [self initZanUserData];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //微信联系人
    static NSString *cellIdentifier = @"Project_UserList_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//取赞的用户列表
- (void)initZanUserData
{
    [WLHttpTool getProjectZanUsersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(1),@"size":@(20)}
                                       success:^(id JSON) {
                                           
                                       } fail:^(NSError *error) {
                                           [UIAlertView showWithError:error];
                                       }];
}

//取团队成员的用户列表
- (void)initGroupUserData
{
    [WLHttpTool getProjectMembersParameterDic:@{@"pid":_projectDetailInfo.pid,@"page":@(1),@"size":@(20)}
                                      success:^(id JSON) {
                                          
                                      } fail:^(NSError *error) {
                                          [UIAlertView showWithError:error];
                                      }];
}

@end
