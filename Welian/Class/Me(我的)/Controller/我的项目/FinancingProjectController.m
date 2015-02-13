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
#import "ProjectDetailsViewController.h"
#import "IInvestStageModel.h"
#import "CreateHeaderView.h"

#define KFooterText @"如欲融资，重新填写融资信息即可"

@interface FinancingProjectController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, assign) NSInteger isFinancing;
@property (nonatomic, strong) IProjectDetailInfo *projectModel;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *stageData;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) CollectionViewController *invesVC;
@property (nonatomic, strong) IProjectDetailInfo *selfProjectM;
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

- (instancetype)initIsEdit:(BOOL)isEdit withData:(IProjectDetailInfo *)projectModel
{
    self = [super init];
    if (self) {
        self.isEdit = isEdit;
        self.selfProjectM = projectModel;
        
        self.projectModel = [[IProjectDetailInfo alloc] init];
        [self.projectModel setPid:projectModel.pid];
        [self.projectModel setAmount:projectModel.amount];
        [self.projectModel setShare:projectModel.share];
        [self.projectModel setStage:projectModel.stage];
        [self.projectModel setStatus:projectModel.status];
        [self.projectModel setFinancing:projectModel.financing];
        [self.projectModel setFinancingtime:projectModel.financingtime];
        
        if (!isEdit) {
            self.isFinancing = 0;
            CreateHeaderView *headerV = [[[NSBundle mainBundle]loadNibNamed:@"CreateHeaderView" owner:nil options:nil] firstObject];
            if (Iphone6plus) {
                [headerV.ImageView setImage:[UIImage imageNamed:@"discovery_buzhou_step_three1242.png"]];
            }else{
                [headerV.ImageView setImage:[UIImage imageNamed:@"discovery_buzhou_step_three640.png"]];
            }
            [headerV setFrame:CGRectMake(0, 0, SuperSize.width, 70)];
            [self.tableView setTableHeaderView:headerV];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishPorject)];
        }else{
            if (projectModel.status.integerValue) {
                self.isFinancing = 0;
            }else{
                self.isFinancing = 1;
            }
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(finishPorject)];
        }
        
        // 1.获得路径
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"InvestStagePlist" withExtension:@"plist"];
        // 2.读取数据
        self.stageData = [NSArray arrayWithContentsOfURL:url];
        [self.view addSubview:self.tableView];
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
        NSString *str = @"融资项目将会直接推送给所有认证投资人，非认证投资人无法看到融资信息。";
        return [str sizeWithFont:WLFONT(14) constrainedToSize:CGSizeMake(SuperSize.width-30, 0)].height+20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==0&&self.isFinancing) {
        return 150;
    }else if (section==2){
        NSString *str = @"融资信息有效期为30天，30天之后将自动消失";
        return [str sizeWithFont:WLFONT(14) constrainedToSize:CGSizeMake(SuperSize.width-30, 0)].height+20;
    }else if (section==1){
        return 25;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        HeaderLabel *headLabel = [[[NSBundle mainBundle]loadNibNamed:@"HeaderLabel" owner:nil options:nil] firstObject];
        [headLabel.titLabel setText:@"融资项目将会直接推送给所有认证投资人，非认证投资人无法看到融资信息。"];
        return headLabel;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    HeaderLabel *footerLabel = [[[NSBundle mainBundle]loadNibNamed:@"HeaderLabel" owner:nil options:nil] firstObject];
    if (section==0) {
        if (self.isFinancing) {
            [footerLabel.titLabel setText:KFooterText];
        }else{
            return nil;
        }
    }else if (section==1) {
         NSInteger a = _projectModel.amount.integerValue/_projectModel.share.integerValue*100;
        NSString *headStr = [NSString stringWithFormat:@"投后估值为%d万",a];
        NSInteger  length = [[NSString stringWithFormat:@"%d",a] length];
        
        NSDictionary *attrsDic = @{NSForegroundColorAttributeName: WLRGB(52, 116, 186),NSFontAttributeName:WLFONTBLOD(17)};
        NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:headStr];
        [attrstr addAttributes:attrsDic range:NSMakeRange(5, length)];
        
        [footerLabel.titLabel setAttributedText:attrstr];
    }else if (section ==2){
        if (_projectModel.financingtime.length) {
            NSDate *date = [_projectModel.financingtime dateFromShortString];
            NSString *after = [[date dateByAddingDays:30] formattedDateWithFormat:@"yyyy-MM-dd"];
            NSString *headStr = [NSString stringWithFormat:@"本次融资信息有效期截止%@",after];
            NSDictionary *attrsDic = @{NSForegroundColorAttributeName: WLRGB(208, 2, 27),NSFontAttributeName:WLFONT(16)};
            NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:headStr];
            [attrstr addAttributes:attrsDic range:NSMakeRange(11, after.length)];
            
            [footerLabel.titLabel setAttributedText:attrstr];
        }else{
            [footerLabel.titLabel setText:@"融资信息有效期为30天，30天之后将自动消失"];
        }
        
    }
    return footerLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.isFinancing) {
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
    WEAKSELF
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
                weakSelf.isFinancing = control.selectedSegmentIndex;
                [weakSelf.tableView reloadData];
            } forControlEvents:UIControlEventValueChanged];
        }
        UISegmentedControl *segmet = (UISegmentedControl *)[cell.contentView viewWithTag:2048];
        [segmet setSelectedSegmentIndex:self.isFinancing];
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
            if (self.projectModel.stage) {
                for (NSDictionary *stemDic in self.stageData) {
                    if ([[stemDic objectForKey:@"stage"] integerValue]==self.projectModel.stage.integerValue) {
                        [cell.textField setText:[stemDic objectForKey:@"stagename"]];
                    }
                }
            }
            [cell.textField setBk_shouldBeginEditingBlock:^BOOL(UITextField *textField) {
                weakSelf.flowLayout = [[UICollectionViewFlowLayout alloc]init];
                [weakSelf.flowLayout setMinimumLineSpacing:1];
                [weakSelf.flowLayout setMinimumInteritemSpacing:0.5];
                [weakSelf.flowLayout setItemSize:CGSizeMake([MainScreen bounds].size.width/2-0.5, 50)];
                weakSelf.invesVC = [[CollectionViewController alloc] initWithCollectionViewLayout:weakSelf.flowLayout withType:2 withData:_projectModel];
                weakSelf.invesVC.investBlock = ^(NSArray *investDic){
                    IInvestStageModel *stageM = investDic[0];
                    [weakSelf.projectModel setStage:stageM.stage];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakSelf.navigationController pushViewController:weakSelf.invesVC animated:YES];
                return NO;
            }];
        }else if (indexPath.row==1) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"融资金额"];
            [cell.textField setPlaceholder:nil];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setText:_projectModel.amount.stringValue];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [weakSelf.projectModel setAmount:@(textField.text.integerValue)];
                if (weakSelf.projectModel.amount.integerValue&&weakSelf.projectModel.share) {
                    [weakSelf.tableView reloadData];
                }
            }];
           UILabel *rightL = (UILabel *)cell.textField.rightView;
            [rightL setText:@"万(CNY)　"];
            [rightL sizeToFit];
        }else if (indexPath.row==2){
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:@"出让股份"];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setPlaceholder:nil];
            [cell.textField setText:_projectModel.share.stringValue];
            [cell.textField setBk_shouldBeginEditingBlock:nil];
            [cell.textField setBk_didEndEditingBlock:^(UITextField *textField) {
                [weakSelf.projectModel setShare:@(textField.text.integerValue)];
                if (weakSelf.projectModel.amount.integerValue&&weakSelf.projectModel.share) {
                    [weakSelf.tableView reloadData];
                }
            }];
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
            [cell.textView setDelegate:self];
        }
        [cell.titLabel setText:@"融资说明"];
        if (self.projectModel.financing.length) {
            [cell.textView setText:self.projectModel.financing];
            [cell.textView setPlaceholder:nil];
        }else{
            [cell.textView setPlaceholder:@"200字之内(选填)"];
        }
        return cell;
    }
    return nil;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.projectModel setFinancing:textView.text];
    return YES;
}


