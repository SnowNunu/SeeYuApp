//
//  SYPopViewVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYPopViewVM.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^openRechargeViewBlock)(void);

@interface SYPopViewVC : SYVC

@property (nonatomic, strong) SYPopViewVM *viewModel;

@property (nonatomic, strong) openRechargeViewBlock block;

@end

NS_ASSUME_NONNULL_END
