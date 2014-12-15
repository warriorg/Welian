//
//  AddWorkOrEducationController.m
//  Welian
//
//  Created by dong on 14-9-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AddWorkOrEducationController.h"
#import "NameController.h"
#import "SchoolModel.h"
#import "CompanyModel.h"
#import "MJExtension.h"

@interface AddWorkOrEducationController () <UIActionSheetDelegate>
{
    SchoolModel *_schoolM;
    CompanyModel *_companyM;
    int _wlUserLoadType;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *beginTextF;
@property (nonatomic, strong) UITextField *endTextF;
@property (nonatomic, strong) UIDatePicker *datePick;

@end

@implementation AddWorkOrEducationController

- (UITextField*)beginTextF
{
    if (_beginTextF ==nil) {
        _beginTextF = [[UITextField alloc] init];
        [_beginTextF setPlaceholder:@"请选择"];
        [_beginTextF setTextAlignment:NSTextAlignmentRight];
        [_beginTextF setTintColor:KBasesColor];
        [_beginTextF setInputView:self.datePick];
    }
    return _beginTextF;
}

- (UITextField *)endTextF
{
    if (_endTextF == nil) {
        _endTextF = [[UITextField alloc] init];
        [_endTextF setTextAlignment:NSTextAlignmentRight];
        [_endTextF setPlaceholder:@"请选择"];
        [_endTextF setTintColor:KBasesColor];
        [_endTextF setInputView:self.datePick];
    }
    return _endTextF;
}

- (UIDatePicker*)datePick
{
    if (_datePick == nil) {
        _datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _datePick.datePickerMode = UIDatePickerModeDate;
        [_datePick setBackgroundColor:[UIColor whiteColor]];
        [_datePick addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        // 设置显示中文
        _datePick.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _datePick;
}


- (id)initWithStyle:(UITableViewStyle)style withType:(int)wlUserLoadType
{
    _wlUserLoadType = wlUserLoadType;
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(savedata)];
        [self.tableView setSectionHeaderHeight:30.0];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        UILabel *teseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        [teseLabel setTextColor:[UIColor lightGrayColor]];
        [teseLabel setBackgroundColor:[UIColor clearColor]];
        [self.tableView setTableHeaderView:teseLabel];
        
        if (wlUserLoadType) {
            [teseLabel setText:[NSString stringWithFormat:@"请填写你的公司"]];
            self.dataArray = @[@[@"公司名称",@"职位"],@[@"入职时间",@"离职时间"]];
            _companyM = [[CompanyModel alloc] init];
        }else{
            [teseLabel setText:[NSString stringWithFormat:@"请填写你的母校"]];
            self.dataArray = @[@[@"院校名称",@"专业"],@[@"入学时间",@"毕业时间"]];
            _schoolM = [[SchoolModel alloc] init];
        }
    
        
    }
    return self;
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)savedata
{
    if (_wlUserLoadType==1) {

        if (_schoolM.schoolname&&_schoolM.startyear&&_schoolM.endyear) {
            NSDictionary *daDic = [_schoolM keyValues];
            
            [WLHttpTool addSchoolParameterDic:daDic success:^(id JSON) {
                [WLHUDView showSuccessHUD:@"保存成功！"];
                [self dismissVC];
            } fail:^(NSError *error) {
                
            }];
        }
    }else if (_wlUserLoadType == 2){
        if (_companyM.companyname&&_companyM.startyear&&_companyM.endyear) {
            NSDictionary *datDic = [_companyM keyValues];
            [WLHttpTool addCompanyParameterDic:datDic success:^(id JSON) {
                [WLHUDView showSuccessHUD:@"保存成功！"];
                [self dismissVC];
            } fail:^(NSError *error) {
                
            }];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionarray = self.dataArray[section];
    return sectionarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    CGSize size = cell.bounds.size;
    
    if (_wlUserLoadType ==1) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                [cell.detailTextLabel setText:_schoolM.schoolname];
            }else if (indexPath.row==1){
                [cell.detailTextLabel setText:_schoolM.specialtyname];
            }
        }else if (indexPath.section ==1){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            if (indexPath.row==0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)_schoolM.startyear]];
            }else if (indexPath.row==1){
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)_schoolM.endyear]];
            }
        }
    }else if (_wlUserLoadType ==2){
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                [cell.detailTextLabel setText:_companyM.companyname];
            }else if (indexPath.row==1){
                [cell.detailTextLabel setText:_companyM.jobname];
            }
        }else if (indexPath.section ==1){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            if (indexPath.row==0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)_companyM.startyear]];
            }else if (indexPath.row==1){
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)_companyM.endyear]];
            }

        }

    }
    
    
