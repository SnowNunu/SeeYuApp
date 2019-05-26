//
//  SYRankListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYRankListModel.h"
#import "SYAnchorShowVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRankListVM : SYVM

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSString *listType;

@property (nonatomic, strong) RACCommand *requestRankListCommand;

@property (nonatomic, strong) RACCommand *enterFriendDetailInfoCommand;

// 进入主播详情展示
@property (nonatomic, strong) RACCommand *enterAnchorShowViewCommand;

@end

NS_ASSUME_NONNULL_END
