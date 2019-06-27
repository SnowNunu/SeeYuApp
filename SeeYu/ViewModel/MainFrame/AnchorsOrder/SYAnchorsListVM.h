//
//  SYAnchorsListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAnchorShowVM.h"
#import "SYAnchorsGatherVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsListVM : SYVM

// 当前页数
@property (nonatomic, assign) int pageNum;

// 每页条数
@property (nonatomic, assign) int pageSize;

// 主播类型
@property (nonatomic, strong) NSString *anchorType;

// 数据源
@property (nonatomic, strong) NSArray *datasource;

// 主播列表
@property (nonatomic, strong) NSArray *anchorsArray;

// 当前页主播元素
@property (nonatomic, strong) NSArray *currentPageValues;

// 获取主播列表
@property (nonatomic, strong) RACCommand *requestAnchorsListCommand;

// 进入主播详情展示
@property (nonatomic, strong) RACCommand *enterAnchorShowViewCommand;

// 进入主播轮播显示页
@property (nonatomic, strong) RACCommand *enterAnchorGatherViewCommand;

@end

NS_ASSUME_NONNULL_END
