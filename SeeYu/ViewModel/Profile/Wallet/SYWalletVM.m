//
//  SYWalletVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWalletVM.h"

@implementation SYWalletVM
- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self)
    self.title = @"我的钱包";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestIncomeInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INCOME_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYIncomeModel class]] sy_parsedResults];
    }];
    [self.requestIncomeInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYIncomeModel *model) {
        NSDictionary *detail = model.walletDetails[0];
        self.detailModel = [SYWalletDetailModel modelWithDictionary:detail];
        self.datasource = model.statistics;
    }];
    [self.requestIncomeInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterWithdrawalViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYWithdrawalVM *vm = [[SYWithdrawalVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterWithdrawalRulesViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYWithdrawalRulesVM *vm = [[SYWithdrawalRulesVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterPaymentsViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYPaymentsVM *vm = [[SYPaymentsVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
