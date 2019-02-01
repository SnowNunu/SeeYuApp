//
//  SYAnchorVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYAnchorVM.h"

@implementation SYAnchorVM

- (void)initialize {
    @weakify(self)
    self.requestAnchorsCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        self.dataSource = @[@"123"];
        return [RACSignal empty];
//        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
}

//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page{
//    NSArray * (^mapNearbyFriends)(NSArray *) = ^(NSArray *friends) {
//        if (page == 1) {
//            /// 下拉刷新
//        } else {
//            /// 上拉加载
//            friends = @[(self.nearbyFriends ?: @[]).rac_sequence, friends.rac_sequence].rac_sequence.flatten.array;
//        }
//        return friends;
//    };
//
//    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
//    subscript[@"pageNum"] = @(page);
//    subscript[@"pageSize"] = @(_pageSize);
//    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_NEARBY parameters:subscript.dictionary];
//    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
//    return [[[self.services.client enqueueRequest:request resultClass:[SYUser class]] sy_parsedResults] map:mapNearbyFriends];
//}

@end
