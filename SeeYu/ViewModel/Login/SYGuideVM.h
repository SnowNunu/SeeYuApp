//
//  SYGuideVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYRegisterTipsVM.h"
#import "SYPrivacyTipsVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGuideVM : SYVM

@property (nonatomic, strong) RACCommand *registerCommand;

@property (nonatomic, strong) RACCommand *loginCommand;

@property (nonatomic, strong) RACCommand *enterRegisterAgreementViewCommand;

@property (nonatomic, strong) RACCommand *enterPrivacyAgreementViewCommand;

@end

NS_ASSUME_NONNULL_END
