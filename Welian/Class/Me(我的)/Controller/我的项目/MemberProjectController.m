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
#import "ChineseString.h"
#import "UIBarButtonItem+Badge.h"
#import "CreateHeaderView.h"

@interface MemberProjectController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isEdit;
    IProjectDetailInfo *_projectModel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
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

- (void)reloadItemBadg
{
    NSNumber *badge = @(self.selectArray.count);
    if (badge.integerValue>0) {
        self.navigationItem.rightBarButtonItem.badgeValue = badge.stringValue;
    }else{
        self.navigationItem.rightBarButtonItem.badgeValue = nil;
    }
}

- (instancetype)initIsEdit:(BOOL)isEdit withData:(IProjectDetailInfo *)projectModel
{
    self = [super init];
    if (self) {
        _isEdit = isEdit;
        _projectModel = projectModel;
        [self.view addSubview:self.tableView];
        
        //
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,0,80, 35);
        [button addTarget:self action:@selector(financingProject) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = navLeftButton;
        self.navigationItem.rightBarButtonItem.badgeBGColor = WLRGB(248, 164, 20);
        if (isEdit) {
            [button setTitle:@"保存" forState:UIControlStateNormal];
        }else{
            CreateHeaderView *headerV = [[[NSBundle mainBundle]loadNibNamed:@"CreateHeaderView" owner:nil options:nil] firstObject];
            if (Iphone6plus) {
                [headerV.ImageView setImage:[UIImage imageNamed:@"discovery_buzhou_step_two1242.png"]];
            }else{
                [headerV.ImageView setImage:[UIImage imageNamed:@"discovery_buzhou_step_two640.png"]];
            }
            [headerV setFrame:CGRectMake(0, 0, SuperSize.width, 70)];
            [self.tableView setTableHeaderView:headerV];
            [button setTitle:@"下一步" forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"团队成员"];
    self.selectArray = [NSMutableArray array];
    [WLHttpTool loadFriendWithSQL:YES ParameterDic:nil success:^(id JSON) {
        IBaseUserM *meUserM = [[IBaseUserM alloc] init];
        LogInUser *logUser = [LogInUser getCurrentLoginUser];
        [meUserM setName:logUser.name];
        [meUserM setUid:logUser.uid];
        meUserM.friendship = logUser.friendship;
        meUserM.avatar = logUser.avatar;
        meUserM.company = logUser.company;
        meUserM.position = logUser.position;
        self.allArray = [JSON objectForKey:@"array"];
        [self.allArray insertObject:@{@"key":@"我",@"userF":@[meUserM]} atIndex:0];
        [self.tableView reloadData];
        if (_isEdit) {
            [WLHttpTool getProjectMembersParameterDic:@{@"pid":_projectModel.pid} success:^(id JSON) {
                NSArray *selectA = [IBaseUserM objectsWithInfo:JSON];
                NSMutableArray *seleIndexPath = [NSMutableArray arrayWithCapacity:self.selectArray.count];
                for (IBaseUserM *selectUserM in selectA) {
                    for (NSInteger i = 0; i<self.allArray.count; i++) {
                        NSDictionary *userDic = self.allArray[i];
                        NSArray *userArray = [userDic objectForKey:@"userF"];
                        for (NSInteger j = 0; j<userArray.count; j++) {
                            IBaseUserM *IBuserM = userArray[j];
                            if ([selectUserM.uid.stringValue isEqualToString:IBuserM.uid.stringValue]) {
                                [self.selectArray addObject:IBuserM];
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:i];
                                [seleIndexPath addObject:indexPath];
                            }
                        }
                    }
                }
                
                for (NSIndexPath *indexpath in seleIndexPath) {
                    [self.tableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                }
                [self reloadItemBadg];
            } fail:^(NSError *error) {
                
            }];
        }else{
            // 默认选中自己
            NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
            [self.selectArray addObject:meUserM];
            [self reloadItemBadg];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - tableView代理
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.allArray.count];
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

    return self.allArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSDictionary *userF = self.allArray[section];
    return [[userF objectForKey:@"userF"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 25)];
    [headerView setBackgroundColor:WLRGB(231, 234, 238)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SuperSize.width-20, 25)];
//    headerLabel setTextAlignment:<#(NSTextAlignment)#>
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:WLFONT(15)];
    [headerLabel setTextColor:WLRGB(125, 125, 125)];
    NSDictionary *dick = self.allArray[section];
    [headerLabel setText:[dick objectForKey:@"key"]];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *dick = self.allArray[section];
//    return [dick objectForKey:@"key"];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *fcell = [tableView dequeueReusableCellWithIdentifier:fridcellid];
    NSDictionary *usersDic = self.allArray[indexPath.section];
    NSArray *modear = usersDic[@"userF"];
    IBaseUserM *modeIM = modear[indexPath.row];
    [fcell setUserMode:modeIM];
    return fcell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSDictionary *usersDic = self.allArray[indexPath.section];
        NSArray *modear = usersDic[@"userF"];
        IBaseUserM *modeIM = modear[indexPath.row];
        [self.selectArray addObject:modeIM];
        [self reloadItemBadg];
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *usersDic = self.allArray[indexPath.section];
    NSArray *modear = usersDic[@"userF"];
    IBaseUserM *modeIM = modear[indexPath.row];
    [self.selectArray removeObject:modeIM];
    [self reloadItemBadg];
}


#pragma mrak - 下一步融资
- (void)financingProject
{
    NSMutableDictionary *ProjectMemberDic = [NSMutableDictionary dictionary];
    [ProjectMemberDic setObject:_projectModel.pid forKey:@"pid"];
    NSMutableArray *members = [NSMutableArray array];
    for (IBaseUserM *friendM in self.selectArray) {
        [members addObject:@{@"uid":friendM.uid}];
    }
    [ProjectMemberDic setObject:members forKey:@"members"];
    [WLHttpTool addProjectMembersParameterDic:ProjectMemberDic success:^(id JSON) {
        [_projectModel setMembercount:@(self.selectArray.count)];
       ProjectDetailInfo *projectMR = [ProjectDetailInfo createWithIProjectDetailInfo:_projectModel];
        if (_isEdit) {
            if (self.projectDataBlock) {
                self.projectDataBlock(projectMR);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            FinancingProjectController *financingVC = [[FinancingProjectController alloc] initIsEdit:NO withData:_projectModel];
            [self.navigationController pushViewController:financingVC animated:YES];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
