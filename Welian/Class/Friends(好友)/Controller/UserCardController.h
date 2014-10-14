//
//  UserCardController.h
//  Welian
//
//  Created by dong on 14-9-17.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;

@interface UserCardController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UIImageView *entrepreneurImage;

@property (weak, nonatomic) IBOutlet UIImageView *investerImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emilLabel;

@property (weak, nonatomic) IBOutlet UIButton *addBut;

@property (weak, nonatomic) IBOutlet UIView *bageView;

@property (weak, nonatomic) IBOutlet UILabel *addresLabel;


@property (nonatomic, strong) UserInfoModel *userinfoM;

- (IBAction)butCick:(id)sender;

@end
