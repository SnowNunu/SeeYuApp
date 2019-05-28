//
//  SYMyMomentsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsVM.h"
#import "SYMomentsEditVM.h"

@implementation SYMyMomentsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    @weakify(self)
    self.title = @"我的动态";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.pageNum = 1;
    self.pageSize = 10;     // 每次加载10条数据
    
    self.requestAllMineMomentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *page) {
        @strongify(self)
        return [self requestRemoteMyCommentsDataSignalWithPage:page.integerValue];
    }];
    RAC(self,moments) = self.requestAllMineMomentsCommand.executionSignals.switchToLatest;
    RAC(self,datasource) = [RACObserve(self, moments) map:^id(NSArray *momentsArray) {
        @strongify(self)
        return [self dataSourceWithMoments:momentsArray];
    }];
    [self.requestAllMineMomentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
    self.enterMomentsEditView = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SYMomentsEditVM *vm) {
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

- (RACSignal *)requestRemoteMyCommentsDataSignalWithPage:(NSUInteger)page {
    NSArray * (^mapMoments)(NSArray *) = ^(NSArray *array) {
        if (page == 1) {
            /// 下拉刷新
        } else {
            /// 上拉加载
            array = @[(self.moments ?: @[]).rac_sequence, array.rac_sequence].rac_sequence.flatten.array;
        }
        return array;
    };
    SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
    subscript[@"userId"] = self.services.client.currentUser.userId;
    subscript[@"pageNum"] = @(page);
    subscript[@"pageSize"] = @(_pageSize);
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MINE_MOMENTS_QUERY parameters:subscript.dictionary];
    SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
    return [[[self.services.client enqueueRequest:request resultClass:[SYMomentsModel class]] sy_parsedResults] map:mapMoments];
}

- (NSArray *)dataSourceWithMoments:(NSArray *)moments {
    if (SYObjectIsNil(moments) || moments.count == 0) return nil;
    NSArray *datasources = [moments.rac_sequence map:^(SYMomentsModel *model) {
        return model;
    }].array;
    return datasources ?: @[] ;
}

//// 进行排序
//- (void)classifyMomentsData:(NSArray *)array {
//    // 从服务器获取到的数据已经按时间进行过一次排序
//    NSString *currentYear = [[NSDate sy_currentTimestamp] substringToIndex:4];
//    if (array.count == 0) {
//        self.modelDictionary = [NSMutableDictionary new];
//        [self.modelDictionary setObject:@[] forKey:currentYear];
//        self.yearArray = @[currentYear];
//    } else {
//        NSMutableArray *tempYearArray = [NSMutableArray new];   // 所有的年份数组
//        [tempYearArray addObject:currentYear];
//        for (SYMomentsModel *model in array) {
//            if (![tempYearArray containsObject:[model.momentTime substringToIndex:4]]) {
//                [tempYearArray addObject:[model.momentTime substringToIndex:4]];
//            }
//        }
//        // 接着按获取所有的月日数组
//        self.modelDictionary = [NSMutableDictionary new];
//        self.modelDictionary = [NSMutableDictionary new];
//        for (int i = 0 ; i < tempYearArray.count; i++) {
//            NSMutableArray *modelArray = [NSMutableArray new];
//            for (SYMomentsModel *model in array) {
//                if ([tempYearArray[i] isEqualToString:[model.momentTime substringToIndex:4]]) {
//                    [modelArray addObject:model];
//                }
//            }
//            [self.modelDictionary setObject:modelArray forKey:tempYearArray[i]];
//        }
//        self.yearArray = [NSArray arrayWithArray:tempYearArray]; // 获取到所有的年份数组
//    }
//}

@end
