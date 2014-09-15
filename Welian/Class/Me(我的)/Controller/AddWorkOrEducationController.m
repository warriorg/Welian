//
//  AddWorkOrEducationController.m
//  Welian
//
//  Created by dong on 14-9-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AddWorkOrEducationController.h"
#import "NameController.h"

@interface AddWorkOrEducationController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataDicM;
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
        [_beginTextF setTintColor:KBasesColor];
    }
    return _beginTextF;
}

- (UITextField *)endTextF
{
    if (_endTextF == nil) {
        _endTextF = [[UITextField alloc] init];
        [_endTextF setPlaceholder:@"请选择"];
        [_endTextF setTintColor:KBasesColor];
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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissVC)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(savedata)];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        self.dataDicM = [NSMutableDictionary dictionary];
        [self.dataDicM setObject:@"" forKey:@"离职时间"];
        [self.dataDicM setObject:@"" forKey:@"入职时间"];
        [self.dataDicM setObject:@"" forKey:@"公司名称"];
        [self.tableView setSectionFooterHeight:0.0];
        [self.tableView setSectionHeaderHeight:30.0];
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        UILabel *teseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        [teseLabel setText:[NSString stringWithFormat:@"请填写你的公司"]];
        [teseLabel setTextColor:[UIColor lightGrayColor]];
        [teseLabel setBackgroundColor:[UIColor clearColor]];
        [self.tableView setTableHeaderView:teseLabel];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    CGSize size = cell.bounds.size;
    if (indexPath.row==0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if(indexPath.row ==1){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.beginTextF setInputView:self.datePick];
        [self.beginTextF setFrame:CGRectMake(100, 0, size.width-100, size.height)];
        
        [cell.contentView addSubview:self.beginTextF];
    }else if (indexPath.row==2){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.endTextF setInputView:self.datePick];
        [self.endTextF setFrame:CGRectMake(100, 0, size.width-100, size.height)];
        
        [cell.contentView addSubview:self.endTextF];
    }
    NSArray *name = self.dataDicM.allKeys;
    [cell.textLabel setText:name[indexPath.row]];
    CGPoint center = cell.center;
    center.x += 100;
    [cell.detailTextLabel setCenter:center];
    [cell.detailTextLabel setText:[self.dataDicM objectForKey:name[indexPath.row]]];
    
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
        NameController *companyName = [[NameController alloc] initWithBlock:^(NSString *userInfo) {
            [self.dataDicM setObject:userInfo forKey:@"公司名称"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [companyName setUserInfoStr:self.dataDicM[@"公司名称"]];
        [self.navigationController pushViewController:companyName animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)dateChanged:(UIDatePicker *)sender{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:sender.date];
    /*添加你自己响应代码*/
    if (self.beginTextF.isFirstResponder) {
        [self.beginTextF setText:dateStr];
    }else if (self.endTextF.isFirstResponder){
        [self.endTextF setText:dateStr];
    }
}


@end
