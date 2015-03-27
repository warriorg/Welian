//
//  WLNoteInfoView.m
//  Welian
//
//  Created by weLian on 15/3/27.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLNoteInfoView.h"

@interface WLNoteInfoView ()

@property (assign,nonatomic) UIActivityIndicatorView *activityView;//加载
@property (assign,nonatomic) UILabel *noteLabel;

@end

@implementation WLNoteInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setIsLoaded:(BOOL)isLoaded
{
    [super willChangeValueForKey:@"isLoaded"];
    _isLoaded = isLoaded;
    [super didChangeValueForKey:@"isLoaded"];
//    _activityView.hidden = _isLoaded;
    if (_isLoaded) {
        [_activityView stopAnimating];
    }else{
        [_activityView startAnimating];
    }
}

- (void)setNoteInfo:(NSString *)noteInfo
{
    [super willChangeValueForKey:@"noteInfo"];
    _noteInfo = noteInfo;
    [super didChangeValueForKey:@"noteInfo"];
    _noteLabel.text = _noteInfo;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_noteLabel sizeToFit];
    _noteLabel.centerY = self.height / 2.f;
    _noteLabel.centerX = self.width / 2.f;
    
    [_activityView sizeToFit];
    _activityView.centerY = self.height / 2.f;
    if (_activityView.hidden) {
        _noteLabel.centerX = self.width / 2.f;
    }else{
        _noteLabel.left = _noteLabel.left + 7;
    }
    _activityView.right = _noteLabel.left - 15.f;
}

#pragma mark - Private
- (void)setup
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.hidesWhenStopped = YES;
    [self addSubview:activityView];
    self.activityView = activityView;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor grayColor];
    noteLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:noteLabel];
    self.noteLabel = noteLabel;
}

@end
