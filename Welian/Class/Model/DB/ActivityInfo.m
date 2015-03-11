//
//  ActivityInfo.m
//  Welian
//
//  Created by weLian on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityInfo.h"
#import "LogInUser.h"
#import "IActivityInfo.h"
#import "NSString+EMAdditions.h"
#import "EMStringStylingConfiguration.h"

@implementation ActivityInfo

@dynamic activeid;
@dynamic name;
@dynamic logo;
@dynamic startime;
@dynamic endtime;
@dynamic status;
@dynamic city;
@dynamic address;
@dynamic limited;
@dynamic joined;
@dynamic isjoined;
@dynamic intro;
@dynamic isfavorite;
@dynamic shareurl;
@dynamic url;
@dynamic type;
@dynamic sponsor;
@dynamic activeType;
@dynamic rsLoginUser;

//创建活动
+ (ActivityInfo *)createActivityInfoWith:(IActivityInfo *)iActivityInfo withType:(NSNumber *)activityType
{
    ActivityInfo *activityInfo = [self getActivityInfoWithActiveId:iActivityInfo.activeid Type:activityType];
    if (!activityInfo) {
        activityInfo = [ActivityInfo MR_createEntity];
    }
    activityInfo.activeid = iActivityInfo.activeid;
    activityInfo.name = iActivityInfo.name;
    activityInfo.logo = iActivityInfo.logo;
    activityInfo.startime = iActivityInfo.startime;
    activityInfo.endtime = iActivityInfo.endtime;
    activityInfo.status = iActivityInfo.status;
    activityInfo.city = iActivityInfo.city;
    activityInfo.address = iActivityInfo.address;
    activityInfo.limited = iActivityInfo.limited;
    activityInfo.joined = iActivityInfo.joined;
    activityInfo.isjoined = iActivityInfo.isjoined;
    activityInfo.intro = iActivityInfo.intro;
    activityInfo.isfavorite = iActivityInfo.isfavorite;
    activityInfo.shareurl = iActivityInfo.shareurl;
    activityInfo.url = iActivityInfo.url;
    activityInfo.type = iActivityInfo.type;
    activityInfo.sponsor = iActivityInfo.sponsors;
    activityInfo.activeType = activityType;
    
    if (activityType != 0) {
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        [loginUser addRsActivityInfosObject:activityInfo];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return activityInfo;
}

//更新活动
+ (ActivityInfo *)updateActivityInfoWith:(IActivityInfo *)iActivityInfo withType:(NSNumber *)activityType
{
    ActivityInfo *activityInfo = [self getActivityInfoWithActiveId:iActivityInfo.activeid Type:activityType];
//    activityInfo.activeid = iActivityInfo.activeid;
//    activityInfo.name = iActivityInfo.name;
    activityInfo.logo = iActivityInfo.logo;
    activityInfo.startime = iActivityInfo.startime;
    activityInfo.endtime = iActivityInfo.endtime;
    activityInfo.status = iActivityInfo.status;
    activityInfo.city = iActivityInfo.city;
    activityInfo.address = iActivityInfo.address;
    activityInfo.limited = iActivityInfo.limited;
    activityInfo.joined = iActivityInfo.joined;
    activityInfo.isjoined = iActivityInfo.isjoined;
    activityInfo.intro = iActivityInfo.intro;
    activityInfo.isfavorite = iActivityInfo.isfavorite;
    activityInfo.shareurl = iActivityInfo.shareurl;
    activityInfo.url = iActivityInfo.url;
    activityInfo.type = iActivityInfo.type;
    activityInfo.sponsor = iActivityInfo.sponsors;
    activityInfo.activeType = activityType;
    
    if (activityType != 0) {
        LogInUser *loginUser = [LogInUser getCurrentLoginUser];
        [loginUser addRsActivityInfosObject:activityInfo];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return activityInfo;
}

//获取活动
+ (ActivityInfo *)getActivityInfoWithActiveId:(NSNumber *)activeid Type:(NSNumber *)activityType
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"activeType",activityType,@"activeid",activeid];
    ActivityInfo *activityInfo = [ActivityInfo MR_findFirstWithPredicate:pre];
    return activityInfo;
}

