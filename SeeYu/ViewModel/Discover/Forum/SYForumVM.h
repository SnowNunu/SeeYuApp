//
//  SYForumVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumVM : SYVM

@property (nonatomic, assign) int pageNum;

@property (nonatomic, assign) int pageSize;

// 论坛列表数组
@property (nonatomic, strong) NSArray *datasource;

// 请求所有的话题列表
@property (nonatomic, strong) RACCommand *requestForumsCommand;

// 进入单个话题评论详情页面
@property (nonatomic, strong) RACCommand *enterForumsDetailViewCommand;

@end

NS_ASSUME_NONNULL_END
