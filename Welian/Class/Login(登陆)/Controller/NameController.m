//
//  NameController.m
//  Welian
//
//  Created by dong on 14-9-11.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NameController.h"

@interface NameController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
    UserInfoBlock _userBlock;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NameController

- (UITextField*)infoTextF
{
    if (nil == _infoTextF) {
        _infoTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width-15, 47)];
        [_infoTextF setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_infoTextF setDelegate:self];
        [_infoTextF setText:self.userInfoStr];
    }
    return _infoTextF;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

- (id)initWithBlock:(UserInfoBlock)block
{
    self = [super init];
    if (self) {
        _userBlock = block;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.infoTextF becomeFirstResponder];
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
    _userBlock(self.infoTextF.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextField代理
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location==0&&string.length) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    if (range.location==0&&string.length==0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }

    return YES;
}

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
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    if (indexPath.section==0) {
        [cell.contentView addSubview:self.infoTextF];

//        [self.infoTextF setText:@"qwerqewe"];
    }else{
    
    }
    return cell;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.infoTextF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
