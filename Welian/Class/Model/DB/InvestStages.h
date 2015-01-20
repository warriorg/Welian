//
//  InvestStages.h
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogInUser ,IInvestStageModel;

@interface InvestStages : NSManagedObject

@property (nonatomic, retain) NSNumber * stage;
@property (nonatomic, retain) NSString * stagename;
@property (nonatomic, retain) LogInUser *rsLogInUser;

//创建新收据
+ (InvestStages *)createInvestStages:(IInvestStageModel *)investItemM;

//// //通过item查询
//+ (InvestStages *)getInvestStagesWithStage:(NSString *)item;

@end
