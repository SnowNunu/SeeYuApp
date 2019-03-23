//
//  SYPrivacyShowVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyShowVM.h"

@implementation SYPrivacyShowVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params{
    if(self = [super initWithServices:services params:params]){
        self.model = [SYPrivacyModel yy_modelWithJSON:params[SYViewModelUtilKey]];
    }
    return self;
}

- (void)initialize {
    self.prefersNavigationBarHidden = YES;
    self.interactivePopDisabled = YES;
    @weakify(self)
    self.goBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
}

@end
