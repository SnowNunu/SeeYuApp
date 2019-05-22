//
//  SYWalletDetailModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWalletDetailModel : SYObject

@property (nonatomic, assign) int balance;

@property (nonatomic, assign) int lockBalance;

@property (nonatomic, assign) int availableWithdrawBalance;

@end

NS_ASSUME_NONNULL_END
