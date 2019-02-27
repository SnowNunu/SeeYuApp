//
//  SYChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/14.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYChattingVC.h"
#import "SYUserInfoManager.h"

@interface SYChattingVC ()

@end

@implementation SYChattingVC

- (void)viewDidLoad {
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    //首次进入加载数据
}

- (void)viewWillAppear:(BOOL)animated {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel {
    
}

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation {
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    NSLog(@"%@",conversation.conversationId);
    if (model.conversation.type == EMConversationTypeChat) {
        if ([conversation.conversationId isEqualToString:@"12218"]) {
            model.title = @"张无忌";
        } else {
            model.title = @"周芷若";
        }
    }
    return model;
}



@end
