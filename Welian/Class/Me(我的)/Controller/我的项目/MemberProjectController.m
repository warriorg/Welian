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
        
//        _tableView selectRowAtIndexPath:<#(NSIndexPath *)#> animated:<#(BOOL)#> scrollPosition:<#(UITableViewScrollPosition)#>
//        [_tableView setSectionHeaderHeight:20];
    }
    return _tableView;
}

- (instancetype)initIsEdit:(BOOL)isEdit
{
    self = [super init];
    if (self) {
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
    [self setTitle:@"选择团队成员"];
    self.selectArray = [NSMutableArray array];
    [WLHttpTool loadFriendWithSQL:YES ParameterDic:nil success:^(id JSON) {
        self.allArray = [JSON objectForKey:@"array"];
        [self.tableView reloadData];
        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self.selectArray addObject:[LogInUser getCurrentLoginUser]];
    } fail:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
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
        
//        [fcell setSelected:YES animated:YES];
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

//对编辑的状态下提交的事件响应
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"commond eidting style ");
//    if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

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
    FinancingProjectController *financingVC = [[FinancingProjectController alloc] initIsEdit:NO];
    [self.navigationController pushViewController:financingVC animated:YES];
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
