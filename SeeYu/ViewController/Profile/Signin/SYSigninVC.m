//
//  SYSigninVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSigninVC.h"
#import "SYSigninInfoModel.h"
#import "SYSigninModel.h"

@interface SYSigninVC ()

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *signinDaysLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *signinBtn;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UILabel *tipsTitleLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation SYSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    _dayArray = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天",];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestSigninInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, infoModel) subscribeNext:^(SYSigninInfoModel *infoModel) {
        @strongify(self)
        if (infoModel != nil) {
            NSLog(@"%@",[NSDate new]);
            if (infoModel.recentTime != nil && [infoModel.recentTime sy_isToday]) {
                // 今天已经签到过了
                self.signinBtn.userInteractionEnabled = NO;
                self.signinBtn.backgroundColor = [UIColor grayColor];
            } else {
                self.signinBtn.userInteractionEnabled = YES;
            }
            self.signinDaysLabel.text = [NSString stringWithFormat:@"您已连续签到%d天",infoModel.count];
            for (int i = 0; i < infoModel.awards.count; i++) {
                NSDictionary *dict = infoModel.awards[i];
                SYSigninModel *model = [SYSigninModel yy_modelWithDictionary:dict];
                UIView *cellBgView = [self.view viewWithTag:188 + i];
                UIImageView *iconImageView = [self.view viewWithTag:288 + i];
                UILabel *dayLabel = [self.view viewWithTag:388 + i];
                UILabel *numberLabel = [self.view viewWithTag:488 + i];
                UIImageView *signinStateImageView = [self.view viewWithTag:588 + i];
                if ([model.signType isEqualToString:@"4"]) {
                    iconImageView.image = SYImageNamed(@"diamond");     // 钻石
                    numberLabel.text = [NSString stringWithFormat:@"%@钻石",model.signNum];
                    numberLabel.textAlignment = NSTextAlignmentLeft;
                    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cellBgView).offset(5);
                        make.width.height.offset(12);
                        make.centerY.equalTo(numberLabel);
                    }];
                    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(iconImageView.mas_right).offset(3);
                        make.top.equalTo(dayLabel.mas_bottom);
                        make.bottom.equalTo(cellBgView);
                    }];
                } else if ([model.signType isEqualToString:@"5"]) {
                    iconImageView.image = SYImageNamed(@"VIP");         // VIP
                    numberLabel.text = [NSString stringWithFormat:@"%@天会员",model.signNum];
                    numberLabel.textAlignment = NSTextAlignmentCenter;
                    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(cellBgView);
                        make.width.offset(25);
                        make.height.offset(25);
                        make.bottom.equalTo(numberLabel.mas_top).offset(2.5);
                    }];
                    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(cellBgView);
                        make.height.offset(8);
                        make.bottom.equalTo(cellBgView).offset(-5);
                    }];
                } else if ([model.signType isEqualToString:@"6"]) {
                    iconImageView.image = SYImageNamed(@"money");       // 现金
                    numberLabel.text = [NSString stringWithFormat:@"%@元",model.signNum];
                    numberLabel.textAlignment = NSTextAlignmentCenter;
                    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(cellBgView);
                        make.width.height.offset(18);
                        make.bottom.equalTo(numberLabel.mas_top).offset(-2);
                    }];
                    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(cellBgView);
                        make.height.offset(8);
                        make.bottom.equalTo(cellBgView).offset(-5);
                    }];
                }
                if (i < infoModel.count) {
                    signinStateImageView.hidden = NO;
                } else {
                    signinStateImageView.hidden = YES;
                }
            }
        }
    }];
    [[self.signinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.userSigninCommand execute:nil];
    }];
    [self.viewModel.userSigninCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYSigninInfoModel *model) {
        SYSigninInfoModel *tempModel = self.viewModel.infoModel;
        tempModel.count = model.day;
        tempModel.recentTime = [NSDate new];
        self.viewModel.infoModel = tempModel;
        [MBProgressHUD sy_showTips:model.award addedToView:self.view];
    }];
    [self.viewModel.userSigninCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error addedToView:self.view];
    }];
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
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
    bgView.layer.cornerRadius = 9.f;
    bgView.layer.borderWidth = 2.f;
    bgView.layer.borderColor = SYColorFromHexString(@"#AD7EB0").CGColor;
    _bgView = bgView;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tapNone = [UITapGestureRecognizer new];
    [[tapNone rac_gestureSignal] subscribeNext:^(id x) {
        // 防止点击触发移除界面的响应
    }];
    [bgView addGestureRecognizer:tapNone];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = SYColor(255, 255, 255);
    titleLabel.backgroundColor = SYColorFromHexString(@"#DE93E3");
    titleLabel.font = SYFont(18, YES);
    titleLabel.text = @"日常签到礼包";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    UILabel *signinDaysLabel = [UILabel new];
    signinDaysLabel.textAlignment = NSTextAlignmentCenter;
    signinDaysLabel.textColor = SYColor(75, 75, 75);
    signinDaysLabel.font = SYFont(15, YES);
    signinDaysLabel.text = @"您已连续签到 天";
    _signinDaysLabel = signinDaysLabel;
    [bgView addSubview:signinDaysLabel];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setBackgroundImage:SYImageNamed(@"closeBtn") forState:UIControlStateNormal];
    _closeBtn = closeBtn;
    [bgView addSubview:closeBtn];
    
    CGFloat width = (SY_SCREEN_WIDTH - 60);
    CGFloat cellWidth = width * 0.2;
    CGFloat cellHeight = width * 0.2 * 0.814;
    CGFloat margin = width * 0.2 / 5;
    CGFloat margin1 = (width - width * 0.6 - margin * 2) / 2;
    for (int i = 0 ; i < 7; i++) {
        UIView *cellBgView = [UIView new];
        cellBgView.layer.cornerRadius = 5.f;
        cellBgView.layer.borderColor = SYColorFromHexString(@"#EAB1D5").CGColor;
        cellBgView.layer.borderWidth = 1.5f;
        cellBgView.layer.masksToBounds = YES;
        cellBgView.tag = 188 + i;
        [bgView addSubview:cellBgView];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.tag = 288 + i;
        [cellBgView addSubview:iconImageView];
        
        UILabel *dayLabel = [UILabel new];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = SYColor(255, 255, 255);
        dayLabel.backgroundColor = SYColorFromHexString(@"#E081A5");
        dayLabel.font = SYFont(10, YES);
        dayLabel.text = _dayArray[i];
        dayLabel.tag = 388 + i;
        [cellBgView addSubview:dayLabel];
        
        UILabel *numberLabel = [UILabel new];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = SYColor(75, 75, 75);
        numberLabel.font = SYFont(9, YES);
        numberLabel.tag = 488 + i;
        [cellBgView addSubview:numberLabel];
        
        UIImageView *signinStateImageView = [UIImageView new];
        signinStateImageView.image = SYImageNamed(@"checked");
        signinStateImageView.tag = 588 + i;
        signinStateImageView.hidden = YES;
        [cellBgView addSubview:signinStateImageView];
        
        if (i < 4) {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(signinDaysLabel.mas_bottom).offset(17);
                make.width.offset(cellWidth);
                make.left.equalTo(self.bgView).offset(margin + i * (width * 0.2 + margin));
                make.height.offset(cellHeight);
            }];
        } else {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(cellWidth);
                make.height.offset(cellHeight);
                make.top.equalTo(self.signinDaysLabel.mas_bottom).offset(cellHeight + 17 + 9);
                if (i == 4) {
                    make.left.equalTo(self.bgView).offset(margin1);
                } else if (i == 5) {
                    make.centerX.equalTo(self.bgView);
                } else {
                    make.right.equalTo(self.bgView).offset(-margin1);
                }
            }];
        }
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.top.equalTo(cellBgView);
            make.height.offset(cellHeight * 0.35);
        }];
        [signinStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.right.bottom.equalTo(cellBgView).offset(-4);
        }];
    }
    
    UIButton *signinBtn = [UIButton new];
    signinBtn.backgroundColor = SYColor(224, 159, 228);
    [signinBtn setTitle:@"点击领取" forState:UIControlStateNormal];
    [signinBtn setTitleColor:SYColor(255, 255, 255) forState:UIControlStateNormal];
    signinBtn.titleLabel.font = SYFont(14, YES);
    signinBtn.layer.cornerRadius = 9.f;
    signinBtn.layer.masksToBounds = YES;
    _signinBtn = signinBtn;
    [bgView addSubview:signinBtn];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColorFromHexString(@"#FBE8F9");
    _lineImageView = lineImageView;
    [bgView addSubview:lineImageView];
    
    UILabel *tipsTitleLabel = [UILabel new];
    tipsTitleLabel.text = @"活动规则";
    tipsTitleLabel.textAlignment = NSTextAlignmentLeft;
    tipsTitleLabel.textColor = SYColor(75, 75, 75);
    tipsTitleLabel.font = SYFont(11, YES);
    _tipsTitleLabel = tipsTitleLabel;
    [bgView addSubview:tipsTitleLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.textColor = SYColor(103, 103, 103);
    tipsLabel.font = SYFont(10, YES);
    tipsLabel.text = @"1.登录用户每天可签到1次，并领取奖励。礼物按日发放，过期无法领取。\n2.钻石可用于与主播连线。";
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = (SY_SCREEN_WIDTH - 60);
    CGFloat cellWidth = width * 0.2;
    CGFloat cellHeight = cellWidth * 0.814;
    CGFloat margin = width * 0.2 / 5;
    CGFloat margin1 = (width - width * 0.6 - margin * 2) / 2;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-60);
        make.bottom.equalTo(self.tipsLabel).offset(20);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.offset(40);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.height.width.offset(23);
        make.right.equalTo(self.bgView).offset(-7);
    }];
    [_signinDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView);
        make.height.offset(15);
    }];
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(margin1);
        make.right.equalTo(self.bgView).offset(-margin1);
        make.top.equalTo(self.signinDaysLabel.mas_bottom).offset(cellHeight * 2 + 17 + 9 + 21);
        make.height.offset(33.5);
    }];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signinBtn.mas_bottom).offset(18);
        make.height.offset(1.5);
        make.centerX.equalTo(self.bgView);
        make.width.equalTo(self.bgView).offset(-18);
    }];
    [_tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signinBtn);
        make.height.offset(12);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(9);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signinBtn);
        make.right.equalTo(self.signinBtn);
        make.top.equalTo(self.tipsTitleLabel.mas_bottom).offset(9);
    }];
}

@end
