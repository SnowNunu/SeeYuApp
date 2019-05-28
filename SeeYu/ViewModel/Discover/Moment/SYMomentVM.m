//
//  SYMomentVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentVM.h"
#import "SYMomentsModel.h"

@implementation SYMomentVM

- (void)initialize {
    self.pageNum = 1;
    self.pageSize = 10;     // 每次加载10条数据
    @weakify(self)
    self.requestMomentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemoteCommentsDataSignalWithPage:page.integerValue];
    }];
    RAC(self,moments) = self.requestMomentsCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, moments) map:^id(NSArray *momentsArray) {
        @strongify(self)
        return [self dataSourceWithMoments:momentsArray];
    }];
    [self.requestMomentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

- (RACSignal *)requestRemoteCommentsDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapMoments)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.moments ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MOMENTS_LIST parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYMomentsModel class]] sy_parsedResults] map:mapMoments];
}

- (NSArray *)dataSourceWithMoments:(NSArray *)moments {
    if (SYObjectIsNil(moments) || moments.count == 0) return nil;
    NSArray *datasources = [moments.rac_sequence map:^(SYMomentsModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

@end
