//
//  CompotAndPostController.m
//  Welian
//
//  Created by dong on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "CompotAndPostController.h"
#import "BiaoQianView.h"

@interface CompotAndPostController () <UITextFieldDelegate,BiaoQianViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_searchTF;
    NSInteger _type;
    UIView *_backdropView;
}

@property (nonatomic, retain) NSOperationQueue *searchQueue;
@property (nonatomic, strong) BiaoQianView *postView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *searchArray;
@end

@implementation CompotAndPostController

- (void)biaoQianView:(BiaoQianView *)biaoqian selectBiaoqian:(NSString *)selectString
{
    self.comPostBlock(selectString);
    [self cancelVC];
}

- (BiaoQianView *)postView
{
    if (_postView == nil) {
        _postView = [[BiaoQianView alloc] initWithFrame:CGRectMake(0, 85, SuperSize.width, SuperSize.height-85)];
        NSArray *postArray = @[@{@"name":@"创始人"},@{@"name":@"合伙人"},@{@"name":@"CEO"},@{@"name":@"投资经理"},@{@"name":@"媒体人"},@{@"name":@"产品经理"},@{@"name":@"运营经理"}];
        [_postView setDataArray:postArray];
        [_postView setDelegate:self];
    }
    return _postView;
}


- (UITableView *)tableView
{
    if (_tableView ==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, SuperSize.width, SuperSize.height-85) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionHeaderHeight:0];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return _tableView;
}

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self.view setBackgroundColor:WLRGB(231, 234, 238)];
        _backdropView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_backdropView setBackgroundColor:WLRGB(231, 234, 238)];
        [self.view addSubview:_backdropView];
        NSString *placeholder = @"单位";
        NSString *imagename = @"login_gongsi";
        if (type ==2) {
            placeholder = @"职位";
            imagename = @"login_zhiwei";
        }
        UITextField *searchTF = [self addPerfectInfoTextfWithFrameY:CGRectMake(10, 30, SuperSize.width-10-60, 40) Placeholder:placeholder leftImageName:imagename];
        [searchTF addTarget:self action:@selector(searchTextFiled:) forControlEvents:UIControlEventEditingChanged];
        [_backdropView addSubview:searchTF];
        _searchTF = searchTF;
        
        UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(SuperSize.width-60, 30, 60, 40)];
        [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBut setTitleColor:WLRGB(52, 116, 186) forState:UIControlStateNormal];
        [cancelBut addTarget:self action:@selector(cancelVC) forControlEvents:UIControlEventTouchUpInside];
        [_backdropView addSubview:cancelBut];
        [_backdropView addSubview:self.tableView];
        if (type==1) {
            
        }else if (type==2){
            [_backdropView addSubview:self.postView];
            [_backdropView insertSubview:self.tableView belowSubview:self.postView];
        }

        self.searchQueue = [[NSOperationQueue alloc] init];
        [self.searchQueue setMaxConcurrentOperationCount:1];
        self.searchArray = [NSArray array];
    }
    return self;
}

- (void)searchTextFiled:(UITextField *)textFiled
{
    [self.searchQueue cancelAllOperations];
    if (textFiled.text.length) {
        [self.searchQueue addOperationWithBlock:^{
            
            [self beginSearchData:textFiled.text];
            
        }];
    }
}

- (void)beginSearchData:(NSString *)searchText
{
    if (_type ==1) {
        [WLHttpTool getCompanyParameterDic:@{@"start":@(1),@"size":@(50),@"keyword":searchText} success:^(id JSON) {
            self.searchArray = JSON;
            
            [self.tableView reloadData];
            DLog(@"%@",JSON);
        } fail:^(NSError *error) {
            
        }];
    }else if (_type ==2){
        [WLHttpTool getJobParameterDic:@{@"start":@(1),@"size":@(50),@"keyword":searchText} success:^(id JSON) {
            self.searchArray = JSON;
            [self.tableView reloadData];
            [_backdropView insertSubview:self.postView belowSubview:self.tableView];
        } fail:^(NSError *error) {
            
        }];

    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_backdropView setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [_backdropView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [_searchTF becomeFirstResponder];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"compotAndpostcellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSDictionary *dic = self.searchArray[indexPath.row];
    [cell.textLabel setText:[dic objectForKey:@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.searchArray[indexPath.row];
    self.comPostBlock([dic objectForKey:@"name"]);
    [self cancelVC];
}


- (UITextField *)addPerfectInfoTextfWithFrameY:(CGRect)rect Placeholder:(NSString *)placeholder leftImageName:(NSString *)imagename
{
    UITextField *textf = [[UITextField alloc] initWithFrame:rect];
    [textf setPlaceholder:placeholder];
    [textf setDelegate:self];
    [textf setReturnKeyType:UIReturnKeyDone];
    [textf setLeftViewMode:UITextFieldViewModeAlways];
    [textf setRightViewMode:UITextFieldViewModeAlways];
    [textf setBackgroundColor:[UIColor whiteColor]];
    [textf setClearButtonMode:UITextFieldViewModeWhileEditing];
    UIButton *nameleftV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
    [nameleftV setUserInteractionEnabled:NO];
    [nameleftV setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [textf setLeftView:nameleftV];
    [textf.layer setCornerRadius:4];
    [textf.layer setMasksToBounds:YES];
    return textf;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_searchTF.text.length) {
        self.comPostBlock(textField.text);
        [self cancelVC];
    }else{
        [_searchTF resignFirstResponder];
    }
    return YES;
}

- (void)cancelVC
{
    [_searchTF resignFirstResponder];
    [UIView animateWithDuration:0.15 animations:^{
        [_backdropView setAlpha:0];
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];

    }];
    
}

- (void)dealloc
{
    [self.searchQueue cancelAllOperations];
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
