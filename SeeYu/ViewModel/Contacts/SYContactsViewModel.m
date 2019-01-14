//
//  SYContactsViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYContactsViewModel.h"
#import "SYAddFriendsViewModel.h"
@interface SYContactsViewModel ()
/// addFriendsCommand
@property (nonatomic, readwrite, strong) RACCommand *addFriendsCommand;
@end


@implementation SYContactsViewModel
- (void)initialize
{
    [super initialize];
    
    self.title = @"通讯录";
    
    @weakify(self);
    self.addFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SYAddFriendsViewModel *viewModel = [[SYAddFriendsViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
}
@end
