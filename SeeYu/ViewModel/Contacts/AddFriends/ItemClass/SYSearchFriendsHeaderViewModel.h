//
//  SYSearchFriendsHeaderViewModel.h
//  WeChat
//
//  Created by senba on 2017/9/24.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUser.h"
@interface SYSearchFriendsHeaderViewModel : NSObject

/// Current login User
@property (nonatomic, readonly, strong) SYUser * user;

/// searchCmd
@property (nonatomic, readwrite, strong) RACCommand *searchCommand;

/// init
- (instancetype)initWithUser:(SYUser *)user;


@end