#pragma mark - 完成
- (void)finishPorject
{
    [self.view.findFirstResponder resignFirstResponder];
    WEAKSELF
    NSMutableDictionary *finishDic = [NSMutableDictionary dictionary];
    [finishDic setObject:self.projectModel.pid forKey:@"pid"];
    if (self.isFinancing) {
        [finishDic setObject:@(0) forKey:@"status"];
        [self.projectModel setStatus:@(0)];
    }else{
        [finishDic setObject:@(1) forKey:@"status"];
        [self.projectModel setStatus:@(1)];
    }
    if (!self.isFinancing) {
        if (self.projectModel.stage) {
            [finishDic setObject:self.projectModel.stage forKey:@"stage"];
        }else{
            [WLHUDView showErrorHUD:@"请设置融资阶段"];
            return;
        }
        if (self.projectModel.amount) {
            [finishDic setObject:self.projectModel.amount forKey:@"amount"];
        }else{
            [WLHUDView showErrorHUD:@"请填写融资金额"];
            return;
        }
        
        if (self.projectModel.amount.integerValue>=1) {
            [finishDic setObject:self.projectModel.amount forKey:@"amount"];
        }else{
            [WLHUDView showErrorHUD:@"请正确填写融资金额"];
            return;
        }
        if (self.projectModel.share) {
            [finishDic setObject:self.projectModel.share forKey:@"share"];
        }else{
            [WLHUDView showErrorHUD:@"请填写出让股份"];
            return;
        }

        if (self.projectModel.share.integerValue>=1 && self.projectModel.share.integerValue<=100) {
            [finishDic setObject:self.projectModel.share forKey:@"share"];
        }else{
            [WLHUDView showErrorHUD:@"请正确填写出让股份"];
            return;
        }
        if (self.projectModel.financing.length) {
            [finishDic setObject:self.projectModel.financing forKey:@"financing"];
        }
    }
    [WLHttpTool createProjectParameterDic:finishDic success:^(id JSON) {
        if (JSON) {
            [weakSelf.projectModel setPid:[JSON objectForKey:@"pid"]];
            [weakSelf.projectModel setShareurl:[JSON objectForKey:@"shareurl"]];
            [weakSelf.projectModel setFinancingtime:[JSON objectForKey:@"financingtime"]];
            
            [weakSelf.selfProjectM setPid:weakSelf.projectModel.pid];
            [weakSelf.selfProjectM setShareurl:weakSelf.projectModel.shareurl];
            [weakSelf.selfProjectM setStatus:weakSelf.projectModel.status];
            if (weakSelf.projectModel.status.integerValue==1) {
                [weakSelf.selfProjectM setAmount:weakSelf.projectModel.amount];
                [weakSelf.selfProjectM setShare:weakSelf.projectModel.share];
                [weakSelf.selfProjectM setStage:weakSelf.projectModel.stage];
                [weakSelf.selfProjectM setFinancing:weakSelf.projectModel.financing];
                [weakSelf.selfProjectM setFinancingtime:weakSelf.projectModel.financingtime];
            }else{
                [weakSelf.selfProjectM setAmount:nil];
                [weakSelf.selfProjectM setShare:nil];
                [weakSelf.selfProjectM setStage:nil];
                [weakSelf.selfProjectM setFinancingtime:nil];
            }
            ProjectDetailInfo *projectMR = [ProjectDetailInfo createWithIProjectDetailInfo:weakSelf.selfProjectM];
            if (weakSelf.isEdit) {
                if (weakSelf.projectDataBlock) {
                    weakSelf.projectDataBlock(projectMR);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                ProjectDetailsViewController *projectVC = [[ProjectDetailsViewController alloc] initWithProjectDetailInfo:weakSelf.selfProjectM];
                [weakSelf.navigationController pushViewController:projectVC animated:YES];
            }
        }

    } fail:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
