//
//  SYPrivacyVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPrivacyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyVM : SYVM

// 当前页数
@property (nonatomic, assign) int pageNum;

// 每页条数
@property (nonatomic, assign) int pageSize;

// 私密用户列表
@property (nonatomic, strong) NSArray *privacyUsersArray;

// 数据源
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestPrivacyCommand;

@property (nonatomic, strong) RACCommand *enterPrivacyShowViewCommand;

@end

NS_ASSUME_NONNULL_END
