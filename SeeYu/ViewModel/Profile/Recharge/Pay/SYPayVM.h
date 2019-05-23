//
//  SYPayVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGoodsModel.h"
#import "SYWebVM.h"
#import "SYPayInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPayVM : SYVM

@property (nonatomic, strong) SYGoodsModel *model;

@property (nonatomic, strong) RACCommand *requestPayInfoCommand;

@end

NS_ASSUME_NONNULL_END
