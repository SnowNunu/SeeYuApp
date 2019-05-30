//
//  SYAnchorsGatherVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAnchorsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsGatherVM : SYVM

// 当前页数
@property (nonatomic, assign) int pageNum;

// 每页条数
@property (nonatomic, assign) int pageSize;

// 当前主播下标
@property (nonatomic, assign) NSInteger currentIndex;

// 主播类型(推荐、三星等)
@property (nonatomic, strong) NSString *anchorType;

// 数据源
@property (nonatomic, strong) NSArray *datasource;

// 主播列表
@property (nonatomic, strong) NSArray *anchorsArray;

// 请求所有主播数据
@property (nonatomic, strong) RACCommand *requestAllAnchorsInfoCommand;

/* 关注或取消关注当前主播 */
@property (nonatomic, strong) RACCommand *focusAnchorCommand;

@end

NS_ASSUME_NONNULL_END
