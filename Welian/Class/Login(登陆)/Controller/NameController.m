//
//  NameController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NameController.h"

@interface NameController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>
{
    UserInfoBlock _userBlock;
    IWVerifiedType _verType;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *search;

@end

@implementation NameController

- (UISearchBar *)search
{
    if (nil== _search) {
        _search = [[UISearchBar alloc] initWithFrame:CGRectZero];
        [_search setText:self.userInfoStr];
        [_search setDelegate:self];
        [_search setFrame:CGRectMake(-20, 0, self.view.bounds.size.width+20, 44)];
        [_search setBackgroundColor:[UIColor whiteColor]];
        [_search setTintColor:[UIColor whiteColor]];
        [_search setBarTintColor:[UIColor whiteColor]];
        UITextField *adaf = [[[[_search subviews] objectAtIndex:0] subviews] objectAtIndex:1];
        [adaf setFont:[UIFont systemFontOfSize:17]];
        [adaf.leftView setHidden:YES];
        [adaf setTextAlignment:NSTextAlignmentLeft];
    }
    
    return _search;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        if (_verType==IWVerifiedTypeCompany) {
            
            [WLHttpTool getCompanyParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = JSON;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }else if (_verType == IWVerifiedTypeJob){
            [WLHttpTool getJobParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = JSON;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
            
        }else if (_verType == IWVerifiedTypeSchool){
            
            [WLHttpTool getSchoolParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":searchText} success:^(id JSON) {
                self.dataArray = JSON;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSError *error) {
                
            }];
        }
        
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        self.dataArray = nil;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

//- (UITextField*)infoTextF
//{
//    if (nil == _infoTextF) {
//        _infoTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width-15, 47)];
//        [_infoTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
//        [_infoTextF addTarget:self action:@selector(beginSearchData:) forControlEvents:UIControlEventEditingChanged];
//        [_infoTextF setDelegate:self];
//        [_infoTextF setText:self.userInfoStr];
//    }
//    return _infoTextF;
//}


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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.search becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveInfo:)];
    
    if (self.userInfoStr.length>0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    [self.view addSubview:self.tableView];
}

- (void)saveInfo:(UIBarButtonItem*)itme
{
    _userBlock(self.search.text);
    [self.navigationController popViewControllerAnimated:YES];
}



//#pragma mark TextField代理
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (range.location==0&&string.length) {
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//    }
//    if (range.location==0&&string.length==0) {
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    }
////    [self beginSearchData:textField];
//    return YES;
//}

//- (void)beginSearchData:(UITextField *)textField
//{
//    DLog(@"%@",textField.text);
//    if (textField.text.length) {
//        [self.navigationItem.rightBarButtonItem setEnabled:YES];
//        
//        if (_verType==IWVerifiedTypeCompany) {
//            
//            [WLHttpTool getCompanyParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":textField.text} success:^(id JSON) {
//                
//                
//            } fail:^(NSError *error) {
//                
//            }];
//        }else if (_verType == IWVerifiedTypeJob){
//            [WLHttpTool getJobParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":textField.text} success:^(id JSON) {
//                
//            } fail:^(NSError *error) {
//                
//            }];
//            
//        }else if (_verType == IWVerifiedTypeSchool){
//            
//            [WLHttpTool getSchoolParameterDic:@{@"start":@(1),@"size":@(20),@"keyword":textField.text} success:^(id JSON) {
//                
//            } fail:^(NSError *error) {
//                
//            }];
//        }
//
//    }else{
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    }
//}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    return YES;
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
    return 47.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 40.0;
    }
        return 20.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section&&self.dataArray.count) {
        UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
        sectionHeader.font = [UIFont systemFontOfSize:16];
        sectionHeader.textColor = [UIColor grayColor];
        sectionHeader.text = [NSString stringWithFormat:@"    你是不是要找："];
        return sectionHeader;
    }
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecellID"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecellID"];
            [cell.contentView addSubview:self.search];
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
        _userBlock(name);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
