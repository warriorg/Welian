//
//  InvestCerVC.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCerVC.h"
#import "InvestCardCell.h"
#import "InvestCollectionVC.h"
#import "AddCaseCell.h"
#import "NameController.h"

@interface InvestCerVC ()

@end


static NSString *invcellid = @"investCardcell";
static NSString *addcasecellid = @"addcasecellid";

@implementation InvestCerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestCardCell" bundle:nil] forCellReuseIdentifier:invcellid];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCaseCell" bundle:nil] forCellReuseIdentifier:addcasecellid];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 110;
    }else{
        return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 30;
    }
    return KTableHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return @"投资案例";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        InvestCardCell *cell = [tableView dequeueReusableCellWithIdentifier:invcellid];
        [cell.investCardBut addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(indexPath.section==1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"111"];
        return cell;
    }else if (indexPath.section ==2){
        if (indexPath.row==0) {
            AddCaseCell *addcell = [tableView dequeueReusableCellWithIdentifier:addcasecellid];
            return addcell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {      // 投资领域
            
        }else if (indexPath.row==1){  // 投资阶段
            
//            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//            [layout setSectionInset:UIEdgeInsetsMake(10, 20, 20, 30)];
//            [layout setMinimumLineSpacing:20.0];
//            [layout setHeaderReferenceSize:CGSizeMake(self.view.bounds.size.width, 34)];
            
            InvestCollectionVC *investVC = [[InvestCollectionVC alloc] init];
            
            [self.navigationController pushViewController:investVC animated:YES];
        }
    }else if (indexPath.section==2){
        
        NameController *caseVC = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            DLog(@"%@",userInfo);
        } withType:IWVerifiedTypeName];
        [self.navigationController pushViewController:caseVC animated:YES];
    }
}

@end
