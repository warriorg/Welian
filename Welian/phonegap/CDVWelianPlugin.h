//
//  CDVWelianPlugin.h
//  CordovaTests
//
//  Created by weLian on 14/12/18.
//
//

#import <Cordova/CDVPlugin.h>

@class ActivityViewController;
@interface CDVWelianPlugin : CDVPlugin

@property (nonatomic, copy) NSString *callbackID;

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)pageOnComplete:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)getSessionId:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)getHeadHeight:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)share:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)getUserInfo:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)backToDiscover:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
- (void)wechatPay:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end
