//
//  FriendsNewCell.h
//  weLian
//
//  Created by dong on 14/10/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NewFriendModel.h"
#import "NewFriendUser.h"

@interface FriendsNewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *massgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *accLabel;

@property (weak, nonatomic) IBOutlet UIButton *accBut;

@property (nonatomic, strong) NewFriendUser *friendM;

@end
