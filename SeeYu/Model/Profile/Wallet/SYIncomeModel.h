//
//  SYIncomeModel.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYIncomeModel : SYObject

@property (nonatomic, strong) NSArray *walletDetails;

@property (nonatomic, strong) NSArray *statistics;

@end

NS_ASSUME_NONNULL_END
