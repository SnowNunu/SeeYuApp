//
//  SYHTTPService+Live.m
//  WeChat
//
//  Created by senba on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYHTTPService+Live.h"

@implementation SYHTTPService (Live)
/// 获取直播间列表
- (RACSignal *)fetchLivesWithUseridx:(NSString *)useridx type:(NSInteger)type page:(NSInteger)page lat:(NSNumber *)lat lon:(NSNumber *)lon province:(NSString *)province{
    /// 1. 配置参数
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"useridx"] = useridx;
    subscript[@"type"] = @(type);
    subscript[@"page"] = @(page);
    if (lat == nil) subscript[@"lat"] = @(22.54192103514200);
    if (lon == nil) subscript[@"lon"] = @(113.96939828211362);
    if (province == nil) subscript[@"province"] = @"广东省";
    
    /// 2. 配置参数模型 #define SY_GET_LIVE_ROOM_LIST  @"Room/GetHotLive_v2"
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_GET path:SY_GET_LIVE_ROOM_LIST parameters:subscript.dictionary];
    
    /// 3.发起请求
    return [[[SYHTTPRequest requestWithParameters:paramters]
             enqueueResultClass:[SYLiveRoom class]]
            sy_parsedResults];
    
    /** 复杂的方式
    /// 配置请求模型
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    /// 发起请求
    return [[SYHTTPService sharedInstance] enqueueRequest:request resultClass:[SYLiveRoom class]];
     */
}


@end
