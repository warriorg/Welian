//
//  CertificationController.m
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CertificationController.h"
#import "PioneeringController.h"

@interface CertificationController ()

@end

@implementation CertificationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = @[@"投资人认证",@"创业者认证"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_chuang_big"]];
        [imageV setFrame:CGRectMake(250, 13, 30, 22)];
        [cell.contentView addSubview:imageV];
    }
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PioneeringController *pioneVC = [[PioneeringController alloc] init];
    [self.navigationController pushViewController:pioneVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