//删除所有指定类型的对象
+ (void)deleteAllActivityInfoWithType:(NSNumber *)type
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"activeType",type];
    NSArray *all = [ActivityInfo MR_findAllWithPredicate:pre];
    for (ActivityInfo *activityInfo in all) {
        [activityInfo MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//删除指定类型的单个对象
+ (void)deleteActivityInfoWithType:(NSNumber *)type ActiveId:(NSNumber *)activeid
{
    ActivityInfo *activityInfo = [self getActivityInfoWithActiveId:activeid Type:type];
    [activityInfo MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//获取所有的普通的项目排序后数据
+ (NSArray *)allNormalActivityInfos
{
//    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K != %@", @"activeType",@(0),@"status",@(2)];
    NSArray *nowArray = [ActivityInfo MR_findAllSortedBy:@"startime" ascending:YES withPredicate:pre];
    //0 还没开始，1进行中。2结束
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"activeType",@(0),@"status",@(2)];
    NSArray *endArray = [ActivityInfo MR_findAllSortedBy:@"startime" ascending:NO withPredicate:pre1];
    
    NSArray *all = @[nowArray,endArray];
    
    return all;
}

//获取自己的项目或者自己收藏的
+ (NSArray *)allMyActivityInfoWithType:(NSNumber *)activityType
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"activeType",activityType,@"rsLoginUser",loginUser];
    NSArray *all = [ActivityInfo MR_findAllSortedBy:@"activeid" ascending:NO withPredicate:pre];
    
    return all;
}

//更新收藏状态
- (ActivityInfo *)updateFavorite:(NSNumber *)isFavorite
{
    self.isfavorite = isFavorite;
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return self;
}

//更新报名状态
- (ActivityInfo *)updateIsjoined:(NSNumber *)isJoined
{
    self.isjoined = isJoined;
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return self;
}

//更新已报名人数
- (ActivityInfo *)updateJoined:(NSNumber *)joined
{
    self.joined = @(self.joined.integerValue + joined.integerValue);
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return self;
}

//获取活动开始是周几
- (NSString *)displayStartWeekDay
{
    NSDate *startDate = [self.startime dateFromNormalString];
    NSString *day = @"";
    switch ([startDate weekday]) {
        case 1:
            day = @"周日";
            break;
        case 2:
            day = @"周一";
            break;
        case 3:
            day = @"周二";
            break;
        case 4:
            day = @"周三";
            break;
        case 5:
            day = @"周四";
            break;
        case 6:
            day = @"周五";
            break;
        case 7:
            day = @"周六";
            break;
        default:
            break;
    }
    return day;
}

//获取活动结束是周几
- (NSString *)displayEndWeekDay
{
    NSDate *endDate = [self.endtime dateFromNormalString];
    NSString *day = @"";
    switch ([endDate weekday]) {
        case 1:
            day = @"周日";
            break;
        case 2:
            day = @"周一";
            break;
        case 3:
            day = @"周二";
            break;
        case 4:
            day = @"周三";
            break;
        case 5:
            day = @"周四";
            break;
        case 6:
            day = @"周五";
            break;
        case 7:
            day = @"周六";
            break;
        default:
            break;
    }
    return day;
}

//获取活动时间
- (NSString *)displayStartTimeInfo
{
    NSDate *startDate = [self.startime dateFromNormalString];
    NSDate *endDate = [self.endtime dateFromNormalString];
    NSString *time = @"";
    if ([endDate daysLaterThan:startDate] == 0) {
        time = [NSString stringWithFormat:@"%@ %@ %@～%@",[startDate formattedDateWithFormat:@"yyyy/MM/dd"],[self displayStartWeekDay],[startDate formattedDateWithFormat:@"HH:mm"],[endDate formattedDateWithFormat:@"HH:mm"]];
    }else{
        time = [NSString stringWithFormat:@"%@ %@ %@ ～ %@ %@ %@",[startDate formattedDateWithFormat:@"yyyy/MM/dd"],[self displayStartWeekDay],[startDate formattedDateWithFormat:@"HH:mm"],[endDate formattedDateWithFormat:@"yyyy/MM/dd"],[self displayEndWeekDay],[endDate formattedDateWithFormat:@"HH:mm"]];
    }
    return time;
}

//获取活动详情
- (NSString *)displayActivityInfo
{
    // Setup styling for demo.
    
    /**
     *  Seting up styling needs to be done ONE time only to use througout entire app. EMStringStylingConfiguration is a singleton and will help you keep your design
     *  consistent.
     */
    
    // Ideally, this should not be in a specific view controller, but a more general object like where you setup configuration for your app.
    // Setup specific font for default, strong and emphasis text
    [EMStringStylingConfiguration sharedInstance].defaultFont  = [UIFont fontWithName:@"Avenir-Light" size:14];
    [EMStringStylingConfiguration sharedInstance].strongFont   = [UIFont fontWithName:@"Avenir" size:14];
    [EMStringStylingConfiguration sharedInstance].emphasisFont = [UIFont fontWithName:@"Avenir-LightOblique" size:14];
    
    
    // Then for the demo I created a bunch of custom styling class to provide examples
    
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<code>"];
    aStylingClass.color           = [UIColor colorWithWhite:0.151 alpha:1.000];
    aStylingClass.font            = [UIFont fontWithName:@"Courier" size:14];
    aStylingClass.attributes      = @{NSBackgroundColorAttributeName : [UIColor colorWithWhite:0.901 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in RED
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<red>"];
    aStylingClass.color = [UIColor colorWithRed:0.773 green:0.000 blue:0.263 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in GREEN
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<green>"];
    aStylingClass.color = [UIColor colorWithRed:0.269 green:0.828 blue:0.392 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text with stroke
    aStylingClass            = [[EMStylingClass alloc] initWithMarkup:@"<stroke>"];
    aStylingClass.font       = [UIFont fontWithName:@"Avenir-Black" size:26];
    aStylingClass.color      = [UIColor whiteColor];
    aStylingClass.attributes = @{NSStrokeWidthAttributeName: @-6,
                                 NSStrokeColorAttributeName:[UIColor colorWithRed:0.111 green:0.568 blue:0.764 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    /**
     *  END of setup to be done only once througout entire app.
     */
    
    // Our big text stored in a string with tags for EMString styling
    NSString *text = self.intro;
//    NSString *text = @"<h4>About EMString</h4>\n<p><strong>EMString</strong> stands for <em><strong>E</strong>asy <strong>M</strong>arkup <strong>S</strong>tring</em>. I hesitated to call it SONSAString : Sick Of NSAttributedString...</p>\n<p>Most of the time if you need to display a text with different styling in it, like \"<strong>This text is bold</strong> but then <em>italic.</em>\", you would use an <code>NSAttributedString</code> and its API. Same thing if suddenly your text is <green><strong>GREEN</strong></green> and then <red><strong>RED</strong></red>...</p><p>Personnaly I don't like it! It clusters my classes with a lot of boilerplate code to find range and apply style, etc...</p>\n<p>This is what <strong>EMString</strong> is about. Use the efficient <u>HTML markup</u> system we all know and get an iOS string stylized in one line of code and behave like you would expect it to.</p>\n<h1>h1 header</h1><h2>h2 header</h2><h3>h3 header</h3><stroke>Stroke text</stroke>\n<strong>strong</strong>\n<em>emphasis</em>\n<u>underline</u>\n<s>strikethrough</s>\n<code>and pretty much whatever you think of...</code>";
    
    // Title with stroke style
//    self.topLabel.attributedText = @"<stroke>EMSString's magic</stroke>".attributedString;
    
    // Set string to textView with .attributedString to apply styling.
    return text.attributedString.length > 500 ? [text.attributedString.string substringToIndex:500] : text.attributedString.string;
}

@end
