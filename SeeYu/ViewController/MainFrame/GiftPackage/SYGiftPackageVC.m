//
//  SYGiftPackageVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/27.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftPackageVC.h"
#import "SYGiftPackageModel.h"

@interface SYGiftPackageVC ()

@property (nonatomic, strong) NSArray *dayArray;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *signinBtn;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UILabel *tipsTitleLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation SYGiftPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dayArray = @[@"第一天",@"第二天",@"第三天",@"第四天",@"第五天",@"第六天",@"第七天",];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.signinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.receiveGiftCommand execute:nil];
    }];
    [self.viewModel.receiveGiftCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYGiftPackageModel *model) {
        [MBProgressHUD sy_showTips:model.award addedToView:self.view];
        UIImageView *imageView = [self.view viewWithTag:888 + model.day - 1];
        imageView.hidden = NO;
        self.signinBtn.backgroundColor = [UIColor grayColor];
        self.signinBtn.userInteractionEnabled = NO;
    }];
    [self.viewModel.receiveGiftCommand.errors subscribeNext:^(NSError *error) {
        if (error.code == 107) {
            [MBProgressHUD sy_showTips:@"您已经领取过，当天不能重复领取！" addedToView:self.view];
        } else {
            [MBProgressHUD sy_showErrorTips:error addedToView:self.view];
        }
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
    titleLabel.text = @"新人礼包";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
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
        [bgView addSubview:cellBgView];
        
        SYGiftPackageModel *model = self.viewModel.giftPackagesArray[i];
        UIImageView *iconImageView = [UIImageView new];
        if (model.giftRecordType == 1) {
            // 钻石
            iconImageView.image = SYImageNamed(@"diamond");
        } else if (model.giftRecordType == 2) {
            // VIP
            iconImageView.image = SYImageNamed(@"VIP");
        } else {
            // 现金
            iconImageView.image = SYImageNamed(@"money");
        }
        if (i == 6) {
            // 随机礼物
            iconImageView.image = SYImageNamed(@"diamond");
        }
        [cellBgView addSubview:iconImageView];
        
        UILabel *dayLabel = [UILabel new];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = SYColor(255, 255, 255);
        dayLabel.backgroundColor = SYColorFromHexString(@"#E081A5");
        dayLabel.font = SYFont(10, YES);
        dayLabel.text = _dayArray[i];
        [cellBgView addSubview:dayLabel];
        
        UILabel *numberLabel = [UILabel new];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = SYColor(75, 75, 75);
        numberLabel.font = SYFont(9, YES);
        if (model.giftRecordType == 1) {
            numberLabel.text = [NSString stringWithFormat:@"%d钻石",model.giftRecordNum];
        } else if (model.giftRecordType == 2) {
            numberLabel.text = [NSString stringWithFormat:@"%d天会员",model.giftRecordNum];
        } else {
            numberLabel.text = [NSString stringWithFormat:@"%d元",model.giftRecordNum];
        }
        if (i == 6) {
            // 随机礼物
            numberLabel.text = @"随机礼物";
        }
        [cellBgView addSubview:numberLabel];
        
        UIImageView *signinStateImageView = [UIImageView new];
        signinStateImageView.image = SYImageNamed(@"checked");
        signinStateImageView.tag = 888 + i;
        [cellBgView addSubview:signinStateImageView];
        signinStateImageView.hidden = model.giftRecordIsReceive == 0 ? YES : NO;
        
        if (i < 4) {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).offset(18);
                make.width.offset(cellWidth);
                make.left.equalTo(self.bgView).offset(margin + i * (width * 0.2 + margin));
                make.height.offset(cellHeight);
            }];
        } else {
            [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(cellWidth);
                make.height.offset(cellHeight);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(cellHeight + 18 + 9);
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
        if (model.giftRecordType == 1) {
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cellBgView).offset(5);
                make.width.height.offset(12);
                make.centerY.equalTo(numberLabel);
            }];
            numberLabel.textAlignment = NSTextAlignmentLeft;
            [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(3);
                make.top.equalTo(dayLabel.mas_bottom);
                make.bottom.equalTo(cellBgView);
            }];
        } else if(model.giftRecordType == 2) {
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
        } else {
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
        if (i == 6) {
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
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(margin1);
        make.right.equalTo(self.bgView).offset(-margin1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(cellHeight * 2 + 18 + 9 + 21);
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
