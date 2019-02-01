//
//  SYMomentVM.h
//  SeeYu
//
//  Created by trc on 2017/12/20.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYTableVM.h"
#import "SYMomentItemViewModel.h"
#import "SYMomentAttitudesItemViewModel.h"
#import "SYMomentCommentItemViewModel.h"
#import "SYMomentProfileViewModel.h"
#import "SYMomentReplyItemViewModel.h"

@interface SYMomentVM : SYTableVM
/// 个人信息头部视图模型
@property (nonatomic, readonly, strong) SYMomentProfileViewModel *profileViewModel;
/// 刷新某一个section的 事件回调
@property (nonatomic, readonly, strong) RACSubject *reloadSectionSubject;
/// 评论回调
@property (nonatomic, readonly, strong) RACSubject *commentSubject;
/// 电话号码回调
@property (nonatomic, readonly, strong) RACSubject *phoneSubject;


/// 发送评论内容
@property (nonatomic, readonly, strong) RACCommand *commentCommand;
/// 删除当前用户的评论
@property (nonatomic, readonly, strong) RACCommand *delCommentCommand;
/// 删除当前用户的发的说说
@property (nonatomic, readonly, strong) RACCommand *delMomentCommand;

/// 富文本文字上的事件处理
@property (nonatomic, readonly, strong) RACCommand *attributedTapCommand;

/// 分享view上的点击事件处理
@property (nonatomic, readonly, strong) RACCommand *shareTapCommand;
@end
