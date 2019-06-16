//
//  SYVipVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGoodsModel.h"
#import "SYPayInfoModel.h"
#import "SYWebVM.h"
#import "SYUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVipVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestVipPriceInfoCommand;

@property (nonatomic, strong) RACCommand *requestPayInfoCommand;

@end

NS_ASSUME_NONNULL_END
