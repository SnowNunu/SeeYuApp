//
//  SYAnchorsGatherVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsGatherVM.h"

@implementation SYAnchorsGatherVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.anchorType = params[@"anchorType"];
        self.currentIndex = [params[@"currentIndex"] integerValue];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"主播展示";
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    self.requestAllAnchorsInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSArray * (^mapAnchors)(NSArray *) = ^(NSArray *anchors) {
            return anchors.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        subscript[@"type"] = self.anchorType;
        subscript[@"pageNum"] = @(1);
        subscript[@"pageSize"] = @(188);
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_ANCHOR_LIST parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYAnchorsModel class]] sy_parsedResults] map:mapAnchors];
    }];
    [self.requestAllAnchorsInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestAllAnchorsInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.focusAnchorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        @strongify(self)
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_ANCHOR_FOCUS_EXECUTE parameters:subscript.dictionary];
        return [[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYObject class]]  takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
