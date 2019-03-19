//
//  SYMainFrameVM.h
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYTableVM.h"
#import "SYVM.h"
#import "SYNearbyVM.h"
#import "SYRankingVM.h"
#import "SYMainFrameItemViewModel.h"
#import "SYAnchorsOrderVM.h"

@interface SYMainFrameVM : SYVM

@property (nonatomic, strong) SYRankingVM *rankingVM;

@property (nonatomic, strong) SYNearbyVM *nearbyVM;

@property (nonatomic, strong) SYAnchorsOrderVM *anchorsOrderVM;

@end
