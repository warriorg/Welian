//
//  NotstringView.m
//  weLian
//
//  Created by dong on 14/11/15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NotstringView.h"

@interface NotstringView ()


@end

@implementation NotstringView

//- (instancetype)initWithFrame:(CGRect)frame withTitStr:(NSString *)titStr andImageName:(NSString *)imageName
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        UIImage *image = [UIImage imageNamed:imageName];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [imageView setCenter:self.center];
//        CGRect imageframe = imageView.frame;
//        imageframe.origin.y -= 100;
//        [imageView setFrame:imageframe];
//        [self addSubview:imageView];
//        
//        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, frame.size.width, 40)];
//        [titLabel setText:titStr];
//        [titLabel setNumberOfLines:0];
//        [titLabel setTextAlignment:NSTextAlignmentCenter];
//        [titLabel setTextColor:WLRGB(170, 178, 182)];
//        [self addSubview:titLabel];
//    }
//    return self;
//}

//1个标题和图片
- (instancetype)initWithFrame:(CGRect)frame
                   withTitStr:(NSString *)titStr
                 andImageName:(NSString *)imageName
{
    return [self initWithFrame:frame
                     ImageName:imageName
                  withTitleStr:titStr
                      SubTitle:nil
                      BtnTitle:nil
                  BtnImageName:nil];
}

//单个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr
{
    return [self initWithFrame:frame
                  withTitleStr:titleStr
                      SubTitle:nil];
}

///2个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle
{
    return [self initWithFrame:frame
                     ImageName:nil
                  withTitleStr:titleStr
                      SubTitle:subTitle
                      BtnTitle:nil
                  BtnImageName:nil];
}

//单个图片
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
{
    return [self initWithFrame:frame
                    withTitStr:nil
                  andImageName:imageName];
}

///2个标题
- (instancetype)initWithFrame:(CGRect)frame
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle
                     BtnTitle:(NSString *)btnTitle
                 BtnImageName:(NSString *)btnImageName
{
    return [self initWithFrame:frame
                     ImageName:nil
                  withTitleStr:titleStr
                      SubTitle:subTitle
                      BtnTitle:btnTitle
                  BtnImageName:btnImageName];
}

///2个标题 1个操作按钮
- (instancetype)initWithFrame:(CGRect)frame
                    ImageName:(NSString *)imageName
                 withTitleStr:(NSString *)titleStr
                     SubTitle:(NSString *)subTitle
                     BtnTitle:(NSString *)btnTitle
                 BtnImageName:(NSString *)btnImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat top = self.height / 4.f;
        //图片
        if (imageName) {
            UIImage * image = [UIImage imageNamed:imageName];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setCenter:self.center];
            CGRect imageframe = imageView.frame;
            imageframe.origin.y -= 150;
            [imageView setFrame:imageframe];
            [self addSubview:imageView];
            
            top = CGRectGetMaxY(imageView.frame) + 10.f;
        }
        
        //第一个标题
        if(titleStr){
            UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, top, frame.size.width - 60, 40)];
            
            [titLabel setText:titleStr];
            titLabel.font = kNormal15Font;
            [titLabel setTextAlignment:NSTextAlignmentCenter];
            [titLabel setTextColor:WLRGB(170, 178, 182)];
            [titLabel setNumberOfLines:0];
            [titLabel sizeToFit];
            titLabel.centerX = frame.size.width / 2.f;
            [self addSubview:titLabel];
            
            top = CGRectGetMaxY(titLabel.frame) + 10.f;
        }
        
        //第一个标题
        if(subTitle){
            UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, top, frame.size.width - 60, 40)];
            [subTitleLabel setText:subTitle];
            subTitleLabel.font = kNormal14Font;
            [subTitleLabel setNumberOfLines:0];
            [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
            [subTitleLabel setTextColor:WLRGB(170, 178, 182)];
            [subTitleLabel sizeToFit];
            [self addSubview:subTitleLabel];
            
            top = CGRectGetMaxY(subTitleLabel.frame) + 15.f;
        }
        
        //按钮
        if (btnTitle || btnImageName) {
            UIButton *opeateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            opeateBtn.backgroundColor = [UIColor whiteColor];
            opeateBtn.titleLabel.font = kNormal16Font;
            if (btnTitle) {
                [opeateBtn setTitle:btnTitle forState:UIControlStateNormal];
                [opeateBtn setTitleColor:RGB(51.f, 115.f, 186.f) forState:UIControlStateNormal];
            }
            if (btnImageName) {
                [opeateBtn setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
            }
            opeateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
            opeateBtn.frame = CGRectMake(30.f, top, frame.size.width - 60.f, 40.f);
            opeateBtn.layer.borderWidth = 0.8;
            opeateBtn.layer.borderColor = RGB(208.f, 209.f, 209.f).CGColor;
            opeateBtn.layer.cornerRadius = 3.f;
            opeateBtn.layer.masksToBounds = YES;
            [opeateBtn addTarget:self action:@selector(opeateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:opeateBtn];
        }
    }
    return self;
}

- (void)opeateBtnClicked:(UIButton *)sender
{
    if (_BtnClickedBlock) {
        _BtnClickedBlock();
    }
}

@end
