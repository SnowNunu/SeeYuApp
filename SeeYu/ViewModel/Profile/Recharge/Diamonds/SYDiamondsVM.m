//
//  SYDiamondsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYDiamondsVM.h"

@implementation SYDiamondsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"我的钻石";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestDiamondsPriceInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSArray * (^mapAllGoods)(NSArray *) = ^(NSArray *goods) {
            return goods.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        subscript[@"goodsType"] = @"2";
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_RECHARGE_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYGoodsModel class]] sy_parsedResults] map:mapAllGoods];
    }];
    [self.requestDiamondsPriceInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestDiamondsPriceInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.requestPayInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc] initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_PAY_INFO_URL parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYPayInfoModel class]] sy_parsedResults] ;
    }];
    [self.requestPayInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYPayInfoModel *model) {
        if (model.payInfo != nil && model.payInfo.length > 0) {
            NSLog(@"%@",model.payInfo);
            SYWebVM *vm = [[SYWebVM alloc] initWithServices:self.services params:nil];
            vm.request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.payInfo]];
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
