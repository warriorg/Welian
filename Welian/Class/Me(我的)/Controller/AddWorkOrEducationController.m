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
#import "ICompanyResult.h"
#import "ISchoolResult.h"
#import "UIImage+ImageEffects.h"

@interface AddWorkOrEducationController () <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
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
        [confirm setTitleColor:WLRGB(56, 109, 183) forState:UIControlStateNormal];
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
        [confirm setTitleColor:WLRGB(56, 109, 183) forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(confirmdate) forControlEvents:UIControlEventTouchUpInside];
        [_inputToolView addSubview:confirm];
        UIButton *tonow = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
        [tonow setTitle:@"至今" forState:UIControlStateNormal];
        [tonow setTitleColor:WLRGB(56, 109, 183) forState:UIControlStateNormal];
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
            [_schoolM setEndyear:@(yerint)];
            [_schoolM setEndmonth:@(monthInt)];

        }else if (_wlUserLoadType ==2){
            [_companyM setEndyear:@(yerint)];
            [_companyM setEndmonth:@(monthInt)];
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
    if (_wlUserLoadType ==1) {
        if (_schoolM.startyear) {
            [_beginTextF setText:[NSString stringWithFormat:@"%@年%@月",_schoolM.startyear,_schoolM.startmonth]];
        }
    }else if (_wlUserLoadType ==2){
        if (_companyM.startyear) {
            [_beginTextF setText:[NSString stringWithFormat:@"%@年%@月",_companyM.startyear,_companyM.startmonth]];
        }
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
    if (_wlUserLoadType ==1) {
        if (_schoolM.endyear.integerValue==-1) {
            [_endTextF setText:@"至今"];
        }else if (_schoolM.endyear) {
            [_endTextF setText:[NSString stringWithFormat:@"%@年%@月",_schoolM.endyear,_schoolM.endmonth]];
        }
    }else if (_wlUserLoadType ==2){
        if (_companyM.endyear.integerValue==-1) {
            [_endTextF setText:@"至今"];
        }else if (_companyM.endyear) {
            [_endTextF setText:[NSString stringWithFormat:@"%@年%@月",_companyM.endyear,_companyM.endmonth]];
        }
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
            yer = _schoolM.startyear.integerValue;
            day = _schoolM.startmonth.integerValue;
        }else if (_wlUserLoadType ==2){
            yer = _companyM.startyear.integerValue;
            day = _companyM.startmonth.integerValue;
        }
    }else if (_endTextF.isFirstResponder){
        if (_wlUserLoadType==1) {
            yer = _schoolM.endyear.integerValue;
            day = _schoolM.endmonth.integerValue;
        }else if (_wlUserLoadType ==2){
            yer = _companyM.endyear.integerValue;
            day = _companyM.endmonth.integerValue;
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


- (id)initWithStyle:(UITableViewStyle)style withType:(int)wlUserLoadType isNew:(BOOL)isNew
{
    _wlUserLoadType = wlUserLoadType;
    self = [super initWithStyle:style];
    if (self) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 84)];
        UIButton *footBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, SuperSize.width-30, 44)];
        [footBut setTitle:@"保存" forState:UIControlStateNormal];
        [footBut setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateNormal];
        [footBut setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateHighlighted];
        [footBut addTarget:self action:@selector(savedata) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:footBut];
        
        if (!isNew) {
            [footView setFrame:CGRectMake(0, 0, 0, 128)];
            UIButton *deletBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 84, SuperSize.width-30, 44)];
            [deletBut setTitle:@"删除该条履历" forState:UIControlStateNormal];
            [deletBut setBackgroundImage:[UIImage resizedImage:@"me_delect_button"] forState:UIControlStateNormal];
            [deletBut setBackgroundImage:[UIImage resizedImage:@"me_delect_button_pre"] forState:UIControlStateHighlighted];
            [deletBut addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:deletBut];
        }
        [self.tableView setTableFooterView:footView];
        [self.tableView setSectionHeaderHeight:30.0];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        UILabel *teseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width, 20)];
        [teseLabel setTextColor:[UIColor lightGrayColor]];
        [teseLabel setFont:WLFONT(15)];
        [teseLabel setBackgroundColor:[UIColor clearColor]];
        [headerV addSubview:teseLabel];
        [self.tableView setTableHeaderView:headerV];

        if (wlUserLoadType ==2) {
            [teseLabel setText:[NSString stringWithFormat:@"请填写你的公司"]];
            self.dataArray = @[@[@"公司名称",@"职位"],@[@"入职时间",@"离职时间"]];
        }else if(wlUserLoadType ==1){
            [teseLabel setText:[NSString stringWithFormat:@"请填写你的母校"]];
            self.dataArray = @[@[@"院校名称",@"专业"],@[@"入学时间",@"毕业时间"]];
        }
    }
    return self;
}

