//
//  SYMainFrameVM.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYMainFrameVM.h"

@interface SYMainFrameVM ()

@end


@implementation SYMainFrameVM

- (void)initialize {
    @weakify(self)
    [super initialize];
    
    self.rankingVM = [[SYRankingVM alloc]initWithServices:self.services params:nil];
    
    self.nearbyVM = [[SYNearbyVM alloc]initWithServices:self.services params:nil];
    
    self.anchorsOrderVM = [[SYAnchorsOrderVM alloc] initWithServices:self.services params:nil];
    
    self.anchorsRandomVM = [[SYAnchorsRandomVM alloc] initWithServices:self.services params:nil];
    
    self.loginReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSDictionary *params = @{@"userId":self.services.client.currentUser.userId};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_LOGIN_REPORT parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYObject class]] sy_parsedResults]  takeUntil:self.rac_willDeallocSignal];
    }];
}
@end
