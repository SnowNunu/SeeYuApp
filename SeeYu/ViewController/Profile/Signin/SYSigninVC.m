//
//  SYSigninVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSigninVC.h"

@interface SYSigninVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *signinDaysLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *signinBtn;

@end

@implementation SYSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(0, 0, 0, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 15.f;
    _bgView = bgView;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tapNone = [UITapGestureRecognizer new];
    [[tapNone rac_gestureSignal] subscribeNext:^(id x) {
        // 防止点击触发移除界面的响应
    }];
    [bgView addGestureRecognizer:tapNone];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = SYColor(159, 105, 235);
    titleLabel.textColor = SYColor(255, 255, 255);
    titleLabel.font = SYRegularFont(18);
    titleLabel.text = @"每日签到送钻石";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    UILabel *signinDaysLabel = [UILabel new];
    signinDaysLabel.textAlignment = NSTextAlignmentCenter;
    signinDaysLabel.textColor = SYColor(0, 0, 0);
    signinDaysLabel.font = SYRegularFont(18);
    signinDaysLabel.text = @"已连续签到1天";
    _signinDaysLabel = signinDaysLabel;
    [bgView addSubview:signinDaysLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = SYColor(0, 0, 0);
    tipsLabel.font = SYRegularFont(18);
    tipsLabel.text = @"1.第一天1聊豆";
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
    
    UIButton *signinBtn = [UIButton new];
    signinBtn.backgroundColor = SYColor(159, 105, 235);
    [signinBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signinBtn setTitleColor:SYColor(255, 255, 255) forState:UIControlStateNormal];
    signinBtn.titleLabel.font = SYRegularFont(18);
    signinBtn.layer.cornerRadius = 10.f;
    signinBtn.layer.masksToBounds = YES;
    _signinBtn = signinBtn;
    [bgView addSubview:signinBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat height = (SY_SCREEN_WIDTH - 30) * 0.82;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.offset(height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.bgView);
        make.height.equalTo(self.bgView).multipliedBy(0.14);
    }];
    [_signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.bgView);
        make.height.offset(20);
    }];
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-15);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.height.equalTo(self.bgView).multipliedBy(0.14);
    }];
}

@end
