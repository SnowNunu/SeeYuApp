//
//  SYCollocationVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVM.h"

@implementation SYCollocationVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"速配";
    self.prefersNavigationBarHidden = YES;
    @weakify(self)
    self.requestSpeedMatchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSArray * (^mapAllMatchModel)(NSArray *) = ^(NSArray *models) {
            return models.rac_sequence.array;
        };
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_MATCH_SPEED_LIST parameters:subscript.dictionary];
        return [[[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYSpeedMatchModel class]] sy_parsedResults] map:mapAllMatchModel] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestSpeedMatchCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(NSArray *array) {
        self.speedMatchList = array;
    }];
    [self.requestSpeedMatchCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
