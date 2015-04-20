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
#define kTableViewMaxHeight (ScreenHeight - 200.f)

@interface ActivityTypeInfoView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (assign,nonatomic) UITableView *tableView;
@property (assign,nonatomic) BOOL isFromLeft;
@property (assign,nonatomic) CGRect showFrame;

@property (strong,nonatomic) NSArray *cityArrayDic;
@property (strong,nonatomic) NSArray *provinceArrayDic;

@property (strong,nonatomic) WLLocationHelper *locationHelper;
@property (strong,nonatomic) CLGeocoder* geocoder;

@end

@implementation ActivityTypeInfoView

- (void)dealloc
{
    _datasource = nil;
    _block = nil;
    _cityArrayDic = nil;
    _provinceArrayDic = nil;
    _locationHelper = nil;
    _geocoder = nil;
}

- (CLGeocoder*)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
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

// 筛选等级
- (NSArray *)siftArray:(NSArray*)dicArray orderWithKey:(NSString *)key{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%@ CONTAINS name",key];
    return [dicArray filteredArrayUsingPredicate:pre];
}

- (void)setNormalInfo:(NSDictionary *)normalInfo
{
    [super willChangeValueForKey:@"normalInfo"];
    _normalInfo = normalInfo;
    [super didChangeValueForKey:@"normalInfo"];
    NSInteger selectRow = [_datasource indexOfObject:_normalInfo];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //获取地理位置信息
    if (_showLocation) {
        // 定位
        [[LocationTool sharedLocationTool] statLocationMy];
        
        WEAKSELF
        [[LocationTool sharedLocationTool] setUserLocationBlock:^(BMKUserLocation *userLocation){
            [weakSelf getLoactionCityInfoWith:userLocation];
        }];
    }
//        [self.locationHelper getCurrentGeolocationsCompled:^(NSArray *placemarks) {
//            if (placemarks.count > 0) {
//                CLPlacemark *placemark = [placemarks firstObject];
//                if (placemark) {
//                    NSDictionary *addressDictionary = placemark.addressDictionary;
//                    //                NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
//                    //                NSString *geoLocations = [formattedAddressLines lastObject];
//                    if (placemark.locality.length > 0 || addressDictionary != nil) {
//                        //                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
//                        NSString *cityStr = placemark.locality.length > 0 ? placemark.locality : addressDictionary[@"City"];
//                        if (cityStr.length > 0) {
//                            NSString *city = [cityStr hasSuffix:@"市"] ? [cityStr stringByReplacingOccurrencesOfString:@"市" withString:@""] : cityStr;
//                            DLog(@"当前城市：%@ ---- placemark.locality:%@",city,placemark.locality);
//                            NSMutableArray *all = [NSMutableArray arrayWithArray:_datasource];
//                            //判断是否在城市列表中
//                            NSDictionary *locationCityDic = nil;
//                            NSArray *citys = [self siftArray:_cityArrayDic orderWithKey:city];
//                            if (citys.count == 0) {
//                                NSArray *provinces = [self siftArray:_provinceArrayDic orderWithKey:city];
//                                NSDictionary *dic = [provinces firstObject];
//                                locationCityDic = @{@"cityid":dic[@"pid"],@"name":cityStr};
//                            }else{
//                                NSDictionary *dic = [citys firstObject];
//                                locationCityDic = @{@"cityid":dic[@"cid"],@"name":cityStr};
//                            }
//                            if(locationCityDic){
//                                [all replaceObjectAtIndex:0 withObject:locationCityDic];
//                            }
//                            self.datasource = [NSArray arrayWithArray:all];
//                        }
//                        
//                        //刷新第一行
//                        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                        
//                        NSInteger selectRow = [_datasource indexOfObject:_normalInfo];
//                        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//                    }
//                }
//            }
//        }];
}

- (void)getLoactionCityInfoWith:(BMKUserLocation *)userLocation
{
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray* placemarks, NSError* error) {
        if(!error){
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                if (placemark) {
                    NSDictionary *addressDictionary = placemark.addressDictionary;
                    //                NSArray *formattedAddressLines = [addressDictionary valueForKey:@"FormattedAddressLines"];
                    //                NSString *geoLocations = [formattedAddressLines lastObject];
                    if (addressDictionary != nil) {
                        //                        [weakSelf didSendGeolocationsMessageWithGeolocaltions:geoLocations location:placemark.location];
                        NSString *cityStr = addressDictionary[@"City"];//市
                        NSString *stateStr =  addressDictionary[@"State"];//省
                        
                        DLog(@"当前城市：%@ --省: %@-- placemark.locality:%@",cityStr,stateStr,placemark.locality);
                        
                        NSString * city = cityStr ? cityStr : stateStr;
                        if (city.length > 0) {
//                            NSRange range = [cityStr rangeOfString:@"市"]; //现获取要截取的字符串位置
//                            NSString * city = [cityStr substringToIndex:range.location]; //截取字符串
//                            NSString *city = [cityStr hasSuffix:@"市"] ? [cityStr stringByReplacingOccurrencesOfString:@"市" withString:@""] : cityStr;
                            //定位的城市
                            [UserDefaults setObject:city forKey:kLocationCity];
                            
                            NSMutableArray *all = [NSMutableArray arrayWithArray:_datasource];
                            //判断是否在城市列表中
                            NSDictionary *locationCityDic = nil;
                            NSArray *citys = [self siftArray:_cityArrayDic orderWithKey:city];
                            if (citys.count == 0) {
                                NSArray *provinces = [self siftArray:_provinceArrayDic orderWithKey:city];
                                if (provinces.count > 0) {
                                    NSDictionary *dic = [provinces firstObject];
                                    locationCityDic = @{@"cityid":dic[@"pid"],@"name":cityStr};
                                }else{
                                    //不存在的位置信息  -1:列表中没有定位的城市
                                    locationCityDic = @{@"cityid":@(-1),@"name":cityStr};
                                }
                            }else{
                                NSDictionary *dic = [citys firstObject];
                                locationCityDic = @{@"cityid":dic[@"cid"],@"name":cityStr};
                            }
                            if(locationCityDic){
                                [all replaceObjectAtIndex:0 withObject:locationCityDic];
                            }
                            self.datasource = [NSArray arrayWithArray:all];
                        }
                        
                        //刷新第一行
                        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        
                        NSInteger selectRow = [_datasource indexOfObject:_normalInfo];
                        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    }
                }
            }
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0.f, 0.f, self.width, (kTableViewCellHeight * _datasource.count < kTableViewMaxHeight) ? kTableViewCellHeight * _datasource.count : kTableViewMaxHeight);
    
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
    cell.textLabel.text = [_datasource[indexPath.row] objectForKey:@"name"];
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
        if (indexPath.row == 0 && [[_datasource[indexPath.row] objectForKey:@"name"] isEqualToString:@"定位中..."]) {
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
    
    //获取城市列表
    NSURL *cityurl =[[NSBundle mainBundle] URLForResource:@"citys" withExtension:@"plist"];
    self.cityArrayDic = [NSArray arrayWithContentsOfURL:cityurl];
    
    //获取省列表
    NSURL *provinceurl =[[NSBundle mainBundle] URLForResource:@"province" withExtension:@"plist"];
    self.provinceArrayDic = [NSArray arrayWithContentsOfURL:provinceurl];
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
