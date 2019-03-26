//
//  SYForumCommentVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumCommentVM.h"
#import "SYForumResultModel.h"

@implementation SYForumCommentVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.model = [SYForumModel yy_modelWithJSON:params[SYViewModelUtilKey]];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarBottomLineHidden = YES;
    self.title = @"回复话题";
    self.backTitle = @"";
    self.pageSize = 10;
    @weakify(self)
    self.requestForumsCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        NSArray * (^mapAllForumComments)(NSArray *) = ^(NSArray *forums) {
            return forums.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"forumId":self.model.forumId,@"pageNum":page,@"pageSize":@(self.pageSize)};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYForumCommentModel class]] sy_parsedResults] map:mapAllForumComments] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [self.requestForumsCommentsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.datasource = array;
    }];
    [self.requestForumsCommentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.likeCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *commentId) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId,@"commentId":commentId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_LIKE parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYForumResultModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.postCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *commentContent) {
        @strongify(self)
        NSDictionary *params = @{@"commentUserid":self.services.client.currentUser.userId,@"commentForumid":self.model.forumId,@"commentContent":commentContent};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_FORUM_COMMENT_POST parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYForumResultModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
}

@end
