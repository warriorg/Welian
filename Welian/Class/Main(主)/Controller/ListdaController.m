//
//  ListdaController.m
//  weLian
//
//  Created by dong on 14/10/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ListdaController.h"
#import "SchoolModel.h"
#import "CompanyModel.h"

@interface ListdaController ()

{
    NSString *_type;
    NSArray *_listArray;
}

@end

@implementation ListdaController

- (instancetype)initWithStyle:(UITableViewStyle)style WithList:(NSArray*)listData andType:(NSString*)type
{
    _type = type;
    _listArray = listData;
    self = [super initWithStyle:style];
    if (self) {
        if ([type isEqualToString:@"1"]) {
            [self setTitle:@"教育背景"];
        }else if ([type isEqualToString:@"2"]){
            [self setTitle:@"工作经历"];
        }else if ([type isEqualToString:@"3"]){
            [self setTitle:@"投资案例"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([_type isEqualToString:@"1"]) {
        SchoolModel *schoolM = _listArray[indexPath.section];
        [cell.textLabel setText:schoolM.schoolname];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d年%d月  -  %d年%d月",schoolM.startyear,schoolM.startmonth,schoolM.endyear,schoolM.endmonth]];
    }else if ([_type isEqualToString:@"2"]){
        CompanyModel *companyM = _listArray[indexPath.section];
        [cell.textLabel setText:companyM.companyname];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d年%d月  -  %d年%d月",companyM.startyear,companyM.startmonth,companyM.endyear,companyM.endmonth]];
    }else if ([_type isEqualToString:@"3"]){
        NSString *str = _listArray[indexPath.section];
        [cell.textLabel setText:str];
    }
    return cell;
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
