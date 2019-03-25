//
//  SYForumCommentVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYForumModel.h"
#import "SYForumCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYForumCommentVM : SYVM

@property (nonatomic, assign) int pageNum;

@property (nonatomic, assign) int pageSize;

// 论坛评论数组
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) SYForumModel *model;

// 请求所有的话题列表
@property (nonatomic, strong) RACCommand *requestForumsCommentsCommand;

@property (nonatomic, strong) RACCommand *postCommentCommand;

@end

NS_ASSUME_NONNULL_END
