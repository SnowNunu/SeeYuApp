//
//  SYSearchFriendsHeaderViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYSearchFriendsHeaderViewModel.h"

@interface SYSearchFriendsHeaderViewModel ()
/// Current login User
@property (nonatomic, readwrite, strong) SYUser * user;
@end

@implementation SYSearchFriendsHeaderViewModel
- (instancetype)initWithUser:(SYUser *)user{
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}
@end
