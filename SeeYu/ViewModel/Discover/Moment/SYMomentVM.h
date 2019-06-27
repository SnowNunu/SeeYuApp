//
//  SYMomentVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMomentVM : SYVM

@property (nonatomic, assign) int pageNum;

@property (nonatomic, assign) int pageSize;

// 数据源数组
@property (nonatomic, strong) NSArray *datasource;

// 动态列表数组
@property (nonatomic, strong) NSArray *moments;

// 当前页数据源元素
@property (nonatomic, strong) NSArray *currentPageValues;

@property (nonatomic, strong) RACCommand *requestMomentsCommand;

@end

NS_ASSUME_NONNULL_END
