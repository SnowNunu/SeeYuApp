//
//  SYAlipayConfirmVM.h
//  SeeYuHelper
//
//  Created by 唐荣才 on 2019/5/5.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAlipayConfirmVM : SYVM

@property (nonatomic, strong) NSDictionary *confirmInfo;

@property (nonatomic, strong) RACCommand *withdrawalAlipayCommand;

@end

NS_ASSUME_NONNULL_END
