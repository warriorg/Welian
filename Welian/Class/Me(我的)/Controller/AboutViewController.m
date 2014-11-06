//
//  AboutViewController.m
//  weLian
//
//  Created by dong on 14/11/4.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"关于weLian"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *aboutImage = [UIImage imageNamed:@"about_welian_logo"];
    UIImageView *aboutImageView = [[UIImageView alloc] initWithImage:aboutImage];
    [aboutImageView setCenter:CGPointMake(self.view.center.x, 64+30+aboutImage.size.height*0.5)];
    [self.view addSubview:aboutImageView];
    
    
    NSString *localVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    UILabel *verLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(aboutImageView.frame)+10, self.view.bounds.size.width, 30)];
    [verLabel setFont:[UIFont systemFontOfSize:15]];
    [verLabel setTextColor:[UIColor lightGrayColor]];
    [verLabel setText:[NSString stringWithFormat:@"Ver %@",localVersion]];
    [verLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:verLabel];
    
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(verLabel.frame)+30, self.view.bounds.size.width, 30)];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [titLabel setText:@"专注于互联网创业的社交平台"];
    [titLabel setFont:[UIFont systemFontOfSize:17]];
    [titLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titLabel];

    
    UILabel *hiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 30)];
    [hiLabel setTextColor:[UIColor lightGrayColor]];
    [hiLabel setText:@"hi@weLian.com"];
    [hiLabel setFont:[UIFont systemFontOfSize:14]];
    [hiLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:hiLabel];
    
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
