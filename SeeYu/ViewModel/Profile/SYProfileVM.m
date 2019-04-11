//
//  SYProfileVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYProfileVM.h"
#import "SYDiamondsVM.h"
#import "SYSettingVM.h"

@implementation SYProfileVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if (self = [super initWithServices:services params:params]) {
        self.user = [self.services.client currentUser];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"我的";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self)
    self.requestUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_INFO_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults];
    }];
    [self.requestUserInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        @strongify(self)
        self.user = user;
        [self.services.client saveUser:user];
    }];
    [self.requestUserInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterNextViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *kind) {
        if ([kind isEqual:@(0)]) {
            
        } else if ([kind isEqual:@(1)]) {
            
        } else if ([kind isEqual:@(2)]) {
            
        } else if ([kind isEqual:@(3)]) {
            SYDiamondsVM *vm = [[SYDiamondsVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        } else {
            SYSettingVM *vm = [[SYSettingVM alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:vm animated:YES];
        }
        return [RACSignal empty];
    }];
}

@end
