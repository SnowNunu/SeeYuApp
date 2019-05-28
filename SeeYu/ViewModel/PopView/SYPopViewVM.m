//
//  SYPopViewVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPopViewVM.h"

@implementation SYPopViewVM

- (void)initialize {
    [super initialize];
    self.title = @"充值提醒";
    self.enterVipRechargeViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYRechargeVM *vm = [[SYRechargeVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:@"vip"}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterDiamondsRechargeViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYRechargeVM *vm = [[SYRechargeVM alloc] initWithServices:self.services params:@{SYViewModelUtilKey:@"diamonds"}];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterRealAuthViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYAuthenticationVM *vm = [[SYAuthenticationVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