//    if (_wlUserLoadType==1) {
//        if (indexPath.row==0) {
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//            [cell.detailTextLabel setText:_schoolM.schoolname];
//        }else if(indexPath.row ==1){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            
//            [self.beginTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
//            if (!self.beginTextF.superview) {
//                [cell.contentView addSubview:self.beginTextF];
//            }
//        }else if (indexPath.row==2){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            [self.endTextF setInputView:self.datePick];
//            [self.endTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
//            
//            [cell.contentView addSubview:self.endTextF];
//        }
//
//    }else if (_wlUserLoadType==2){
//        if (indexPath.row==0) {
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//            [cell.detailTextLabel setText:_companyM.companyname];
//        }else if(indexPath.row ==1){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            [self.beginTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
//            
//            [cell.contentView addSubview:self.beginTextF];
//        }else if (indexPath.row==2){
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            [self.endTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
//            
//            [cell.contentView addSubview:self.endTextF];
//        }
//
//    }
    NSArray *sectionArray = self.dataArray[indexPath.section];
    [cell.textLabel setText:sectionArray[indexPath.row]];
    CGPoint center = cell.center;
    center.x += 100;
    [cell.detailTextLabel setCenter:center];
    
//    [cell.detailTextLabel setText:[self.dataDicM objectForKey:name[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        [self.beginTextF becomeFirstResponder];
    }else if(indexPath.row ==2){
        [self.endTextF becomeFirstResponder];
    }else {
        [self.beginTextF resignFirstResponder];
        [self.endTextF resignFirstResponder];
        IWVerifiedType vertype;
        if (_wlUserLoadType) {
            
            vertype = IWVerifiedTypeCompany;
        }else{
            vertype = IWVerifiedTypeSchool;
        }
        NameController *companyName = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            if (_wlUserLoadType==1) {
                [_schoolM setSchoolname:userInfo];
            }else if (_wlUserLoadType == 2){
                [_companyM setCompanyname:userInfo];
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } withType:vertype];
        if (_wlUserLoadType==1) {
            [companyName setUserInfoStr:_schoolM.schoolname];
        }else if (_wlUserLoadType ==2){
            [companyName setUserInfoStr:_companyM.companyname];
        }
        [self.navigationController pushViewController:companyName animated:YES];
    }
}


-(void)dateChanged:(UIDatePicker *)sender{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    NSString *dateStr = [formatter stringFromDate:sender.date];
    
    if (_wlUserLoadType==1) {
        /*添加你自己响应代码*/
        if (self.beginTextF.isFirstResponder) {
            formatter.dateFormat = @"yyyy";
            [_schoolM setStartyear:[[formatter stringFromDate:sender.date] integerValue]];
            formatter.dateFormat = @"MM";
            [_schoolM setStartmonth:[[formatter stringFromDate:sender.date] integerValue]];
            [self.beginTextF setText:dateStr];
        }else if (self.endTextF.isFirstResponder){
            formatter.dateFormat = @"yyyy";
            [_schoolM setEndyear:[[formatter stringFromDate:sender.date] integerValue]];
            formatter.dateFormat = @"MM";
            [_schoolM setEndmonth:[[formatter stringFromDate:sender.date] integerValue]];
            [self.endTextF setText:dateStr];
        }
    }else if (_wlUserLoadType ==2){
        /*添加你自己响应代码*/
        if (self.beginTextF.isFirstResponder) {
            formatter.dateFormat = @"yyyy";
            [_companyM setStartyear:[[formatter stringFromDate:sender.date] integerValue]];
            formatter.dateFormat = @"MM";
            [_companyM setStartmonth:[[formatter stringFromDate:sender.date] integerValue]];
            [self.beginTextF setText:dateStr];
        }else if (self.endTextF.isFirstResponder){
            formatter.dateFormat = @"yyyy";
            [_companyM setEndyear:[[formatter stringFromDate:sender.date] integerValue]];
            formatter.dateFormat = @"MM";
            [_companyM setEndmonth:[[formatter stringFromDate:sender.date] integerValue]];
            [self.endTextF setText:dateStr];
        }

    }
    
}


@end
