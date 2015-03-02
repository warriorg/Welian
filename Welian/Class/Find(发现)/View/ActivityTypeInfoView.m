//
//  ActivityTypeInfoView.m
//  Welian
//
//  Created by weLian on 15/2/11.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityTypeInfoView.h"
#import "ActivityTypeInfoCell.h"
#import "WLLocationHelper.h"

#define kTableViewCellHeight 43.f

@interface ActivityTypeInfoView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (assign,nonatomic) BOOL isFromLeft;
@property (assign,nonatomic) CGRect showFrame;

@property (nonatomic, strong) WLLocationHelper *locationHelper;

@end

@implementation ActivityTypeInfoView

- (void)dealloc
{
    _datasource = nil;
    _block = nil;
}

- (WLLocationHelper *)locationHelper {
    if (!_locationHelper) {
        _locationHelper = [[WLLocationHelper alloc] init];
    }
    return _locationHelper;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setNormalInfo:(NSString *)normalInfo
{
    [super willChangeValueForKey:@"normalInfo"];
    _normalInfo = normalInfo;
    [super didChangeValueForKey:@"normalInfo"];
    NSInteger selectRow = [_datasource indexOfObject:_normalInfo];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //获取地理位置信息
    if (_showLocation) {
        [self.locationHelper getCurrentGeolocationsCompled:^(NSArray *placemarks) {
            CLPlacemark *placemark = [placemarks lastObject];
            if (placemark) {
                NSDictionary *addressDictionary = placemark.addressDictionary;
                NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
                NSString *geoLocations = [formattedAddressLines lastObject];
                if (geoLocations) {
                    //                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
                    DLog(@"当前城市：%@",addressDictionary[@"City"]);
                    NSMutableArray *all = [NSMutableArray arrayWithArray:_datasource];
                    [all replaceObjectAtIndex:0 withObject:addressDictionary[@"City"]];
                    self.datasource = [NSArray arrayWithArray:all];
                    [_tableView reloadData];
                    
                    NSInteger selectRow = [_datasource indexOfObject:_normalInfo];
                    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }];
    }
}

//- (void)setDatasource:(NSArray *)datasource
//{
//    [super willChangeValueForKey:@"datasource"];
//    _datasource = datasource;
//    [super didChangeValueForKey:@"datasource"];
////    [_tableView reloadData];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0.f, 0.f, self.width, kTableViewCellHeight * _datasource.count);
    
}

#pragma mark - UITableView Datasource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Activity_Type_Info_View_Cell";
    
    ActivityTypeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ActivityTypeInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _datasource[indexPath.row];
    if (_showLocation && indexPath.row == 0) {
        cell.detailTextLabel.text = @"GPS定位";
    }else{
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_showLocation){
        if (indexPath.row == 0 && [_datasource[indexPath.row] isEqualToString:@"定位中..."]) {
            return;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_block) {
        [self dismissWithFrame:_showFrame];
        _block(_datasource[indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

#pragma mark - UIGestureRecognizerDelegate 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    DLog(@"touch.view：%@",[touch.view class]);
    ///UITableViewCellContentView
    if ([[NSString stringWithFormat:@"%@",[touch.view class]] isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    //隐藏表格分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//        if (_isFromLeft) {
//            [self dismissToLeft];
//        }else{
//            [self dismissToRight];
//        }
        [self dismissWithFrame:_showFrame];
    }];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)showInViewFromLeft:(UIView *)view
{
    self.isFromLeft = YES;
    self.left = -view.width;
    [UIView animateWithDuration:.3f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.left = 0;
                         self.hidden = NO;
                     } completion:^(BOOL finished) {
                         self.left = 0;
                     }];
}

- (void)dismissToLeft
{
    [UIView animateWithDuration:.2f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.left = -self.width;
                     } completion:^(BOOL finished) {
                         self.left = -self.width;
                         self.hidden = YES;
                     }];
}

- (void)showInViewFromRight:(UIView *)view
{
    self.left = self.width;
    [UIView animateWithDuration:.3f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.left = 0;
                         self.hidden = NO;
                     } completion:^(BOOL finished) {
                         self.left = 0;
                     }];
}

- (void)dismissToRight
{
    [UIView animateWithDuration:.2f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.left = self.width;
                     } completion:^(BOOL finished) {
                         self.left = self.width;
                         self.hidden = YES;
                     }];
}

//从上向下展示
- (void)showInViewWithFrame:(CGRect)frame
{
    self.bottom = frame.origin.y;
    self.showFrame = frame;
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.top = frame.origin.y;
                         self.hidden = NO;
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
                     } completion:^(BOOL finished) {
                         self.hidden = NO;
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                         self.top = frame.origin.y;
                     }];
}

- (void)dismissWithFrame:(CGRect)frame
{
    [UIView animateWithDuration:.2f
                          delay:.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottom = frame.origin.y;
                         self.backgroundColor = [UIColor clearColor];
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                         self.bottom = frame.origin.y;
                         self.backgroundColor = [UIColor clearColor];
                     }];
}

@end
