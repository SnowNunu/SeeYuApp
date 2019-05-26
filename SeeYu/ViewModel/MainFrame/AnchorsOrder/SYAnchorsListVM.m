//
//  SYAnchorsListVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsListVM.h"
#import "SYAnchorsModel.h"

@implementation SYAnchorsListVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.anchorType = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    self.pageNum = 1;
    self.pageSize = 9;
    self.requestAnchorsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemoteAnchorsDataSignalWithPage:page.integerValue];
    }];
    RAC(self,anchorsArray) = self.requestAnchorsListCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, anchorsArray) map:^id(NSArray *array) {
        @strongify(self)
        return [self dataSourceWithAnchors:array];
    }];
    [self.requestAnchorsListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterAnchorShowViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userId) {
        SYAnchorShowVM *showVM = [[SYAnchorShowVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:userId}];
        [self.services pushViewModel:showVM animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteAnchorsDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapAnchors)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.anchorsArray ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"type"] = _anchorType;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_ANCHOR_LIST parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYAnchorsModel class]] sy_parsedResults] map:mapAnchors];
}

- (NSArray *)dataSourceWithAnchors:(NSArray *)anchors {
    if (SYObjectIsNil(anchors) || anchors.count == 0) return nil;
    NSArray *datasources = [anchors.rac_sequence map:^(SYAnchorsModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

@end