- (void)dismissVC
{
    if (self.recorBlock) {
        self.recorBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savedata
{
    if (_wlUserLoadType==1) {
        if (_schoolM.schoolname.length&&_schoolM.startyear&&_schoolM.endyear&&_schoolM.startmonth&&_schoolM.endmonth) {
            [_schoolM setSchoolid:nil];
            [_schoolM setSpecialtyid:nil];
            NSDictionary *daDic = [_schoolM keyValues];
            
            [WLHttpTool addSchoolParameterDic:daDic success:^(id JSON) {
                [_schoolM setKeyValues:JSON];
                [SchoolModel createCompanyModel:_schoolM];
                [self dismissVC];
                [WLHUDView showSuccessHUD:@"保存成功！"];
            } fail:^(NSError *error) {
                
            }];
        }else{
            [WLHUDView showErrorHUD:@"信息不完整！"];
        }
    }else if (_wlUserLoadType == 2){
        if (_companyM.companyname.length&&_companyM.startyear&&_companyM.endyear&&_companyM.startmonth&&_companyM.endmonth&&_companyM.jobname.length) {
            [_companyM setCompanyid:nil];
            [_companyM setJobid:nil];
            NSDictionary *datDic = [_companyM keyValues];
            [WLHttpTool addCompanyParameterDic:datDic success:^(id JSON) {
                [_companyM setUcid:@([[JSON objectForKey:@"ucid"] integerValue])];
                [CompanyModel createCompanyModel:_companyM];
                [self dismissVC];
                [WLHUDView showSuccessHUD:@"保存成功！"];
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

    //数据模型初始化
    if (_wlUserLoadType == 1){
        if (!_schoolM) {
            _schoolM = [[ISchoolResult alloc] init];
        }
    }else{
        if (!_companyM) {
            _companyM = [[ICompanyResult alloc] init];
        }
    }
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
                [self.beginTextF removeFromSuperview];
                [self.endTextF removeFromSuperview];
                [self.beginTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                [cell.contentView addSubview:self.beginTextF];

            }else if (indexPath.row==1){
                [self.endTextF removeFromSuperview];
                [self.endTextF setFrame:CGRectMake(100, 0, size.width-130, size.height)];
                [cell.contentView addSubview:self.endTextF];
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
                [companyName setTitle:@"院校名称"];
            }else if (indexPath.row ==1){
                [companyName setUserInfoStr:_schoolM.specialtyname];
                [companyName setTitle:@"专业"];
            }
        }else if (_wlUserLoadType ==2){
            if (indexPath.row==0) {
                [companyName setUserInfoStr:_companyM.companyname];
                [companyName setTitle:@"公司名称"];
            }else if (indexPath.row==1){
                [companyName setUserInfoStr:_companyM.jobname];
                [companyName setTitle:@"职位"];
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
        [_schoolM setStartyear:_yerStrArray[seletStatYer]];
        [_schoolM setEndyear:_yerStrArray[seletEndYer]];
        [_schoolM setStartmonth:_dayStrArray[seletStatDay]];
        [_schoolM setEndmonth:_dayStrArray[seletEndDay]];
    }else if (_wlUserLoadType ==2){
        [_companyM setStartyear:_yerStrArray[seletStatYer]];
        [_companyM setEndyear:_yerStrArray[seletEndYer]];
        [_companyM setStartmonth:_dayStrArray[seletStatDay]];
        [_companyM setEndmonth:_dayStrArray[seletEndDay]];
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

#pragma mark - 删除
- (void)deleteData
{
    if (_wlUserLoadType == 1) {
        [WLHttpTool deleteUserSchoolParameterDic:@{@"usid":_schoolM.usid} success:^(id JSON) {
            [self.coerSchoolM MR_deleteEntity];
            [self dismissVC];

        } fail:^(NSError *error) {
            
        }];
    }else if (_wlUserLoadType == 2){

        [WLHttpTool deleteUserCompanyParameterDic:@{@"ucid":_companyM.ucid} success:^(id JSON) {
            [self.coerCompanyM MR_deleteEntity];
            [self dismissVC];
        } fail:^(NSError *error) {
            
        }];
    }

}


@end
