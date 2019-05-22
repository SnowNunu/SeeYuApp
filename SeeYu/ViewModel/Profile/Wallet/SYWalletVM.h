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

NS_ASSUME_NONNULL_BEGIN

@interface SYWalletVM : SYVM

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) SYWalletDetailModel *detailModel;

@property (nonatomic, strong) RACCommand *requestIncomeInfoCommand;

@end

NS_ASSUME_NONNULL_END
