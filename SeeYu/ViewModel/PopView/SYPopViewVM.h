//
//  SYPopViewVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYRechargeVM.h"
#import "SYAuthenticationVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPopViewVM : SYVM

@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) BOOL direct;

@property (nonatomic, strong) RACCommand *enterVipRechargeViewCommand;

@property (nonatomic, strong) RACCommand *enterDiamondsRechargeViewCommand;

@property (nonatomic, strong) RACCommand *enterRealAuthViewCommand;

@end

NS_ASSUME_NONNULL_END
