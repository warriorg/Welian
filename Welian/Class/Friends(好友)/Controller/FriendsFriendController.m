//
//  FriendsFriendController.m
//  weLian
//
//  Created by dong on 14/10/28.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsFriendController.h"
#import "MJRefresh.h"
#import "InvestorUserCell.h"
#import "UIImageView+WebCache.h"
#import "FriendsinfoModel.h"
#import "FriendsFriendModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "UserInfoBasicVC.h"

@interface FriendsFriendController ()
{
    NSInteger page;
}
@property (nonatomic,strong) NSMutableArray *allArray;//所有数据数组
@end

static NSString *identifier = @"investorcellid";

@implementation FriendsFriendController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (!self.allArray.count) {
//        
//    }
//}

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
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreDataArray)];
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
    [self.tableView footerEndRefreshing];
}


// 刷新数据
- (void)loadNewDataArray
{
    [self.tableView setFooterHidden:YES];
    page = 1;
    [WLHttpTool loadUser2FriendParameterDic:@{@"uid":@(0),@"page":@(page),@"size":@(15)} success:^(id JSON) {
        [self.allArray removeAllObjects];
        FriendsFriendModel *friendsM = [FriendsFriendModel objectWithKeyValues:JSON];
        
        self.allArray = [NSMutableArray arrayWithArray:friendsM.friends];
        [self setTitle:[NSString stringWithFormat:@"好友的好友%@人",friendsM.count]];
        
        [self.tableView reloadData];
        [self hideRefreshView];
        if (friendsM.friends.count>=15) {
            [self.tableView setFooterHidden:NO];
        }
        page++;
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
            [self.tableView setFooterHidden:YES];
        }else{
            [self.tableView setFooterHidden:NO];
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
    
    UserInfoBasicVC *userinfoVC = [[UserInfoBasicVC alloc] initWithStyle:UITableViewStyleGrouped andUsermode:friendinfoM isAsk:NO];
    [self.navigationController pushViewController:userinfoVC animated:YES];
}


@end
