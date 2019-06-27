//
//  SYCollocationVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVM.h"

@implementation SYCollocationVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"速配";
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    self.requestSpeedMatchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"pageNum":page,@"pageSize":@"10"};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MATCH_SPEED_LIST parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSpeedMatchModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestSpeedMatchCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.speedMatchList = array;
    }];
    [self.requestSpeedMatchCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.matchLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *friendId) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"matchUserId":friendId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_SPEED_MATCH parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSpeedMatchModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.matchLikeCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        [MBProgressHUD sy_showTips:@"发送速配请求成功"];
    }];
    [self.matchLikeCommand.errors subscribeNext:^(NSError *error) {
        if ([error code] == 82) {
            [MBProgressHUD sy_showError:@"非会员不能添加好友"];
        } else {
            [MBProgressHUD sy_showErrorTips:error];
        }
    }];
    self.matchUnlikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *friendId) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"matchUserId":friendId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_SPEED_UNMATCH parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSpeedMatchModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.matchUnlikeCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        NSLog(@"不喜欢请求成功");
    }];
    [self.matchUnlikeCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
