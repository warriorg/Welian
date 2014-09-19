//
//  MyLocationController.m
//  Welian
//
//  Created by dong on 14-9-18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MyLocationController.h"
#import "BMKPoiSearch.h"
//#import <CoreLocation/CoreLocation.h>

@interface MyLocationController ()<BMKPoiSearchDelegate>

{
    BMKPoiSearch *_searcher;
}

@end

@implementation MyLocationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 20;

    option.location =  CLLocationCoordinate2DMake([[UserDefaults objectForKey:@"lat"] floatValue], [[UserDefaults objectForKey:@"lon"] floatValue]);
    
    
    option.keyword = @"西湖";
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        for (BMKPoiInfo *info in poiResultList.poiInfoList) {
            NSLog(@"-~~~~~----%@------%@",info.address,info.uid);
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
