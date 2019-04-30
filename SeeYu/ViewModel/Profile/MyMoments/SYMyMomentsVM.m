//
//  SYMyMomentsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsVM.h"
#import "SYMomentsEditVM.h"
#import "SYMomentsModel.h"

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
    self.enterMomentsEditView = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYMomentsEditVM *vm = [[SYMomentsEditVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.requestAllMineMomentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllMoments)(NSArray *) = ^(NSArray *moments) {
            return moments.rac_sequence.array;
        };
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        subscript[@"userId"] = self.services.client.currentUser.userId;
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MINE_MOMENTS_QUERY parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[[self.services.client enqueueRequest:request resultClass:[SYMomentsModel class]] sy_parsedResults] map:mapAllMoments];
    }];
    [self.requestAllMineMomentsCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        [self classifyMomentsData:array];
    }];
    [self.requestAllMineMomentsCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

//
- (void)classifyMomentsData:(NSArray *)array {
    // 从服务器获取到的数据已经按时间进行过一次排序
    NSString *currentYear = [[NSDate sy_currentTimestamp] substringToIndex:4];
    NSArray *yearArray;
    if (array.count == 0) {
        yearArray = @[currentYear];
    } else {
        NSMutableArray *tempYearArray = [NSMutableArray new];   // 所有的年份数组
        [tempYearArray addObject:currentYear];
        for (SYMomentsModel *model in array) {
            if (![tempYearArray containsObject:[model.momentTime substringToIndex:4]]) {
                [tempYearArray addObject:[model.momentTime substringToIndex:4]];
            }
        }
        yearArray = [NSArray arrayWithArray:tempYearArray]; // 获取到所有的年份数组
        // 接着按获取所有的月日数组
        tempYearArray = [NSMutableArray new];
        for (NSString *year in yearArray) {
            NSMutableArray *tempMonthArray = [NSMutableArray new];   // 所有的年份数组
            for (SYMomentsModel *model in array) {
                if ([year isEqualToString:[model.momentTime substringToIndex:4]] && ![tempMonthArray containsObject:[model.momentTime substringWithRange:NSMakeRange(5, 5)]]) {
                    [tempMonthArray addObject:[model.momentTime substringWithRange:NSMakeRange(5, 5)]];
                }
            }
            [tempYearArray addObject:tempMonthArray];
        }
//        NSLog(@"去重后的年份数组为：%@",tempYearArray);
        for (int i = 0 ; i < yearArray.count; i++) {
            NSArray *tempArray = tempYearArray[i];
            for (int j = 0; j < tempArray.count; j++) {
                for (SYMomentsModel *model in array) {
                    if ([yearArray[i] isEqualToString:[model.momentTime substringToIndex:4]] && [tempArray[j] isEqualToString:[model.momentTime substringWithRange:NSMakeRange(5, 5)]]) {
                        NSLog(@"%@:年%@:%@",yearArray[i],tempArray[j],model.momentId);
                    }
                }
            }
        }
    }
}

@end
