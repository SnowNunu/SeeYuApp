//
//  SYSettingVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSettingVM.h"

@implementation SYSettingVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"设置";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.enterDisclaimerViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYDisclaimerVM *vm = [[SYDisclaimerVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
    self.enterAboutViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYAboutVM *vm = [[SYAboutVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
