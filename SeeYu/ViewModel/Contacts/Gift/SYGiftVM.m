//
//  SYGiftVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftVM.h"
#import "SYDiamondsVM.h"

@implementation SYGiftVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if(self = [super initWithServices:services params:params]){
        self.user = self.services.client.currentUser;
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"赠送礼物";
    self.prefersNavigationBarHidden = YES;
    self.sendGiftCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *params) {
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_SEND parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    
    self.requestGiftsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSDictionary *params = @{@"userId":self.services.client.currentUserId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_LIST_QUERY parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    [self.requestGiftsListCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYGiftModel *model) {
        self.datasource = model.gifts;
    }];
    [self.requestGiftsListCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
