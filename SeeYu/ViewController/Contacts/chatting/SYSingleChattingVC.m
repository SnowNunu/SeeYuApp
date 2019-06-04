//
//  SYSingleChattingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSingleChattingVC.h"
#import "SYGiftVC.h"
#import "SYGiftVM.h"
#import "SYGiftModel.h"
#import "SYNavigationController.h"

@interface SYSingleChattingVC ()

@property (nonatomic, strong) UIButton *sendPresentBtn;

@property (nonatomic, assign) BOOL btnEnabled;

@property (nonatomic, strong) RCMessageModel *messageModel;

@end

@implementation SYSingleChattingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(45, 45);
    self.conversationMessageCollectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem sy_customItemWithTitle:nil titleColor:[UIColor whiteColor] imageName:@"nav_btn_back" target:self selector:@selector(goBack) contentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self initSendPresentBtn];
    [self _setupAction];
    self.btnEnabled = NO;
    [self requestGiftList];
    if (@available(iOS 11.0, *)) {
        self.conversationMessageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
//    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    if ([self.title isEqualToString:@"系统消息"]) {
        self.conversationMessageCollectionView.frame = CGRectMake(0, SY_APPLICATION_TOP_BAR_HEIGHT, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT);
        self.chatSessionInputBarControl.hidden = YES;
        self.chatSessionInputBarControl.backgroundColor = [UIColor clearColor];
        [super scrollToBottomAnimated:YES];
    }
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = cell.model;
    NSString *myUserId = SYSharedAppDelegate.services.client.currentUserId;
    if (![model.userInfo.userId isEqualToString:myUserId]) {
        // 对方发送的消息
        if ([cell isKindOfClass:[RCTextMessageCell class]] || [cell isKindOfClass:[RCCallDetailMessageCell class]]) {
            RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
            textCell.textLabel.textColor = SYColor(193, 99, 237);
        }
    } else {
        // 自己发送的消息
        if ([cell isKindOfClass:[RCTextMessageCell class]] || [cell isKindOfClass:[RCCallDetailMessageCell class]]) {
            RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
            textCell.textLabel.textColor = SYColor(255, 255, 255);
        }
    }
    cell.messageTimeLabel.textColor = SYColor(193, 99, 237);
    cell.messageTimeLabel.backgroundColor = [UIColor clearColor];
}

- (void)_setupAction {
    @weakify(self)
    [[_sendPresentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.btnEnabled) {
            SYGiftVM *giftVM = [[SYGiftVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
            giftVM.friendId = self.targetId;
            SYGiftVC *giftVC = [[SYGiftVC alloc] initWithViewModel:giftVM];
            giftVC.block = ^{
                SYRechargeVM *vm = [[SYRechargeVM alloc] initWithServices:SYSharedAppDelegate.services params:@{SYViewModelUtilKey:@"diamonds"}];
                SYRechargeVC *vc = [[SYRechargeVC alloc]initWithViewModel:vm];
                [self.navigationController pushViewController:vc animated:YES];
            };
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.3];
            animation.type = kCATransitionFade;
            animation.subtype = kCATransitionMoveIn;
            [SYSharedAppDelegate presentVC:giftVC withAnimation:animation];
        }
    }];
}

