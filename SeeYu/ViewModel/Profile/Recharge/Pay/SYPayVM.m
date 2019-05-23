//
//  SYPayVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPayVM.h"

@implementation SYPayVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        SYGoodsModel *model = params[SYViewModelUtilKey];
        self.model = model;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"选择支付通道";
    self.backTitle = @"";
    self.prefersNavigationBarHidden = YES;
    self.requestPayInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_PAY_INFO_URL parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYPayInfoModel class]] sy_parsedResults] ;
    }];
    [self.requestPayInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYPayInfoModel *model) {
        if (model.payInfo != nil && model.payInfo.length > 0) {
            SYWebVM *vm = [[SYWebVM alloc] initWithServices:self.services params:nil];
            vm.requestUrl = [NSURL URLWithString:model.payInfo];
            [self.services pushViewModel:vm animated:YES];
        } else {
            [MBProgressHUD sy_showError:@"发起支付请求失败"];
        }
    }];
    [self.requestPayInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
