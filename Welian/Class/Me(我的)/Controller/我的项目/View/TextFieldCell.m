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
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, self.bounds.size.width-120, self.bounds.size.height)];
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
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
