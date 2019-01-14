//
//  SYBootRegisterVM.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYBootRegisterVM.h"
#import "SYRegisterVM.h"

@interface SYBootRegisterVM ()

@end

@implementation SYBootRegisterVM

- (void)initialize
{
    [super initialize];
    self.title = @"基本信息";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self);
    self.nextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *params = @{@"alias":[self.alias stringByReplacingOccurrencesOfString:@" " withString:@""],@"age":[self.age stringByReplacingOccurrencesOfString:@"岁" withString:@""],@"gender":self.gender};
        SYRegisterVM *viewModel = [[SYRegisterVM alloc]initWithServices:self.services params:params];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
}

@end
