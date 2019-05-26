//
//  SYAnchorShowVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAnchorFocusStateModel.h"
#import "SYAnchorsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorShowVM : SYVM

/* 主播id */
@property (nonatomic, strong) NSString *anchorUserId;

/* 主播个人详情Model */
@property (nonatomic, strong) SYAnchorsModel *model;

/* 返回 */
@property (nonatomic, strong) RACCommand *goBackCommand;

/* 请求主播个人详情 */
@property (nonatomic, strong) RACCommand *requestAnchorDetailCommand;

/* 请求当前主播关注状态 */
@property (nonatomic, strong) RACCommand *requestFocusStateCommand;

/* 关注或取消关注当前主播 */
@property (nonatomic, strong) RACCommand *focusAnchorCommand;

/* 当前主播的关注状态 */
@property (nonatomic, assign) BOOL focus;

@end

NS_ASSUME_NONNULL_END
