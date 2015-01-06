//
//  CityLocationController.m
//  weLian
//
//  Created by dong on 14-10-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CityLocationController.h"

@interface CityLocationController ()

@end

@implementation CityLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"citycellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSDictionary *dic = self.cityArray[indexPath.row];
    [cell.textLabel setText:dic[@"name"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.cityArray[indexPath.row];
    
    [self.meInfoVC locationProvinController:self withLocationDic:@{@"provname":self.provinDic[@"name"],@"provid":@([self.provinDic[@"pid"] integerValue]),@"cityname":dic[@"name"],@"cityid":@([dic[@"cid"] integerValue])}];
    
    [self.navigationController popToViewController:self.meInfoVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
