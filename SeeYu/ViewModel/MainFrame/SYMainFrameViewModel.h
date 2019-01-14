//
//  SYMainFrameViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYTableViewModel.h"
#import "SYMainFrameItemViewModel.h"

@interface SYMainFrameViewModel : SYTableViewModel

/// 商品数组 <SYLiveRoom *>
@property (nonatomic, readonly, copy) NSArray *liveRooms;

@end
