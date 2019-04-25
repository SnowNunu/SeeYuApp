//
//  SYMyMomentsVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsVM.h"

@implementation SYMyMomentsVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"设置";
    self.backTitle = @"我的动态";
    self.prefersNavigationBarBottomLineHidden = YES;
}

@end
