//
//  InvestListController.m
//  weLian
//
//  Created by dong on 14-10-9.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestListController.h"
#import "NameController.h"
#import "NavViewController.h"
#import "InvestAuthModel.h"
#import "NoListView.h"

@interface InvestListController ()

@property (nonatomic, strong) NSMutableArray *dataArrayM;
@property (nonatomic, strong) NoListView *nolistView;
@end

@implementation InvestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrayM = [NSMutableArray array];
    [self loadUIview];
    
}

- (NoListView*)nolistView
{
    if (_nolistView == nil) {
        _nolistView = [[[NSBundle mainBundle] loadNibNamed:@"NoListView" owner:self options:nil] lastObject];
        [_nolistView setFrame:self.view.bounds];
//        [_nolistView setCenter:self.view.center];
    }
    return _nolistView;
}


- (void)setInvestM:(InvestAuthModel *)investM
{
    _investM = investM;
    if (investM.itemsArray.count) {
        for (NSString *item in investM.itemsArray) {
            [self.dataArrayM addObject:item];
        }
        [self.tableView reloadData];
    }else{
        if (self.nolistView.superview==nil) {
            
            [self.tableView addSubview:self.nolistView];
        }
    }

}

#pragma mark - 加载页面UI
- (void)loadUIview
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addInvest)];
    
}

- (void)addInvest
{
    NameController *invesVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
        
        [self.dataArrayM addObject:userInfo];
        
        [self.nolistView removeFromSuperview];
        
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:self.dataArrayM.count-1];
        
        [self.tableView insertSections:indexset withRowAnimation:UITableViewRowAnimationFade];
        if ([_delegate respondsToSelector:@selector(investListVC:withItmesList:)]) {
            [_delegate investListVC:self withItmesList:self.dataArrayM];
        }
    }];

    [self.navigationController pushViewController:invesVC animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArrayM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *invCellid = @"invCellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invCellid];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:invCellid];
    }
    [cell.textLabel setText:self.dataArrayM[indexPath.section]];
    return cell;
}

#pragma mark - 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [self.dataArrayM removeObjectAtIndex:indexPath.section];
    
    if (self.dataArrayM.count==0) {
        [self.tableView addSubview:self.nolistView];
    }
    
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
    //移除tableView中的数据
    [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationRight];
    if ([_delegate respondsToSelector:@selector(investListVC:withItmesList:)]) {
        [_delegate investListVC:self withItmesList:self.dataArrayM];
    }
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
