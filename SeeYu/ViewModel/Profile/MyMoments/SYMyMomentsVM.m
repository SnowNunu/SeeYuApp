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
    self.title = @"我的动态";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.enterMomentsEditView = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYMomentsEditVM *vm = [[SYMomentsEditVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
