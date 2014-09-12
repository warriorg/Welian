//
//  PublishStatusController.m
//  Welian
//
//  Created by dong on 14-9-12.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "PublishStatusController.h"

@interface PublishStatusController ()
@property (nonatomic, strong) UIScrollView *backGScroll;
@end

@implementation PublishStatusController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUiItems];
}

- (void)setUiItems
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"发布动态"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmPublish)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPublish)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.backGScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.backGScroll];
}

#pragma mark - 确认发布
- (void)confirmPublish
{

}



#pragma mark - 取消
- (void)cancelPublish
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
