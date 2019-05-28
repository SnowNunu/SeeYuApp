//
//  SYMyMomentsVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYMomentsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMyMomentsVM : SYVM

@property (nonatomic, assign) int pageNum;

@property (nonatomic, assign) int pageSize;

// 动态列表数组
@property (nonatomic, strong) NSArray *moments;

@property (nonatomic, strong) NSArray<SYMomentsModel *> *datasource;

@property (nonatomic, strong) RACCommand *enterMomentsEditView;

@property (nonatomic, strong) RACCommand *requestAllMineMomentsCommand;

@end

NS_ASSUME_NONNULL_END
