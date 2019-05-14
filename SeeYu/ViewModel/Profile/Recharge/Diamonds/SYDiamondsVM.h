//
//  SYDiamondsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGoodsModel.h"
#import "SYPayInfoModel.h"
#import "SYWebVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDiamondsVM : SYVM

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestDiamondsPriceInfoCommand;

@property (nonatomic, strong) RACCommand *requestPayInfoCommand;

@end

NS_ASSUME_NONNULL_END
