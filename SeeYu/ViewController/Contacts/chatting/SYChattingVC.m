//
//  SYChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/14.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYChattingVC.h"
#import "SYUserInfoManager.h"

@interface SYChattingVC () <UITableViewDataSource>

@end

@implementation SYChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    // 设置头像圆形显示
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    // 设置头像大小
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(45, 45);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

// 重写返回cell高度的方法
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    // 从缓存获取用户信息，用户昵称变动一般不大
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}







@end
