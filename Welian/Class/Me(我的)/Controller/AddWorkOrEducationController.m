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

@interface AddWorkOrEducationController () <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    SchoolModel *_schoolM;
    CompanyModel *_companyM;
    int _wlUserLoadType;
    NSMutableArray *_yerStrArray;
    NSMutableArray *_dayStrArray;
    NSInteger seletStatYer;
    NSInteger seletStatDay;
    NSInteger seletEndYer;
    NSInteger seletEndDay;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *beginTextF;
@property (nonatomic, strong) UITextField *endTextF;
@property (nonatomic, strong) UIPickerView *datePick;
@property (nonatomic, strong) UIView *inputToolView;

@property (nonatomic, strong) UIView *oneinputToolView;

@end

@implementation AddWorkOrEducationController

- (UIView *)oneinputToolView
{
    if (_oneinputToolView == nil) {
        _oneinputToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 44)];
        [_oneinputToolView setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SuperSize.width, 1)];
        [linview setBackgroundColor:WLRGB(226, 226, 226)];
        [_oneinputToolView addSubview:linview];
        UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-60, 0, 50, 44)];
        [confirm setTitle:@"确认" forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(confirmdate) forControlEvents:UIControlEventTouchUpInside];
        [_oneinputToolView addSubview:confirm];
    }
    return _oneinputToolView;
}

- (UIView *)inputToolView
{
    if (_inputToolView == nil) {
        _inputToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 44)];
        [_inputToolView setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SuperSize.width, 1)];
        [linview setBackgroundColor:WLRGB(226, 226, 226)];
        [_inputToolView addSubview:linview];
        UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-60, 0, 50, 44)];
        [confirm setTitle:@"确认" forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(confirmdate) forControlEvents:UIControlEventTouchUpInside];
        [_inputToolView addSubview:confirm];
        UIButton *tonow = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
        [tonow setTitle:@"至今" forState:UIControlStateNormal];
        [tonow setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [tonow addTarget:self action:@selector(toupnowdate) forControlEvents:UIControlEventTouchUpInside];
        [_inputToolView addSubview:tonow];
    }
    return _inputToolView;
}

#pragma mark - 确认
- (void)confirmdate
{
    [self.beginTextF resignFirstResponder];
    [self.endTextF resignFirstResponder];
}

#pragma mark - 至今
- (void)toupnowdate
{
    NSInteger yerint = -1;
    NSInteger monthInt = -1;
    
    if (_endTextF.isFirstResponder){
        if (_wlUserLoadType ==1) {
            [_schoolM setEndyear:yerint];
            [_schoolM setEndmonth:monthInt];

        }else if (_wlUserLoadType ==2){
            [_companyM setEndyear:yerint];
            [_companyM setEndmonth:monthInt];
        }
        [self.endTextF setText:@"至今"];
        [self confirmdate];
    }
}

- (UITextField*)beginTextF
{
    if (_beginTextF ==nil) {
        _beginTextF = [[UITextField alloc] init];
        [_beginTextF setPlaceholder:@"请选择"];
        [_beginTextF setTextAlignment:NSTextAlignmentRight];
        [_beginTextF setTintColor:KBasesColor];
        [_beginTextF setInputView:self.datePick];
        [_beginTextF setDelegate:self];
        [_beginTextF setInputAccessoryView:self.oneinputToolView];
    }
    return _beginTextF;
}

- (UITextField *)endTextF
{
    if (_endTextF == nil) {
        _endTextF = [[UITextField alloc] init];
        [_endTextF setTextAlignment:NSTextAlignmentRight];
        [_endTextF setPlaceholder:@"请选择"];
        [_endTextF setDelegate:self];
        [_endTextF setTintColor:KBasesColor];
        [_endTextF setInputView:self.datePick];
        [_endTextF setInputAccessoryView:self.inputToolView];
    }
    return _endTextF;
}



