//
//  FriendsFriendController.m
//  weLian
//
//  Created by dong on 14/10/28.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsFriendController.h"
#import "UserInfoBasicVC.h"
#import "UserInfoViewController.h"

#import "NotstringView.h"
#import "MJRefresh.h"
#import "InvestorUserCell.h"
#import "UIImageView+WebCache.h"
#import "FriendsinfoModel.h"
#import "FriendsFriendModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface FriendsFriendController ()
{
    NSInteger page;
}
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组

@property (nonatomic, strong) NotstringView *notView;
@end

static NSString *identifier = @"investorcellid";

@implementation FriendsFriendController

- (NotstringView *)notView
{
    if (_notView == nil ) {
        _notView = [[NotstringView alloc] initWithFrame:self.tableView.frame withTitStr:@"还没有好友的好友。" andImageName:@"remind_big_nostring"];
    }
    return _notView;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self= [super initWithStyle:style];
    if (self) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(loadNewDataArray) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];
        [self.refreshControl beginRefreshing];
        
        [self.tableView setBackgroundColor:WLLineColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"InvestorUserCell" bundle:nil] forCellReuseIdentifier:identifier];
        //上提加载更多
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataArray)];
        // 隐藏当前的上拉刷新控件
        self.tableView.footer.hidden = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"好友的好友"];
    [self loadNewDataArray];
    
}

- (void)hideRefreshView
{
    [self.refreshControl endRefreshing];
    [self.tableView.footer endRefreshing];
}


// 刷新数据
- (void)loadNewDataArray
{
    self.tableView.footer.hidden = YES;
    page = 1;
    [WLHttpTool loadUser2FriendParameterDic:@{@"uid":@(0),@"page":@(page),@"size":@(15)} success:^(id JSON) {
        [self.allArray removeAllObjects];
        FriendsFriendModel *friendsM = [FriendsFriendModel objectWithKeyValues:JSON];
        
        self.allArray = [NSMutableArray arrayWithArray:friendsM.friends];
        [self setTitle:[NSString stringWithFormat:@"好友的好友%@人",friendsM.count]];
        
        [self.tableView reloadData];
        [self hideRefreshView];
        if (friendsM.friends.count>=15) {
            self.tableView.footer.hidden = NO;
        }
        page++;
        if (!self.allArray.count) {
            [self.tableView addSubview:self.notView];
        }
    } fail:^(NSError *error) {
        [self hideRefreshView];
    }];
}

// 加载更多
- (void)loadMoreDataArray
{   
    [WLHttpTool loadUser2FriendParameterDic:@{@"uid":@(0),@"page":@(page),@"size":@(15)} success:^(id JSON) {
        
        FriendsFriendModel *friendsM = [FriendsFriendModel objectWithKeyValues:JSON];
        [self.allArray addObjectsFromArray:friendsM.friends];

        [self.tableView reloadData];

        if (friendsM.friends.count<15) {
            self.tableView.footer.hidden = YES;
        }else{
            self.tableView.footer.hidden = NO;
        }
        [self hideRefreshView];
        page++;
    } fail:^(NSError *error) {
        [self hideRefreshView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InvestorUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    FriendsinfoModel *friendinfoM = self.allArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:friendinfoM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    [cell.nameLabel setText:friendinfoM.name];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@  %@",friendinfoM.position,friendinfoM.company]];
    
    NSMutableString *labestr = [NSMutableString string];
    for (UserInfoModel *mode in friendinfoM.samefriends) {
        [labestr appendFormat:@"%@、",mode.name];
    }
    
    if ([labestr hasSuffix:@"、"]) {
        NSRange range = {[labestr length]-1,1};
        [labestr deleteCharactersInRange:range];
    }
    if ([friendinfoM.samefriendcount integerValue]>2) {
        [labestr appendFormat:@"等%@人可为您引荐",friendinfoM.samefriendcount];
    }else{
        [labestr appendString:@"可为您引荐"];
    }
    [cell.caseLabel setText:labestr];
    if (friendinfoM.investorauth.integerValue==1) {
        [cell.investorauthImage setHidden:NO];
    }else{
        [cell.investorauthImage setHidden:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsinfoModel *friendinfoM = self.allArray[indexPath.row];
    
//    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:friendinfoM isAsk:NO];
//    [self.navigationController pushViewController:userinfoVC animated:YES];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithBaseUserM:friendinfoM OperateType:nil];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}


@end
