//
//  WorksListController.m
//  Welian
//
//  Created by dong on 14-9-14.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WorksListController.h"
#import "NavViewController.h"
#import "AddWorkOrEducationController.h"
#import "SchoolModel.h"
#import "CompanyModel.h"
#import "NoListView.h"
#import "WorkListCell.h"
#import "ISchoolResult.h"
#import "ICompanyResult.h"

@interface WorksListController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NoListView *nolistView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footView;
@end

static NSString *cellid = @"workscellid";
@implementation WorksListController


- (UIView *)footView
{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, SuperSize.height-45, SuperSize.width, 45)];
        UIButton *schoolBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width/2, 45)];
        [schoolBut setImage:[UIImage imageNamed:@"me_lvli_add"] forState:UIControlStateNormal];
        [schoolBut setTitle:@"教育背景" forState:UIControlStateNormal];
        [schoolBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        schoolBut.titleLabel.font = WLFONT(16);
        [schoolBut addTarget:self action:@selector(addSchoolExperience) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:schoolBut];
        
        UIButton *companyBut = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width/2, 0, SuperSize.width/2, 45)];
        [companyBut setImage:[UIImage imageNamed:@"me_lvli_add"] forState:UIControlStateNormal];
        [companyBut setTitle:@"工作经历" forState:UIControlStateNormal];
        [companyBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        companyBut.titleLabel.font = WLFONT(16);
        [companyBut addTarget:self action:@selector(addWorkExperience) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:companyBut];
        UIView *lieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 1)];
        [lieView setBackgroundColor:WLLineColor];
        [_footView addSubview:lieView];
        UIView *lietwoView = [[UIView alloc] initWithFrame:CGRectMake(SuperSize.width/2, 5, 1, 35)];
        [lietwoView setBackgroundColor:WLLineColor];
        [_footView addSubview:lietwoView];
        
    }
    return _footView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, SuperSize.height-45) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObjectsFromArray:[LogInUser getCurrentLoginUser].rsCompanys.allObjects];
        [self.dataArray addObjectsFromArray:[LogInUser getCurrentLoginUser].rsSchools.allObjects];
        NSSortDescriptor *sortByName= [NSSortDescriptor sortDescriptorWithKey:@"startyear" ascending:NO];
        [self.dataArray sortUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    }
    return self;
}

- (NoListView*)nolistView
{
    if (_nolistView == nil) {
        _nolistView = [[[NSBundle mainBundle] loadNibNamed:@"NoListView" owner:self options:nil] lastObject];
        [_nolistView setFrame:self.view.bounds];
        [_nolistView setCenter:self.view.center];
    }
    return _nolistView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkListCell" bundle:nil] forCellReuseIdentifier:cellid];
    [self.view addSubview:self.footView];
}


#pragma mark - 加载数据
//- (void)loadDataArray
//{
//    if (_wlUserLoadType == WLSchool) {
//        
//        [WLHttpTool loadUserSchoolParameterDic:@{} success:^(id JSON) {
//            for (ISchoolResult *iSchool in JSON) {
//                [SchoolModel createCompanyModel:iSchool];
//            }
//            
//            self.dataArray = [NSMutableArray arrayWithArray:[LogInUser getCurrentLoginUser].rsSchools.allObjects];
//
//            if (self.dataArray.count) {
//                [self.tableView reloadData];
//                [self.nolistView removeFromSuperview];
//            }else{
//                if (self.nolistView.superview==nil) {
//                    
//                    [self.tableView addSubview:self.nolistView];
//                }
//            }
//        } fail:^(NSError *error) {
//        }];
//    }else if (_wlUserLoadType == WLCompany){
//        
//        [WLHttpTool loadUserCompanyParameterDic:@{} success:^(id JSON) {
//            
//            for (ICompanyResult *iCompany in JSON) {
//                [CompanyModel createCompanyModel:iCompany];
//            }
//            self.dataArray = [NSMutableArray arrayWithArray:[LogInUser getCurrentLoginUser].rsCompanys.allObjects];
//            if (self.dataArray.count) {
//                [self.tableView reloadData];
//                [self.nolistView removeFromSuperview];
//            }else{
//                if (self.nolistView.superview==nil) {
//                    [self.tableView addSubview:self.nolistView];
//                }
//            }
//
//        } fail:^(NSError *error) {
//        }];
//    }
//    
//}