- (UIPickerView*)datePick
{
    if (_datePick == nil) {
        _datePick = [[UIPickerView alloc] init];
        _datePick.showsSelectionIndicator=YES;
        _datePick.dataSource = self;
        _datePick.delegate = self;
        [_datePick setBackgroundColor:[UIColor whiteColor]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSInteger dateInt = [dateStr integerValue];
        _yerStrArray = [NSMutableArray array];
        for (NSInteger i =dateInt; i>=1971; i--) {
            [_yerStrArray addObject:@(i)];
        }
        _dayStrArray = [NSMutableArray array];
        for (NSInteger j =1; j<=12; j++) {
            [_dayStrArray addObject:@(j)];
        }
    }
    NSInteger yer = 0;
    NSInteger day = 0;
    if (_beginTextF.isFirstResponder) {
        if (_wlUserLoadType==1) {
            yer = _schoolM.startyear;
            day = _schoolM.startmonth;
        }else if (_wlUserLoadType ==2){
            yer = _companyM.startyear;
            day = _companyM.startmonth;
        }
    }else if (_endTextF.isFirstResponder){
        if (_wlUserLoadType==1) {
            yer = _schoolM.endyear;
            day = _schoolM.endmonth;
        }else if (_wlUserLoadType ==2){
            yer = _companyM.endyear;
            day = _companyM.endmonth;
        }
    }
    NSInteger a = 0;
    NSInteger b = 0;
    for (NSInteger m = 0; m<_yerStrArray.count; m++) {
        if (yer==[_yerStrArray[m] integerValue]) {
            a = m;
            continue;
        }
    }
    for (NSInteger k = 0; k<_dayStrArray.count; k++) {
        if (day == [_dayStrArray[k] integerValue]) {
            b= k;
            continue;
        }
    }
    [_datePick selectRow:a inComponent:0 animated:YES];
    [_datePick selectRow:b inComponent:1 animated:YES];
    return _datePick;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputView:self.datePick];
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
        
        if (wlUserLoadType ==2) {
            [teseLabel setText:[NSString stringWithFormat:@"请填写你的公司"]];
            self.dataArray = @[@[@"公司名称",@"职位"],@[@"入职时间",@"离职时间"]];
            _companyM = [[CompanyModel alloc] init];
        }else if(wlUserLoadType ==1){
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

        if (_schoolM.schoolname.length&&_schoolM.startyear&&_schoolM.endyear&&_schoolM.startmonth&&_schoolM.endmonth) {
            NSDictionary *daDic = [_schoolM keyValues];
            
            [WLHttpTool addSchoolParameterDic:daDic success:^(id JSON) {
                [WLHUDView showSuccessHUD:@"保存成功！"];
                [self dismissVC];
            } fail:^(NSError *error) {
                
            }];
        }else{
            [WLHUDView showErrorHUD:@"信息不完整！"];
        }
    }else if (_wlUserLoadType == 2){
        if (_companyM.companyname.length&&_companyM.startyear&&_companyM.endyear&&_companyM.startmonth&&_companyM.endmonth&&_companyM.jobname.length) {
            NSDictionary *datDic = [_companyM keyValues];
            [WLHttpTool addCompanyParameterDic:datDic success:^(id JSON) {
                [WLHUDView showSuccessHUD:@"保存成功！"];
                [self dismissVC];
            } fail:^(NSError *error) {
                
            }];
        }else{
            [WLHUDView showErrorHUD:@"信息不完整！"];
        }
    }
    [self confirmdate];
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
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
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

            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (indexPath.row==0) {
                [self.beginTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                if (!self.beginTextF.superview) {
                    [cell.contentView addSubview:self.beginTextF];
                }

            }else if (indexPath.row==1){

                [self.endTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                if (!self.endTextF.superview) {
                    
                    [cell.contentView addSubview:self.endTextF];
                }
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
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (indexPath.row==0) {
                [self.beginTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                if (!self.beginTextF.superview) {
                    [cell.contentView addSubview:self.beginTextF];
                }
                
            }else if (indexPath.row==1){
                
                [self.endTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                
                if (!self.endTextF.superview) {
                    
                    [cell.contentView addSubview:self.endTextF];
                }
            }
        }
    }
    NSArray *sectionArray = self.dataArray[indexPath.section];
    [cell.textLabel setText:sectionArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        [self.beginTextF resignFirstResponder];
        [self.endTextF resignFirstResponder];
        IWVerifiedType vertype;
        if (_wlUserLoadType ==1) {
            if (indexPath.row==0) {
                vertype = IWVerifiedTypeSchool;
            }else if (indexPath.row ==1){
                
            }
        }else if (_wlUserLoadType ==2) {
            if (indexPath.row ==0) {
                vertype = IWVerifiedTypeCompany;
            }else if (indexPath.row==1){
                vertype = IWVerifiedTypeJob;
            }
        }
        NameController *companyName = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            if (_wlUserLoadType==1) {
                if (indexPath.row==0) {
                    
                    [_schoolM setSchoolname:userInfo];
                }else if (indexPath.row ==1){
                    [_schoolM setSpecialtyname:userInfo];
                }
            }else if (_wlUserLoadType == 2){
                if (indexPath.row==0) {
                    
                    [_companyM setCompanyname:userInfo];
                }else if (indexPath.row==1){
                    [_companyM setJobname:userInfo];
                }
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } withType:vertype];
        if (_wlUserLoadType==1) {
            if (indexPath.row==0) {
                
                [companyName setUserInfoStr:_schoolM.schoolname];
            }else if (indexPath.row ==1){
                [companyName setUserInfoStr:_schoolM.specialtyname];
            }
        }else if (_wlUserLoadType ==2){
            if (indexPath.row==0) {
                [companyName setUserInfoStr:_companyM.companyname];
            }else if (indexPath.row==1){
                [companyName setUserInfoStr:_companyM.jobname];
            }
        }
        [self.navigationController pushViewController:companyName animated:YES];

    }else if (indexPath.section ==1){
    
    
    }
}

#pragma mark - pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return _yerStrArray.count;
    }else if (component ==1){
        return _dayStrArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [NSString stringWithFormat:@"%@年",_yerStrArray[row]];
    }else if (component==1){
        return [NSString stringWithFormat:@"%@月",_dayStrArray[row]];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableString *dateStr = [NSMutableString string];
    if (component==0) {
        if (self.beginTextF.isFirstResponder) {
            seletStatYer = row;
        }else if (self.endTextF.isFirstResponder){
            seletEndYer = row;
        }
    }else if (component==1){
        if (self.beginTextF.isFirstResponder) {
            seletStatDay = row;
        }else if (self.endTextF.isFirstResponder){
            seletEndDay = row;
        }
    }
    if (_wlUserLoadType ==1) {
        [_schoolM setStartyear:[_yerStrArray[seletStatYer] integerValue]];
        [_schoolM setEndyear:[_yerStrArray[seletEndYer] integerValue]];
        [_schoolM setStartmonth:[_dayStrArray[seletStatDay] integerValue]];
        [_schoolM setEndmonth:[_dayStrArray[seletEndDay] integerValue]];
    }else if (_wlUserLoadType ==2){
        [_companyM setStartyear:[_yerStrArray[seletStatYer] integerValue]];
        [_companyM setEndyear:[_yerStrArray[seletEndYer] integerValue]];
        [_companyM setStartmonth:[_dayStrArray[seletStatDay] integerValue]];
        [_companyM setEndmonth:[_dayStrArray[seletEndDay] integerValue]];
    }
    
    if (_beginTextF.isFirstResponder) {
        [dateStr appendFormat:@"%@年",_yerStrArray[seletStatYer]];
        [dateStr appendFormat:@"%@月",_dayStrArray[seletStatDay]];
        [_beginTextF setText:dateStr];
    }else if (_endTextF.isFirstResponder){
        [dateStr appendFormat:@"%@年",_yerStrArray[seletEndYer]];
        [dateStr appendFormat:@"%@月",_dayStrArray[seletEndDay]];
        [_endTextF setText:dateStr];
    }
}

@end
