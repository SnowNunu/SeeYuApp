//
//  SYMainFrameVM.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMainFrameVM.h"
#import "SYHTTPService+Live.h"
#import "SYTestViewModel.h"

@interface SYMainFrameVM ()
/// 商品数组 <SYLiveRoom *>
@property (nonatomic, readwrite, copy) NSArray *liveRooms;
@end


@implementation SYMainFrameVM

- (void)initialize
{
    [super initialize];
    
    self.rankingVM = [[SYRankingVM alloc]initWithServices:self.services params:nil];
    
    self.nearbyVM = [[SYNearbyVM alloc]initWithServices:self.services params:nil];
    
//    @weakify(self);
    /// 直播间列表
//    RAC(self, liveRooms) = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    /// 数据源
//    RAC(self,dataSource) = [RACObserve(self, liveRooms) map:^(NSArray * liveRooms) {
//        @strongify(self)
//        return [self dataSourceWithLiveRooms:liveRooms];
//    }];
    
    /// 选中cell 跳转的命令
//    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * indexPath) {
//        @strongify(self);
//        /// 这里只是测试
//        SYLiveRoom *liveRoom = self.liveRooms[indexPath.row];
//        SYTestViewModel *viewModel = [[SYTestViewModel alloc] initWithServices:self.services params:@{SYViewModelTitleKey:liveRoom.myname}];
//        /// 执行push or present
//        [self.services pushViewModel:viewModel animated:YES];
//        return [RACSignal empty];
//    }];

}

///// 请求数据
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page{
//
//    NSArray * (^mapLiveRooms)(NSArray *) = ^(NSArray *products) {
//        if (page == 1) {
//            /// 下拉刷新
//        } else {
//            /// 上拉加载
//            products = @[(self.liveRooms ?: @[]).rac_sequence, products.rac_sequence].rac_sequence.flatten.array;
//        }
//        return products;
//    };
//    /// 请求网络数据 61856069 是我的喵播id type = 0 为热门，其他type 自行测试
//    return [[self.services.client fetchLivesWithUseridx:@"61856069" type:1 page:page lat:nil lon:nil province:nil] map:mapLiveRooms];
//}
//
//#pragma mark - 辅助方法
//- (NSArray *)dataSourceWithLiveRooms:(NSArray *)liveRooms {
//    if (SYObjectIsNil(liveRooms) || liveRooms.count == 0) return nil;
//    NSArray *viewModels = [liveRooms.rac_sequence map:^(SYLiveRoom *liveRoom) {
//        SYMainFrameItemViewModel *viewModel = [[SYMainFrameItemViewModel alloc] initWithLiveRoom:liveRoom];
//        return viewModel;
//    }].array;
//    return viewModels ?: @[] ;
//}
@end
