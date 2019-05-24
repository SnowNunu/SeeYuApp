//
//  SYWalletVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYIncomeModel.h"
#import "SYWalletDetailModel.h"
#import "SYWithdrawalVM.h"
#import "SYWithdrawalRulesVM.h"
#import "SYPaymentsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWalletVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) SYWalletDetailModel *detailModel;

@property (nonatomic, strong) RACCommand *requestIncomeInfoCommand;

@property (nonatomic, strong) RACCommand *enterWithdrawalViewCommand;

@property (nonatomic, strong) RACCommand *enterWithdrawalRulesViewCommand;

@property (nonatomic, strong) RACCommand *enterPaymentsViewCommand;

@end

NS_ASSUME_NONNULL_END
