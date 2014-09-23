//
//  FriendsController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsController.h"

@interface FriendsController () <UITableViewDelegate,UITableViewDataSource>

{
    FriendBlock _frienBlock;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FriendsController

- (void)viewWillAppear:(BOOL)animated
{
    if ([[UserDefaults objectForKey:KAddressBook] integerValue]) {
        self.dataArray = [NSArray arrayWithArray:[WLTool getAddressBookArray]];
    }else {
        self.dataArray = [NSArray array];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"  啊啊" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (instancetype)initWithFrienBlock:(FriendBlock)frienBlock
{
    self = [super init];
    if (self) {
        _frienBlock = frienBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(saveuser:)];
    
    if (self.seleArray==nil) {
        
        self.seleArray = [NSMutableArray array];
    }
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *indecell = @"cellind";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indecell];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indecell];
    }
    PeopleAddressBook *people = self.dataArray[indexPath.row];
    [cell.textLabel setText:people.name];
    [cell.detailTextLabel setText:people.Aphone];
    NSLog(@"cellname---%@\n cellphone---%@\n cellpppp---%@",people.name,people.Aphone,people.Bphone);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PeopleAddressBook *peoBook = self.dataArray[indexPath.row];
    if (self.seleArray.count) {
        for (PeopleAddressBook *selePeo in self.seleArray) {
            if (peoBook == selePeo) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [self.seleArray removeObject:peoBook];
            }else{
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [self.seleArray addObject:peoBook];
            }
        }
    }else{
        [self.seleArray addObject:peoBook];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
}

- (void)saveuser:(UIBarButtonItem*)item
{
    _frienBlock(self.seleArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
