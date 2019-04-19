//
//  SYOutboundVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYOutboundVM.h"

@implementation SYOutboundVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.callerId = params[SYViewModelIDKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"外呼";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.prefersNavigationBarHidden = YES;
    self.requestCallerInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:@{@"userId":self.callerId}];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IMINFO parameters:subscript.dictionary];
        return [[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.requestCallerInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.callerInfo = user;
    }];
    [self.requestCallerInfoCommand.errors subscribeNext:^(NSError *error) {
//        [MBProgressHUD sy_showErrorTips:error];
        if (error != nil) {
            SYUser *user = [SYUser new];
            user.userName = @"磨人的老女人";
            user.userHeadImg = @"http://103.214.147.194/seeyu/head/12284.png";
            user.showVideo = @"http://103.214.147.194/seeyu/show/12284.mp4";
            self.callerInfo = user;
        }
    }];
}

@end
