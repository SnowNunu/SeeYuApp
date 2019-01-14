//
//  SYMomentCommentItemViewModel.h
//  SYDevelopExample
//
//  Created by senba on 2017/7/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMomentContentItemViewModel.h"
#import "SYMoments.h"

@interface SYMomentCommentItemViewModel : SYMomentContentItemViewModel

/// ==== Model Properties ====
/// 评论模型
@property (nonatomic, readonly, strong) SYComment *comment;

/// init
- (instancetype)initWithComment:(SYComment *)comment;
@end
