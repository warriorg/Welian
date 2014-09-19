//
//  FriendsController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsController.h"
#import "WLTool.h"
//#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>

@interface FriendsController () <UITableViewDelegate,UITableViewDataSource>
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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
