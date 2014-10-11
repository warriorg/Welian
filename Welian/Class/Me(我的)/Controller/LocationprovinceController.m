//
//  LocationprovinceController.m
//  weLian
//
//  Created by dong on 14-10-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LocationprovinceController.h"
#import "FMDB.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CityLocationController.h"

@interface LocationprovinceController ()
{
    NSString *_locationStr;
    NSArray *_provinArray;
    NSDictionary *_cityArrayDic;
    
    NSDictionary *locWithDic;
}

// 地理编码器
@property (nonatomic, strong) CLGeocoder  *geocoder;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation LocationprovinceController

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setFrame:CGRectMake(50, 10, 30, 30)];
    }
    return _activityView;
}

- (CLGeocoder*)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSectionFooterHeight:0.0];
    [self.tableView setSectionHeaderHeight:35.0];
    [self statLocationMy];
    [self loadDatadb];
}

- (void)loadDatadb
{
    // 1.获得路径
    NSURL *provurl = [[NSBundle mainBundle] URLForResource:@"province" withExtension:@"plist"];
    _provinArray = [NSArray arrayWithContentsOfURL:provurl];
    
    NSURL *cityurl =[[NSBundle mainBundle] URLForResource:@"city" withExtension:@"plist"];
    _cityArrayDic = [NSDictionary dictionaryWithContentsOfURL:cityurl];
    
    [self.tableView reloadData];
}

//- (void)loadDatadb
//{
//    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        return;
//    }
//    FMResultSet *rs = [db executeQuery:@"select * from city where pid = 1"];
//    NSMutableArray *datacityA = [NSMutableArray array];
//    
//    while ([rs next]) {
//        NSString *name = [rs stringForColumn:@"Name"];
//        NSString *cityid = [rs stringForColumn:@"id"];
//        [datacityA addObject:@{@"name":name,@"pid":cityid}];
//    }
//    NSString *multiHomePath = [NSHomeDirectory() stringByAppendingPathComponent:@"province.plist"];
//
//    [datacityA writeToFile:multiHomePath atomically:YES];
//
//    NSMutableDictionary *daadic = [NSMutableDictionary dictionary];
//    
//    for (NSDictionary *dic  in datacityA) {
//        NSMutableArray *aaaa = [NSMutableArray array];
//        
//        rs = [db executeQuery:[NSString stringWithFormat:@"select * from city where pid = %d",[[dic objectForKey:@"pid"] intValue]]];
//        while ([rs next]) {
//            NSString *name = [rs stringForColumn:@"Name"];
//            NSString *cityid = [rs stringForColumn:@"id"];
//            [aaaa addObject:@{@"name":name,@"cid":cityid}];
//        }
//        [daadic setObject:aaaa forKey:[dic objectForKey:@"pid"]];
//    }
//    
//    NSString *muHomePath = [NSHomeDirectory() stringByAppendingPathComponent:@"city.plist"];
//    
//    [daadic writeToFile:muHomePath atomically:YES];
//    
//    [rs close];
//}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self stopLocationMy];

    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        MKPlacemark *placemark = placemarks[0];
        DLog(@"%@",placemark.addressDictionary);
        DLog(@"%@--%@--%@--%@",[placemark.addressDictionary objectForKey:@"State"],[placemark.addressDictionary objectForKey:@"City"],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Thoroughfare"]);
        
        NSString *provinStr =[placemark.addressDictionary objectForKey:@"State"];
        NSString *cityStr = [placemark.addressDictionary objectForKey:@"City"];
        
        _locationStr = [NSString stringWithFormat:@"%@-%@",provinStr,cityStr];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        for (NSDictionary *dic in _provinArray) {
            
            NSRange foundObj=[provinStr rangeOfString:[dic objectForKey:@"name"] options:NSCaseInsensitiveSearch];
            
            if(foundObj.length>0) {
                NSArray *citya = [_cityArrayDic objectForKey:[dic objectForKey:@"pid"]];
                for (NSDictionary *cityDic in citya) {
                    NSRange cityfoundObj=[cityStr rangeOfString:[cityDic objectForKey:@"name"] options:NSCaseInsensitiveSearch];
                    if (cityfoundObj.length>0) {
                        locWithDic = @{@"provname":[dic objectForKey:@"name"],@"cityname":[cityDic objectForKey:@"name"],@"cityid":[cityDic objectForKey:@"cid"],@"provid":[dic objectForKey:@"pid"]};
                        break;
                    }else{
                    
                    }
                }
            } else {

            }
        }

        

    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section?_provinArray.count:1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"GPS定位";
    }else{
        return @"全部";
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *indefid = @"iceeid";
    if (indexPath.section ==0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (_locationStr) {
            [cell.textLabel setText:_locationStr];
        }else{
            [cell.textLabel setText:@"定位中..."];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:indefid];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefid];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }

        NSDictionary *dic = _provinArray[indexPath.row];
        [cell.textLabel setText:[dic objectForKey:@"name"]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        NSDictionary *dic = _provinArray[indexPath.row];
        NSArray *citya = [_cityArrayDic objectForKey:[dic objectForKey:@"pid"]];
        CityLocationController *cityVC = [[CityLocationController alloc] init];
        [cityVC setCityArray:citya];
        [cityVC setMeInfoVC:self.meinfoVC];
        [cityVC setProvinDic:dic];
        [cityVC setTitle:[dic objectForKey:@"name"]];
        [self.navigationController pushViewController:cityVC animated:YES];
    }else if (indexPath.section==0){
        if (_locationStr) {            
            if ([_delegate respondsToSelector:@selector(locationProvinController:withLocationDic:)]) {
                [_delegate locationProvinController:self withLocationDic:locWithDic];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
