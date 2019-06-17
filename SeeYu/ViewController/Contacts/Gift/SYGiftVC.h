//
//  SYGiftVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYGiftVM.h"
#import "SYGiftModel.h"
#import "SYGiftListModel.h"
#import "SYGiftListCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^openRechargeViewBlock)(void);

@interface SYGiftVC : SYVC

@property (nonatomic, strong) SYGiftVM *viewModel;

@property (nonatomic, strong) openRechargeViewBlock block;

@end

NS_ASSUME_NONNULL_END
