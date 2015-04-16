//
//  NameController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NameController.h"
#import "WLTextField.h"

@interface NameController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UserInfoBlock _userBlock;
    IWVerifiedType _verType;
    BOOL _isSave;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WLTextField *searchTextField;

@property (nonatomic, retain) NSOperationQueue *searchQueue;

@end

@implementation NameController

- (WLTextField *)searchTextField
{
    if (_searchTextField == nil) {
        _searchTextField = [[WLTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [_searchTextField addTarget:self action:@selector(searchTextFiled:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_searchTextField setText:self.userInfoStr];
        [_searchTextField becomeFirstResponder];
    }
    return _searchTextField;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (id)initWithBlock:(UserInfoBlock)block withType:(IWVerifiedType)verType
{
    self = [super init];
    if (self) {
        _userBlock = block;
        _verType = verType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveInfo:)];
    self.searchQueue = [[NSOperationQueue alloc] init];
    [self.searchQueue setMaxConcurrentOperationCount:1];
    
    if (self.userInfoStr.length>0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    [self.view addSubview:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.searchQueue cancelAllOperations];
    if (_isSave) {
        _userBlock(self.searchTextField.text);
    }
}

- (void)saveInfo:(UIBarButtonItem*)itme
{
    if (_verType == IWVerifiedTypeMailbox) {
        //邮箱
        if (self.searchTextField.text.length > 0 && ![self.searchTextField.text isEmail]) {
            [WLHUDView showErrorHUD:@"邮箱格式不正确！"];
            return;
        }
    }
    _isSave = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchTextFiled:(WLTextField *)textFiled
{
    [self.searchQueue cancelAllOperations];
    if (textFiled.text.length) {
         [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.searchQueue addOperationWithBlock:^{
            
            [self beginSearchData:textFiled.text];
            
        }];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.dataArray removeAllObjects];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)beginSearchData:(NSString *)searchText
{
    if (searchText.length) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        if (_verType==IWVerifiedTypeCompany) {
            
            [WLHttpTool getCompanyParameterDic:@{@"start":@(1),@"size":@(50),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = [NSMutableArray arrayWithArray:JSON];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }else if (_verType == IWVerifiedTypeJob){
            [WLHttpTool getJobParameterDic:@{@"start":@(1),@"size":@(50),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = [NSMutableArray arrayWithArray:JSON];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
            
        }else if (_verType == IWVerifiedTypeSchool){
            
            [WLHttpTool getSchoolParameterDic:@{@"start":@(1),@"size":@(50),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = [NSMutableArray arrayWithArray:JSON];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }
        
    }
}


#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecellID"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecellID"];
            [cell.contentView addSubview:self.searchTextField];
        }
        return cell;
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
        
        NSDictionary *dataDic = _dataArray[indexPath.row];
        [cell.textLabel setText:[dataDic objectForKey:@"name"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        NSString *name = [_dataArray[indexPath.row] objectForKey:@"name"];
        [self.searchTextField setText:name];
        _isSave = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
