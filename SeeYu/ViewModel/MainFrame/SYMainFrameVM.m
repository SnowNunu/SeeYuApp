//
//  SYMainFrameVM.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMainFrameVM.h"
#import "SYControlModel.h"

@interface SYMainFrameVM ()

@end


@implementation SYMainFrameVM

- (void)initialize {
    @weakify(self)
    [super initialize];
    
    self.rankingVM = [[SYRankingVM alloc]initWithServices:self.services params:nil];
    
    self.nearbyVM = [[SYNearbyVM alloc]initWithServices:self.services params:nil];
    
    self.anchorsOrderVM = [[SYAnchorsOrderVM alloc] initWithServices:self.services params:nil];
    
    self.anchorsRandomVM = [[SYAnchorsRandomVM alloc] initWithServices:self.services params:nil];
    
    self.loginReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_LOGIN_REPORT parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.loginReportCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        [self.services.client saveUser:user];
    }];
    self.requestGiftPackageInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllGiftPackages)(NSArray *) = ^(NSArray *giftPackages) {
            return giftPackages.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_GIFT_PACKAGE_INFO parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftPackageModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal] map:mapAllGiftPackages];
    }];
    [self.requestGiftPackageInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestGiftPackageInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.requestPermissionsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_CONTROL_INFO parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYControlModel class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestPermissionsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYControlModel *model) {
        YYCache *cache = [YYCache cacheWithName:@"SeeYu"];
        [cache setObject:model.anchorChargingType forKey:@"controlSwitch"];
    }];
    [self.requestPermissionsCommand.errors subscribeNext:^(NSError *error) {
        NSLog(@"%@",error.description);
        YYCache *cache = [YYCache cacheWithName:@"SeeYu"];
        [cache setObject:@"1" forKey:@"controlSwitch"];
    }];
    self.uploadLocationInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_UPDATE parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.uploadLocationInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [self.uploadLocationInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}
@end