- (void)initSendPresentBtn {
    UIButton *sendPresentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SY_SCREEN_WIDTH - 71, 400, 60, 60)];
    [sendPresentBtn setImage:SYImageNamed(@"message_icon_sendGift") forState:UIControlStateNormal];
    sendPresentBtn.tag = 0;                                                                 
    sendPresentBtn.layer.cornerRadius = 8;
    [self.view addSubview:sendPresentBtn];
    [self.view bringSubviewToFront:sendPresentBtn];
    _sendPresentBtn = sendPresentBtn;
    //添加手势
    UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [sendPresentBtn addGestureRecognizer:panRcognize];
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    //移动状态
    UIGestureRecognizerState recState = recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:self.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded: {
             CGPoint stopPoint = CGPointMake(0, SY_SCREEN_HEIGHT / 2.0);
            if (recognizer.view.center.x < SY_SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SY_SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, _sendPresentBtn.size.width/2.0);
                    } else {
                        stopPoint = CGPointMake(_sendPresentBtn.size.width/2.0, recognizer.view.center.y);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _sendPresentBtn.size.width/2.0);
                    } else {
                        stopPoint = CGPointMake(_sendPresentBtn.size.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            } else {
                if (recognizer.view.center.y <= SY_SCREEN_HEIGHT/2.0) {
                    //右上
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, _sendPresentBtn.size.width/2.0);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.size.width/2.0, recognizer.view.center.y);
                    }
                } else {
                    //右下
                    if (SY_SCREEN_WIDTH - recognizer.view.center.x  >= SY_SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SY_SCREEN_HEIGHT - _sendPresentBtn.size.width/2.0);
                    } else {
                        stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.size.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            //如果按钮超出屏幕边缘
            if (stopPoint.y + _sendPresentBtn.size.width+40>= SY_SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SY_SCREEN_HEIGHT - _sendPresentBtn.size.width/2.0-49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - _sendPresentBtn.size.width/2.0 <= 0) {
                stopPoint = CGPointMake(_sendPresentBtn.size.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + _sendPresentBtn.size.width/2.0 >= SY_SCREEN_WIDTH) {
                stopPoint = CGPointMake(SY_SCREEN_WIDTH - _sendPresentBtn.size.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - _sendPresentBtn.size.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, _sendPresentBtn.size.width/2.0);
            }
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)requestGiftList {
    NSDictionary *params = @{@"userId":SYSharedAppDelegate.services.client.currentUser.userId};
    SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:params];
    SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_GIFT_LIST_QUERY parameters:subscript.dictionary];
    [[[[SYSharedAppDelegate.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYGiftModel class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(SYGiftModel *giftModel) {
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        [cache setObject:giftModel forKey:@"giftModel"];
    } error:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    } completed:^{
        self.btnEnabled = YES;
    }];
}

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    SYUser *user = SYSharedAppDelegate.services.client.currentUser;
    if (user.userVipStatus == 1) {
        if (user.userVipExpiresAt != nil) {
            if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                // 已过期
                [self openRechargeTipsView:@"vip"];
                return nil;
            } else {
                // 未过期
                return messageContent;
            }
        } else {
            [self openRechargeTipsView:@"vip"];
            return nil;
        }
    } else {
        // 未开通会员
        [self openRechargeTipsView:@"vip"];
        return nil;
    }
}

// 点击cell头像的回调
- (void)didTapCellPortrait:(NSString *)userId {
    SYFriendDetailInfoVM *vm = [[SYFriendDetailInfoVM alloc] initWithServices:SYSharedAppDelegate.services params:@{SYViewModelIDKey:userId}];
    SYFriendDetailInfoVC *vc = [[SYFriendDetailInfoVC alloc] initWithViewModel:vm];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notifyUpdateUnreadMessageCount {
    
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
}

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model {
    if ([model.senderUserId isEqualToString:SYSharedAppDelegate.services.client.currentUserId]) {
        // 自己发送的消息才能撤回
        NSMutableArray *array = [NSMutableArray arrayWithArray:[super getLongTouchMessageCellMenuList:model]];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMyMessage)];
        self.messageModel = model;
        [array addObject:item];
        return [NSArray arrayWithArray:array];
    } else {
        return [super getLongTouchMessageCellMenuList:model];
    }
}

- (void)recallMyMessage{
    [super recallMessage:self.messageModel.messageId];
}

// 打开权限弹窗
- (void)openRechargeTipsView:(NSString *)type {
    SYPopViewVM *popVM = [[SYPopViewVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
    popVM.type = type;
    popVM.direct = YES;
    SYPopViewVC *popVC = [[SYPopViewVC alloc] initWithViewModel:popVM];
    popVC.block = ^{
        SYRechargeVM *vm = [[SYRechargeVM alloc] initWithServices:SYSharedAppDelegate.services params:@{SYViewModelUtilKey:@"vip"}];
        SYRechargeVC *vc = [[SYRechargeVC alloc]initWithViewModel:vm];
        [self.navigationController pushViewController:vc animated:YES];
    };
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:popVC withAnimation:animation];
}

@end
