//
//  SYFriendDetailInfoVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendDetailInfoVM.h"

@implementation SYFriendDetailInfoVM

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarHidden = YES;
    
    // 返回上一页
    self.goBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.services popViewModelAnimated:YES];
        return [RACSignal empty];
    }];
}

@end
