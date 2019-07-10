//
//  SYAnchorShowVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorShowVC.h"

@interface SYAnchorShowVC ()

@end

@implementation SYAnchorShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestAnchorDetailCommand execute:self.viewModel.anchorUserId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerView jp_resume];
    NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUser.userId,@"userAnchorId":self.viewModel.anchorUserId};
    [self.viewModel.requestFocusStateCommand execute:params];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView jp_pause];
}

- (void)bindViewModel {
    @weakify(self)
    [RACObserve(self.viewModel, model) subscribeNext:^(SYAnchorsModel *model) {
        @strongify(self)
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",model.userAge];
        self.aliasLabel.text = model.userName;
        [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYImageNamed(@"add_image") options:SYWebImageOptionAutomatic completion:NULL];
        [self.playerView jp_playVideoWithURL:[NSURL URLWithString:model.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        }];
    }];
    [RACObserve(self.viewModel, focus) subscribeNext:^(id x) {
        BOOL focus = [x boolValue];
        [self.focusBtn setImage:(focus ? SYImageNamed(@"home_btn_followed") : SYImageNamed(@"home_btn_follow")) forState:UIControlStateNormal];
    }];
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.playerView jp_stopPlay];
        [self.viewModel.goBackCommand execute:nil];
    }];
    [[self.focusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUser.userId,@"userAnchorId":self.viewModel.anchorUserId};
        [self.viewModel.focusAnchorCommand execute:params];
    }];
    [[self.videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYUser *user = self.viewModel.services.client.currentUser;
        BOOL controlSwitch = NO;
        YYCache *cache = [YYCache cacheWithName:@"SeeYu"];
        if ([cache containsObjectForKey:@"controlSwitch"]) {
            // 有缓存数据优先读取缓存数据
            id value = [cache objectForKey:@"controlSwitch"];
            NSString *state = (NSString *) value;
            controlSwitch = [state isEqualToString:@"0"] ? YES : NO;
        } else {
            controlSwitch = NO;
        }
        if (controlSwitch) {
            // 不判断VIP状态
            if (user.userDiamond > self.viewModel.model.anchorChatCost.intValue) {
                [self.playerView jp_pause];
                [[RCCall sharedRCCall] startSingleCall:self.viewModel.model.userId mediaType:RCCallMediaVideo];
            } else {
                [self openRechargeTipsView:@"diamonds"];
            }
        } else {
            if (user.userVipStatus == 1) {
                if (user.userVipExpiresAt != nil) {
                    if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                        // 会员已过期的情况
                        [self openRechargeTipsView:@"vip"];
                    } else {
                        // 会员未过期
                        if (user.userDiamond > self.viewModel.model.anchorChatCost.intValue) {
                            if (self.viewModel.model.userOnline == 0) {
                                // 主播忙碌状态不允许视频
                                [MBProgressHUD sy_showTips:@"用户忙碌中，请稍候再试"];
                            } else {
                                [self.playerView jp_pause];
                                [[RCCall sharedRCCall] startSingleCall:self.viewModel.model.userId mediaType:RCCallMediaVideo];
                            }
                        } else {
                            [self openRechargeTipsView:@"diamonds"];
                        }
                    }
                }
            } else {
                // 未开通会员
                [self openRechargeTipsView:@"vip"];
            }
        }
    }];
    [SYNotificationCenter addObserver:self selector:@selector(continueAnchorsShow) name:@"continueAnchorsShow" object:nil];
    [SYNotificationCenter addObserver:self selector:@selector(pasueAnchorsShow) name:@"pasueAnchorsShow" object:nil];
}

- (void)_setupSubviews {
    self.playerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.playerView];
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
    [self.view bringSubviewToFront:containerView];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:SYImageNamed(@"nav_btn_back") forState:UIControlStateNormal];
    _backBtn = backBtn;
    [self.containerView addSubview:backBtn];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [containerView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.font = SYRegularFont(20);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [containerView addSubview:aliasLabel];
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = SYRegularFont(18);
    ageLabel.textAlignment = NSTextAlignmentLeft;
    _ageLabel = ageLabel;
    [containerView addSubview:ageLabel];
    
    UIButton *focusBtn = [UIButton new];
    [focusBtn setImage:SYImageNamed(@"home_btn_follow") forState:UIControlStateNormal];
    _focusBtn = focusBtn;
    [containerView addSubview:focusBtn];
    
    UIButton *videoBtn = [UIButton new];
    [videoBtn setImage:SYImageNamed(@"home_btn_videoChat") forState:UIControlStateNormal];
    _videoBtn = videoBtn;
    [containerView addSubview:videoBtn];
}

- (void)_makeSubViewsConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(24);
        make.top.equalTo(self.containerView).offset(40);
        make.left.equalTo(self.containerView).offset(15);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.left.equalTo(self.containerView).offset(20);
        make.bottom.equalTo(self.focusBtn.mas_top).offset(-30);
    }];
    [self.aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.ageLabel);
        make.bottom.equalTo(self.ageLabel.mas_top).offset(-10);
        make.height.offset(20);
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView).offset(-5);
        make.height.offset(15);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.containerView).offset(-15);
    }];
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.width.offset(0.26 * SY_SCREEN_WIDTH);
        make.bottom.equalTo(self.containerView).offset(-15);
        make.height.offset(0.1 * SY_SCREEN_WIDTH);
    }];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5 * SY_SCREEN_WIDTH);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.height.equalTo(self.focusBtn);
    }];
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}

// 打开权限弹窗
- (void)openRechargeTipsView:(NSString *)type {
    SYPopViewVM *popVM = [[SYPopViewVM alloc] initWithServices:self.viewModel.services params:nil];
    popVM.type = type;
    SYPopViewVC *popVC = [[SYPopViewVC alloc] initWithViewModel:popVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:popVC withAnimation:animation];
}

- (void)continueAnchorsShow {
    [self.playerView jp_resume];
}

- (void)pasueAnchorsShow {
    [self.playerView jp_pause];
}

@end
