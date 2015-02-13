//
//  TextFieldCell.m
//  Welian
//
//  Created by dong on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, self.bounds.size.width-120, self.bounds.size.height)];
        [_textField setFont:WLFONT(15)];
//        [_textField setTextAlignment:NSTextAlignmentCenter];
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textField setRightViewMode:UITextFieldViewModeAlways];
        UILabel *rightLabel = [[UILabel alloc] init];
        [rightLabel setTextAlignment:NSTextAlignmentCenter];
        [rightLabel setTextColor:[UIColor grayColor]];
        [rightLabel setFont:WLFONT(13)];
        [_textField setRightView:rightLabel];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
