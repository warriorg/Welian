//
//  ListdaController.m
//  weLian
//
//  Created by dong on 14/10/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ListdaController.h"
#import "ISchoolResult.h"
#import "ICompanyResult.h"
#import "WorkListCell.h"

@interface ListdaController ()

{
    NSString *_type;
    NSArray *_listArray;
}

@end

static NSString *cellid = @"workscellid";
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
        [self.tableView registerNib:[UINib nibWithNibName:@"WorkListCell" bundle:nil] forCellReuseIdentifier:cellid];
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

    WorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if ([_type isEqualToString:@"1"]) {
        ISchoolResult *schoolM = _listArray[indexPath.section];
        [cell.titeLabel setText:schoolM.schoolname];
        [cell.detieLabel setText:schoolM.specialtyname];
        if (schoolM.endyear.integerValue==-1) {
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  至今",schoolM.startyear,schoolM.startmonth]];
        }else{
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  %@年%@月",schoolM.startyear,schoolM.startmonth,schoolM.endyear,schoolM.endmonth]];
        }
        
    }else if ([_type isEqualToString:@"2"]){
        ICompanyResult *companyM = _listArray[indexPath.section];
        [cell.titeLabel setText:companyM.companyname];
        [cell.detieLabel setText:companyM.jobname];
        if (companyM.endyear.integerValue==-1) {
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  至今",companyM.startyear,companyM.startmonth]];
        }else{
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  %@年%@月",companyM.startyear,companyM.startmonth,companyM.endyear,companyM.endmonth]];
        }
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL ishave = NO;
    NSString *titStr = @"";
    NSString *deltiStr = @"";
    if ([_type isEqualToString:@"1"]) {
        ISchoolResult *schoolM = _listArray[indexPath.section];
        titStr = schoolM.schoolname;
        if (schoolM.specialtyname) {
            deltiStr = schoolM.specialtyname;
            ishave = YES;
        }
    }else if ([_type isEqualToString:@"2"]){
        ICompanyResult *companyM = _listArray[indexPath.section];
        titStr = companyM.companyname;
        if (companyM.jobname) {
            deltiStr = companyM.jobname;
            ishave = YES;
        }
    }
    WorkListCell *workCell = [tableView dequeueReusableCellWithIdentifier:cellid];
    float width = [[UIScreen mainScreen] bounds].size.width - 30;
    float moreH = 0.0f;
    //计算第一个label的高度
    CGSize size1 = [titStr calculateSize:CGSizeMake(width, FLT_MAX) font:workCell.titeLabel.font];
    if (size1.height>18) {
        moreH += size1.height-18;
    }
    
    if (ishave) {
        //计算第二个label的高度
        CGSize size2 = [deltiStr calculateSize:CGSizeMake(width, FLT_MAX) font:workCell.detieLabel.font];
        if (size2.height>18) {
            moreH+= size2.height-18;
        }
        return 80+moreH;
    }
    return 60+moreH;
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
