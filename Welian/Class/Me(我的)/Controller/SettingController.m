//
//  SettingController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()
{
    NSArray *_data;
}

@property (nonatomic, strong) UISwitch *remindSwitch;
@end

@implementation SettingController

- (UISwitch *)remindSwitch
{
    if (nil == _remindSwitch) {
        _remindSwitch = [[UISwitch alloc] init];
        [_remindSwitch setOnTintColor:KBasesColor];
    }
    return _remindSwitch;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self loadPlist];
        
        // 2.设置tableView每组头部的高度
        self.tableView.sectionHeaderHeight = 15;
        self.tableView.sectionFooterHeight = 0;
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        // 3.要在tableView底部添加一个按钮
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
        [logout setBackgroundColor:[UIColor whiteColor]];
        [logout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      
        // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
        logout.bounds = CGRectMake(0, 0, 0, 44);
        
        // 4.设置按钮文字
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        
        //    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.tableView.tableFooterView = logout;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 15;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}


#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"settingPlist" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_data[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (nil ==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    [cell.textLabel setText:dict[@"title"]];
    if (indexPath.section==1&&indexPath.row==0) {
        [cell setAccessoryView:self.remindSwitch];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.detailTextLabel setText:dict[@"content"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 47;
}


@end
