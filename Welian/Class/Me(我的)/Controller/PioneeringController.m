//
//  PioneeringController.m
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "PioneeringController.h"

@interface PioneeringController ()

@property (nonatomic, strong) UIImageView *logoImage;


@end

@implementation PioneeringController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PioneerPlist" withExtension:@"plist"];
    self.dataArray = [NSArray arrayWithContentsOfURL:url];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, 44)];
    [view setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:view];
//    [self.tableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 60;
    }else if (indexPath.section == 1){
        return 47;
    }else if (indexPath.section ==2){
        return 120;
    }else if (indexPath.section ==3){
        return 47;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indant = @"cellindat";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indant];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indant];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    // 1.取出这行对应的字典数据
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    // 2.设置文字
    cell.textLabel.text = dict[@"name"];
    
    if (indexPath.section==0) {
        
    }
    
    
    return cell;
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
