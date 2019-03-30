//
//  SYSingleChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSingleChattingVC.h"

@interface SYSingleChattingVC ()

@end

@implementation SYSingleChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(45, 45);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:PLUGIN_BOARD_ITEM_LOCATION_TAG];
}

@end
