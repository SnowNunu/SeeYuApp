//
//  SYWebViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYWebViewModel.h"

@implementation SYWebViewModel
- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.request = params[SYViewModelRequestKey];
    }
    return self;
}
@end

