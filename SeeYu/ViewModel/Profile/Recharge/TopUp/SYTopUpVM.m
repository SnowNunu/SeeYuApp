//
//  SYTopUpVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYTopUpVM.h"

@implementation SYTopUpVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        self.payUrl = params[SYViewModelUtilKey];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"支付";
    self.backTitle = @"";
}

@end
