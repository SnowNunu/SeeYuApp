//
//  SYPrivacyVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyVM.h"
#import "SYPrivacyShowVM.h"

@implementation SYPrivacyVM

- (void)initialize {
    @weakify(self)
    self.pageNum = 1;
    self.pageSize = 10;
    self.requestPrivacyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemotePrivacyUsersDataSignalWithPage:page.integerValue];
    }];
    RAC(self,privacyUsersArray) = self.requestPrivacyCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, privacyUsersArray) map:^id(NSArray *array) {
        @strongify(self)
        return [self dataSourceWithPrivacyUsers:array];
    }];
    [self.requestPrivacyCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterPrivacyShowViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYPrivacyShowVM *vm = [[SYPrivacyShowVM alloc] initWithServices:self.services params:params];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemotePrivacyUsersDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapPrivacyUsers)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.privacyUsersArray ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_PRIVACY_LIST parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYPrivacyModel class]] sy_parsedResults] map:mapPrivacyUsers];
}

- (NSArray *)dataSourceWithPrivacyUsers:(NSArray *)privacyUsers {
    if (SYObjectIsNil(privacyUsers) || privacyUsers.count == 0) return nil;
    NSArray *datasources = [privacyUsers.rac_sequence map:^(SYPrivacyModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

@end
