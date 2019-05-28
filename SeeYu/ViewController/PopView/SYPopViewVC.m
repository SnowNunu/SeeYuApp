//
//  SYPopViewVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPopViewVC.h"

@interface SYPopViewVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation SYPopViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;  // 这里需要先关闭，不然会导致单聊界面错乱
}

- (void)bindViewModel {
    [super bindViewModel];
    [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
    [[_confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
        if ([self.viewModel.type isEqualToString:@"vip"]) {
            if (self.viewModel.direct) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SYSharedAppDelegate dismissVC:self];
                    if (self.block) {
                        self.block();
                    }
                });
            } else {
                [self.viewModel.enterVipRechargeViewCommand execute:nil];
            }
        } else if ([self.viewModel.type isEqualToString:@"diamonds"]){
            [self.viewModel.enterDiamondsRechargeViewCommand execute:nil];
        } else if ([self.viewModel.type isEqualToString:@"realAuth"]) {
            [self.viewModel.enterRealAuthViewCommand execute:nil];
        }
    }];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(0, 0, 0, 0.2);
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 9.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = SYImageNamed(@"alertBG");
    _bgImageView = bgImageView;
    [bgView addSubview:bgImageView];
    
    UIView *circleView = [UIView new];
    circleView.layer.cornerRadius = 35.f;
    circleView.layer.masksToBounds = YES;
    circleView.backgroundColor = [UIColor whiteColor];
    _circleView = circleView;
    [bgView addSubview:circleView];
    
    UIImageView *iconImageView = [UIImageView new];
    if ([self.viewModel.type isEqualToString:@"diamonds"]) {
        iconImageView.image = SYImageNamed(@"icon_diamond");
    } else if ([self.viewModel.type isEqualToString:@"vip"]){
        iconImageView.image = SYImageNamed(@"vip_logo");
    } else if ([self.viewModel.type isEqualToString:@"realAuth"]) {
        iconImageView.image = SYImageNamed(@"truePerson");
    }
    _iconImageView = iconImageView;
    [bgView addSubview:iconImageView];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    if ([self.viewModel.type isEqualToString:@"diamonds"]) {
        tipsLabel.text = @"您的钻石不足了，MM还在等你快去充值吧";
    } else if ([self.viewModel.type isEqualToString:@"vip"]){
        tipsLabel.text = @"开通VIP就能和美女视频聊天了~";
    } else if ([self.viewModel.type isEqualToString:@"realAuth"]) {
        tipsLabel.text = @"通过真人认证就能和美女打招呼了~";
    }
    tipsLabel.font = SYFont(12, YES);
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    if ([self.viewModel.type isEqualToString:@"diamonds"]) {
        [cancelBtn setTitle:@"我没钱" forState:UIControlStateNormal];
    } else if ([self.viewModel.type isEqualToString:@"vip"]) {
        [cancelBtn setTitle:@"继续单身" forState:UIControlStateNormal];
    } else if ([self.viewModel.type isEqualToString:@"realAuth"]) {
        [cancelBtn setTitle:@"考虑考虑" forState:UIControlStateNormal];
    }
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancelBtn = cancelBtn;
    [bgView addSubview:cancelBtn];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = [UIColor grayColor];
    _lineImageView = lineImageView;
    [cancelBtn addSubview:lineImageView];
    
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.backgroundColor = [UIColor whiteColor];
    if ([self.viewModel.type isEqualToString:@"realAuth"]) {
        [confirmBtn setTitle:@"前去认证" forState:UIControlStateNormal];
    } else {
        [confirmBtn setTitle:@"我要充值" forState:UIControlStateNormal];
    }
    [confirmBtn setTitleColor:SYColor(193, 99, 237) forState:UIControlStateNormal];
    _confirmBtn = confirmBtn;
    [bgView addSubview:confirmBtn];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.offset(200);
        make.width.offset(240);
    }];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgView);
        make.bottom.equalTo(self.cancelBtn.mas_top);
    }];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(30);
        make.width.height.offset(70);
        make.centerX.equalTo(self.bgImageView);
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.circleView);
        make.width.height.offset(40);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView);
        make.width.equalTo(self.bgImageView).offset(-60);
        make.top.equalTo(self.circleView.mas_bottom).offset(15);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bgView);
        make.height.offset(40);
        make.width.equalTo(self.bgView).multipliedBy(0.5);
    }];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(1);
        make.right.height.top.equalTo(self.cancelBtn);
    }];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(self.cancelBtn);
        make.right.equalTo(self.bgView);
    }];
}

@end
