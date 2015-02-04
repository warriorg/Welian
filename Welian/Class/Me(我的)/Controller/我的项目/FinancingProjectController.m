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

@interface FinancingProjectController () <UITableViewDelegate, UITableViewDataSource>
{
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
        [_tableView setSectionFooterHeight:0.1];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
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
    [self setTitle:@"设置融资信息"];
    
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"我要融资",@"暂不融资"]];
//    segmentedControl.frame = CGRectMake(20.0, 20.0, 250.0, 50.0);
//    segmentedControl.tintColor = KBasesColor;
    
    // Do any additional setup after loading the view.
}

#pragma mark - tableView代理
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section ==2){
        return @"融资信息有效期为30天，30天之后将自动消失";
    }
    return nil;
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
            UISwitch *swit = [[UISwitch alloc] init];
            [swit bk_addEventHandler:^(id sender) {
                UISwitch* control = (UISwitch*)sender;
                isFinancing  = control.on;
                [self.tableView reloadData];
                
            } forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView:swit];
        }
        UISwitch *swit = (UISwitch *)cell.accessoryView;
        [swit setOn:isFinancing];
        
        [cell.textLabel setText:@"我要融资"];
        return cell;

    }else if (indexPath.section==1){
    
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
        if (cell == nil) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textFieldCellid];
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
                CollectionViewController *invesVC = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout withType:2];
                [self.navigationController pushViewController:invesVC animated:YES];
                return NO;
            }];
        }else if (indexPath.row==1) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"融资金额"];
            [cell.textField setPlaceholder:nil];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
           UILabel *rightL = (UILabel *)cell.textField.rightView;
            [rightL setText:@"　万(CNY)　"];
            [rightL sizeToFit];
        }else if (indexPath.row==2){
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"出让股份"];
            [cell.textField setPlaceholder:nil];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
            UILabel *rightL = (UILabel *)cell.textField.rightView;
            [rightL setText:@"　%　　　　"];
            [rightL sizeToFit];
            
        }
        return cell;
    }else if (indexPath.section == 2){
        FinancingCell *cell = [tableView dequeueReusableCellWithIdentifier:financingCellid];
        if (cell == nil) {
            cell = [[FinancingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:financingCellid];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
