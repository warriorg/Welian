//
//  MemberProjectController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "MemberProjectController.h"
#import "FinancingProjectController.h"
#import "FriendCell.h"

@interface MemberProjectController () <UITableViewDataSource, UITableViewDelegate>
{
    IProjectDetailInfo *_projectModel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *allArray;
@end

static NSString *fridcellid = @"fridcellid";
@implementation MemberProjectController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setDelegate: self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:fridcellid];
        [_tableView setSectionFooterHeight:0.01];
        [_tableView setEditing:YES];
    }
    return _tableView;
}

- (instancetype)initIsEdit:(BOOL)isEdit withData:(IProjectDetailInfo *)projectModel
{
    self = [super init];
    if (self) {
        _projectModel = projectModel;
        [self.view addSubview:self.tableView];
        if (!isEdit) {
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 90)]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(financingProject)];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"团队成员"];
    self.selectArray = [NSMutableArray array];
    [WLHttpTool loadFriendWithSQL:YES ParameterDic:nil success:^(id JSON) {
        self.allArray = [JSON objectForKey:@"array"];
        [self.tableView reloadData];
        
        // 默认选中自己
        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self.selectArray addObject:[LogInUser getCurrentLoginUser]];
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - tableView代理
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.allArray.count];
    [arrayM addObject:@"我"];
    for (NSDictionary *dickey in self.allArray) {
        [arrayM addObject:[dickey objectForKey:@"key"]];
    }
    return arrayM;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.allArray.count+1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        NSDictionary *userF = self.allArray[section-1];
            
        return [[userF objectForKey:@"userF"] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section) {
        NSDictionary *dick = self.allArray[section-1];
        return [dick objectForKey:@"key"];
    }
    return @"我";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
    if (indexPath.section==0) {
        
        [fcell setUserMode:[LogInUser getCurrentLoginUser]];
    }else{
        NSDictionary *usersDic = self.allArray[indexPath.section-1];
        NSArray *modear = usersDic[@"userF"];
        FriendsUserModel *modeIM = modear[indexPath.row];
        
        [fcell setUserMode:modeIM];
    }
    
    return fcell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DLog(@"选中自己");
        [self.selectArray addObject:[LogInUser getCurrentLoginUser]];
    }else{
        NSDictionary *usersDic = self.allArray[indexPath.section-1];
        NSArray *modear = usersDic[@"userF"];
        FriendsUserModel *modeIM = modear[indexPath.row];
        [self.selectArray addObject:modeIM];
    }
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DLog(@"取消自己");
        [self.selectArray removeObject:[LogInUser getCurrentLoginUser]];
    }else{
        NSDictionary *usersDic = self.allArray[indexPath.section-1];
        NSArray *modear = usersDic[@"userF"];
        FriendsUserModel *modeIM = modear[indexPath.row];
        [self.selectArray removeObject:modeIM];
    }
}


#pragma mrak - 下一步融资
- (void)financingProject
{
    NSMutableDictionary *ProjectMemberDic = [NSMutableDictionary dictionary];
    [ProjectMemberDic setObject:_projectModel.pid forKey:@"pid"];
    NSMutableArray *members = [NSMutableArray array];
    for (FriendsUserModel *friendM in self.selectArray) {
        [members addObject:@{@"uid":friendM.uid}];
    }
    [ProjectMemberDic setObject:members forKey:@"members"];
    [WLHttpTool addProjectMembersParameterDic:ProjectMemberDic success:^(id JSON) {
        FinancingProjectController *financingVC = [[FinancingProjectController alloc] initIsEdit:NO withData:_projectModel];
        [self.navigationController pushViewController:financingVC animated:YES];
    } fail:^(NSError *error) {
        
    }];
    DLog(@"%@",self.selectArray);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
