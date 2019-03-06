//
//  SYUserInfoManager.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/16.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYUserInfoManager.h"

@implementation SYUserInfoManager

+ (SYUserInfoManager *)shareInstance {
    static SYUserInfoManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

//- (EaseConversationModel *)getUserInfo:(NSString *) userId withConversation:(EMConversation *)conversation {
//    __block EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    NSDictionary *parameters = @{@"userId":userId};
//    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
//    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IMINFO parameters:subscript.dictionary];
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[[[SYHTTPRequest requestWithParameters:paramters]
//           enqueueResultClass:[SYUser class]]
//          sy_parsedResults]
//         subscribeNext:^(SYUser * user) {
//             model.title = user.userName;
//             model.avatarURLPath = user.userHeadImg;
//             model.avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.userHeadImg]]];
//         } error:^(NSError *error) {
//             /// 失败回调
//             NSLog(@"%@",error.description);
//             dispatch_group_leave(group);
//         } completed:^{
//             NSLog(@"%@",@"网络请求完成");
//             dispatch_group_leave(group);
//         }];
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        //界面刷新
//        NSLog(@"任务均完成，刷新界面");
//    });
//    return model;
//}

//- (EaseConversationModel *)getUserInfo:(NSString *) userId withConversation:(EMConversation *)conversation {
//    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
//    // 拼接参数发起网络请求
//    NSDictionary *parameters = @{@"userId":userId};
//    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
//    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_IMINFO parameters:subscript.dictionary];
//    [[[[SYHTTPRequest requestWithParameters:paramters]
//       enqueueResultClass:[SYUser class]]
//      sy_parsedResults]
//     subscribeNext:^(SYUser * user) {
//         NSLog(@"asdasd");
//         model.title = user.userName;
//         model.avatarURLPath = user.userHeadImg;
//         model.avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.userHeadImg]]];
//     } error:^(NSError *error) {
//         /// 失败回调
//         NSLog(@"%@",error.description);
//     } completed:^{
//         NSLog(@"%@",@"网络请求完成");
//     }];
    // 未等到网络请求返回就已经return
//    return model;
//}

@end
