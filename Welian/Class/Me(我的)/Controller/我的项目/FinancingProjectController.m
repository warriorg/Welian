//
//  FinancingProjectController.m
//  Welian
//
//  Created by dong on 15/1/30.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "FinancingProjectController.h"
#import "TextFieldCell.h"
#import "FinancingCell.h"
#import "CollectionViewController.h"
#import "HeaderLabel.h"

#define KFooterText @"如欲融资，重新填写融资信息即可"

@interface FinancingProjectController () <UITableViewDelegate, UITableViewDataSource>
{
    // 是否融资
    BOOL isFinancing;
}
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *textFieldCellid = @"textFieldCellid";
static NSString *financingCellid = @"financingCellid";
@implementation FinancingProjectController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate: self];
        [_tableView setDataSource:self];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
}

- (instancetype)initIsEdit:(BOOL)isEdit
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.tableView];
        isFinancing = YES;
//        if (!isEdit) {
//            [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SuperSize.width, 90)]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishPorject)];
//        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"融资信息"];
}

#pragma mark - tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.1;
    }else if (section==1){
        NSString *str = @"融资项目将会直接推送给243位认证投资人，非认证投资人无法看到融资信息。";
        return [str sizeWithFont:WLFONT(14) constrainedToSize:CGSizeMake(SuperSize.width-30, 0)].height+20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0&&!isFinancing) {
        return 150;
    }else if (section==2){
        NSString *str = @"融资信息有效期为30天，30天之后将自动消失";
        return [str sizeWithFont:WLFONT(14) constrainedToSize:CGSizeMake(SuperSize.width-30, 0)].height+20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        HeaderLabel *headLabel = [[[NSBundle mainBundle]loadNibNamed:@"HeaderLabel" owner:nil options:nil] firstObject];
        [headLabel.titLabel setText:@"融资项目将会直接推送给243位认证投资人，非认证投资人无法看到融资信息。"];
        return headLabel;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HeaderLabel *footerLabel = [[[NSBundle mainBundle]loadNibNamed:@"HeaderLabel" owner:nil options:nil] firstObject];
    if (section==0) {
        if (!isFinancing) {
            [footerLabel.titLabel setText:KFooterText];
        }else{
            return nil;
        }
    }else if (section==1) {
        [footerLabel.titLabel setText:@"投后估值为1000万"];
    }else if (section ==2){
        [footerLabel.titLabel setText:@"融资信息有效期为30天，30天之后将自动消失"];
    }
    return footerLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isFinancing) {
        return 3;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 195;
    }else{
        return KTableRowH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Segmentedcellid"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Segmentedcellid"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"我要融资",@"暂不融资"]];
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:NSFontAttributeName];
            [segment setTitleTextAttributes:attributes
                                            forState:UIControlStateNormal];
            [segment setTintColor:KBasesColor];
            [segment setTag:2048];
            [segment setFrame:CGRectMake(15, KTableRowH-35, SuperSize.width-30, 35)];
            [cell.contentView addSubview:segment];
            [segment bk_addEventHandler:^(id sender) {
                UISegmentedControl *control = (UISegmentedControl *)sender;
                isFinancing = !control.selectedSegmentIndex;
                [self.tableView reloadData];
            } forControlEvents:UIControlEventValueChanged];
        }
        UISegmentedControl *segmet = (UISegmentedControl *)[cell.contentView viewWithTag:2048];
        [segmet setSelectedSegmentIndex:!isFinancing];
        return cell;

    }else if (indexPath.section==1){
    
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellid];
        if (cell == nil) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textFieldCellid];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (indexPath.row==0) {
            [cell.textLabel setText:@"融资阶段"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textField setPlaceholder:@"请选择"];
            [cell.textField setBk_shouldBeginEditingBlock:^BOOL(UITextField *textField) {
                UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
                [flowLayout setMinimumLineSpacing:1];
                [flowLayout setMinimumInteritemSpacing:0.5];
                [flowLayout setItemSize:CGSizeMake([MainScreen bounds].size.width/2-0.5, 50)];
                CollectionViewController *invesVC = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout withType:2 withData:self.projectModel];
                [self.navigationController pushViewController:invesVC animated:YES];
                return NO;
            }];
        }else if (indexPath.row==1) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"融资金额"];
            [cell.textField setPlaceholder:nil];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
           UILabel *rightL = (UILabel *)cell.textField.rightView;
            [rightL setText:@"万(CNY)　"];
            [rightL sizeToFit];
        }else if (indexPath.row==2){
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"出让股份"];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setPlaceholder:nil];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
            UILabel *rightL = (UILabel *)cell.textField.rightView;
            [rightL setText:@"%(0~100)　"];
            [rightL sizeToFit];
            
        }
        return cell;
    }else if (indexPath.section == 2){
        FinancingCell *cell = [tableView dequeueReusableCellWithIdentifier:financingCellid];
        if (cell == nil) {
            cell = [[FinancingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:financingCellid];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell.titLabel setText:@"融资说明"];
        [cell.textView setPlaceholder:@"200字之内"];
        return cell;
    }
    return nil;
}



#pragma mark - 完成
- (void)finishPorject
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