#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    id dataM = self.dataArray[indexPath.row];
    if ([dataM isKindOfClass:[SchoolModel class]]) {
        SchoolModel *schoolM = dataM;
        NSString *titStr = schoolM.specialtyname.length?[NSString stringWithFormat:@"%@  %@",schoolM.specialtyname,schoolM.schoolname]:schoolM.schoolname;
        [cell.titeLabel setText:titStr];
        if (schoolM.endyear.integerValue==-1) {
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  至今",schoolM.startyear,schoolM.startmonth]];
        }else{
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  %@年%@月",schoolM.startyear,schoolM.startmonth,schoolM.endyear,schoolM.endmonth]];
        }
    }else if ([dataM isKindOfClass:[CompanyModel class]]){
        CompanyModel *companyM = dataM;
        NSString *titStr = companyM.companyname.length?[NSString stringWithFormat:@"%@  %@",companyM.jobname,companyM.companyname]:companyM.companyname;
        [cell.titeLabel setText:titStr];
        if (companyM.endyear.integerValue==-1) {
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  至今",companyM.startyear,companyM.startmonth]];
        }else{
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@年%@月  -  %@年%@月",companyM.startyear,companyM.startmonth,companyM.endyear,companyM.endmonth]];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddWorkOrEducationController *addWkOrEdVC;
    
    id dataM = self.dataArray[indexPath.row];
    if ([dataM isKindOfClass:[SchoolModel class]]) {
        SchoolModel *schoolM = dataM;
        ISchoolResult *iSchool = [[ISchoolResult alloc] init];
        [iSchool setSchoolid:schoolM.schoolid];
        [iSchool setSchoolname:schoolM.schoolname];
        [iSchool setSpecialtyid:schoolM.specialtyid];
        [iSchool setSpecialtyname:schoolM.specialtyname];
        [iSchool setStartmonth:schoolM.startmonth];
        [iSchool setStartyear:schoolM.startyear];
        [iSchool setEndmonth:schoolM.endmonth];
        [iSchool setEndyear:schoolM.endyear];
        [iSchool setUsid:schoolM.usid];
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:1 isNew:NO];
        [addWkOrEdVC setCoerSchoolM:schoolM];
        [addWkOrEdVC setSchoolM:iSchool];
    }else if ([dataM isKindOfClass:[CompanyModel class]]){
        CompanyModel *companyM = dataM;
        ICompanyResult *iCompany = [[ICompanyResult alloc] init];
        [iCompany setUcid:companyM.ucid];
        [iCompany setCompanyid:companyM.companyid];
        [iCompany setCompanyname:companyM.companyname];
        [iCompany setJobid:companyM.jobid];
        [iCompany setJobname:companyM.jobname];
        [iCompany setStartyear:companyM.startyear];
        [iCompany setStartmonth:companyM.startmonth];
        [iCompany setEndyear:companyM.endyear];
        [iCompany setEndmonth:companyM.endmonth];
        addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:2 isNew:NO];
        [addWkOrEdVC setCompanyM:iCompany];
        [addWkOrEdVC setCoerCompanyM:companyM];
    }
    
    addWkOrEdVC.recorBlock = ^(){
        self.dataArray = [NSMutableArray arrayWithArray:[LogInUser getCurrentLoginUser].rsSchools.allObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addWkOrEdVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titStr = @"";
    
    id dataM = self.dataArray[indexPath.row];
    if ([dataM isKindOfClass:[SchoolModel class]]) {
        SchoolModel *schoolM = dataM;
        titStr = schoolM.specialtyname.length?[NSString stringWithFormat:@"%@  %@",schoolM.specialtyname,schoolM.schoolname]:schoolM.schoolname;
    }else if ([dataM isKindOfClass:[CompanyModel class]]){
        CompanyModel *companyM = dataM;
        titStr = companyM.companyname.length?[NSString stringWithFormat:@"%@  %@",companyM.jobname,companyM.companyname]:companyM.companyname;
    }

    WorkListCell *workCell = [tableView dequeueReusableCellWithIdentifier:cellid];
    //    cell.friendM = newFM;
    float width = [[UIScreen mainScreen] bounds].size.width - 30;
    float moreH = 0.0f;
    //计算第一个label的高度
    CGSize size1 = [titStr calculateSize:CGSizeMake(width, FLT_MAX) font:workCell.titeLabel.font];
    if (size1.height>18) {
        moreH += size1.height-18;
    }
    return 60+moreH;
}


#pragma mark - 删除
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Remove the row from data model
//    if (_wlUserLoadType == WLSchool) {
//        SchoolModel *scmode = self.dataArray[indexPath.row];
//        [WLHttpTool deleteUserSchoolParameterDic:@{@"usid":scmode.usid} success:^(id JSON) {
//            // 删除数据库数据
//            [scmode MR_deleteEntity];
//            [self.dataArray removeObjectAtIndex:indexPath.row];
//            if (self.dataArray.count==0) {
//                [self.tableView addSubview:self.nolistView];
//            }
//            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
//            //移除tableView中的数据
//            [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationNone];
//            
//        } fail:^(NSError *error) {
//            
//        }];
//    }else if (_wlUserLoadType == WLCompany){
//        CompanyModel *commode = self.dataArray[indexPath.row];
//        [WLHttpTool deleteUserCompanyParameterDic:@{@"ucid":commode.ucid} success:^(id JSON) {
//            // 删除数据库数据
//            [commode MR_deleteEntity];
//            //
//            [self.dataArray removeObjectAtIndex:indexPath.row];
//            if (self.dataArray.count==0) {
//                [self.tableView addSubview:self.nolistView];
//            }
//            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:indexPath.section];
//            //移除tableView中的数据
//            [tableView deleteSections:indexset withRowAnimation:UITableViewRowAnimationNone];
//            
//        } fail:^(NSError *error) {
//            
//        }];
//    }
//
//}


#pragma mark - 添加教育背景
- (void)addSchoolExperience
{
    AddWorkOrEducationController *addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:1 isNew:YES];
    addWkOrEdVC.recorBlock = ^(){
        self.dataArray = [NSMutableArray arrayWithArray:[LogInUser getCurrentLoginUser].rsSchools.allObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addWkOrEdVC animated:YES];
    
}

#pragma mark - 添加工作经历
- (void)addWorkExperience
{
    AddWorkOrEducationController *addWkOrEdVC = [[AddWorkOrEducationController alloc] initWithStyle:UITableViewStyleGrouped withType:2 isNew:YES];
    addWkOrEdVC.recorBlock = ^(){
        self.dataArray = [NSMutableArray arrayWithArray:[LogInUser getCurrentLoginUser].rsSchools.allObjects];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addWkOrEdVC animated:YES];
}

@end
