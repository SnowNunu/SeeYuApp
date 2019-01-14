//
//  SYAddFriendsViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  添加好友

#import "SYCommonViewModel.h"
#import "SYSearchFriendsHeaderViewModel.h"
@interface SYAddFriendsViewModel : SYCommonViewModel
/// headerViewModel
@property (nonatomic, readonly, strong) SYSearchFriendsHeaderViewModel *headerViewModel;


@end
