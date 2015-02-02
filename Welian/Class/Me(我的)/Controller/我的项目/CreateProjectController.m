//
//  CreateProjectController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CreateProjectController.h"
#import "MemberProjectController.h"

@interface CreateProjectController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CreateProjectController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (instancetype)initIsEdit:(BOOL)isEdit
{
    self = [super init];
    if (self) {
        if (!isEdit) {
            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 90)]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(addMemberProject)];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目简介"];
}


#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}


#pragma mark - 下一步团队成员
- (void)addMemberProject
{
    MemberProjectController *memberVC = [[MemberProjectController alloc] initIsEdit:NO];
    [self.navigationController pushViewController:memberVC animated:YES];
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
