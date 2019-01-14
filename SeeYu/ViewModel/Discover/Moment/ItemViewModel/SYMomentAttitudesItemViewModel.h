//
//  SYMomentAttitudesItemViewModel.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  点赞列表 视图模型

#import "SYMomentContentItemViewModel.h"
#import "SYMoments.h"
@interface SYMomentAttitudesItemViewModel : SYMomentContentItemViewModel

/// 单条说说
@property (nonatomic, readonly, strong) SYMoment *moment;

/// init
- (instancetype)initWithMoment:(SYMoment *)moment;

/// 执行更新数据的命令
@property (nonatomic, readonly, strong) RACCommand *operationCmd;
@end
