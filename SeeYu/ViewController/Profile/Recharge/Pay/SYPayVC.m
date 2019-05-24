//
//  SYPayVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPayVC.h"

@interface SYPayVC ()

@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *orderLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *wechatPayBtn;

@property (nonatomic, strong) UIImageView *wechatLogoView;

@property (nonatomic, strong) UILabel *wechatTitleLabel;

@property (nonatomic, strong) UILabel *wechatContentLabel;

@property (nonatomic, strong) UIButton *aliPayBtn;

@property (nonatomic, strong) UIImageView *aliLogoView;

@property (nonatomic, strong) UILabel *aliTitleLabel;

@property (nonatomic, strong) UILabel *aliContentLabel;

@property (nonatomic, strong) UIImageView *line2;

@end

@implementation SYPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissSelfView];
    }];
    [[_wechatPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUserId,@"goodsId":self.viewModel.model.goodsId,@"rechargeType":@"1"};
        [self.viewModel.requestPayInfoCommand execute:params];
        [self dismissSelfView];
    }];
    [[_aliPayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUserId,@"goodsId":self.viewModel.model.goodsId,@"rechargeType":@"2"};
        [self.viewModel.requestPayInfoCommand execute:params];
        [self dismissSelfView];
    }];
    [SYNotificationCenter addObserver:self selector:@selector(goBack) name:@"goBackFromPayView" object:nil];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(0, 0, 0, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [self dismissSelfView];
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgview = [UIView new];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.masksToBounds = YES;
    bgview.layer.cornerRadius = 8.f;
    bgview.layer.borderWidth = 1.5f;
    bgview.layer.borderColor = SYColorFromHexString(@"#DAA8F0").CGColor;
    _bgview = bgview;
    [self.view addSubview:bgview];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = SYFont(17.5, YES);
    titleLabel.backgroundColor = SYColorFromHexString(@"#DE93E3");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提示信息";
    _titleLabel = titleLabel;
    [bgview addSubview:titleLabel];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setBackgroundImage:SYImageNamed(@"closeBtn") forState:UIControlStateNormal];
    _closeBtn = closeBtn;
    [bgview addSubview:closeBtn];
    
    UILabel *orderLabel = [UILabel new];
    orderLabel.textColor = SYColor(64, 64, 64);
    orderLabel.font = SYFont(13, YES);
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.text = [NSString stringWithFormat:@"订单信息：%@元",self.viewModel.model.goodsMoney];
    _orderLabel = orderLabel;
    [bgview addSubview:orderLabel];
    
    UIImageView *line1 = [UIImageView new];
    line1.backgroundColor = SYColorFromHexString(@"#F7D6F4");
    _line1 = line1;
    [bgview addSubview:line1];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textColor = SYColor(64, 64, 64);
    tipsLabel.font = SYFont(13, YES);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.text = @"请选择支付方式：";
    _tipsLabel = tipsLabel;
    [bgview addSubview:tipsLabel];
    
    UIButton *wechatPayBtn = [UIButton new];
    wechatPayBtn.backgroundColor = SYColorFromHexString(@"#FCF5FF");
    _wechatPayBtn = wechatPayBtn;
    [bgview addSubview:wechatPayBtn];
    
    UIImageView *wechatLogoView = [UIImageView new];
    wechatLogoView.image = SYImageNamed(@"weixin");
    _wechatLogoView = wechatLogoView;
    [wechatPayBtn addSubview:wechatLogoView];
    
    UILabel *wechatTitleLabel = [UILabel new];
    wechatTitleLabel.textColor = SYColor(64, 64, 64);
    wechatTitleLabel.font = SYFont(13, YES);
    wechatTitleLabel.textAlignment = NSTextAlignmentLeft;
    wechatTitleLabel.text = @"微信支付：";
    _wechatTitleLabel = wechatTitleLabel;
    [bgview addSubview:wechatTitleLabel];
    
    UILabel *wechatContentLabel = [UILabel new];
    wechatContentLabel.textColor = SYColor(64, 64, 64);
    wechatContentLabel.font = SYFont(9, YES);
    wechatContentLabel.textAlignment = NSTextAlignmentLeft;
    wechatContentLabel.text = @"推荐使用微信的用户使用";
    _wechatContentLabel = wechatContentLabel;
    [bgview addSubview:wechatContentLabel];
    
    UIButton *aliPayBtn = [UIButton new];
    aliPayBtn.backgroundColor = SYColorFromHexString(@"#FCF5FF");
    _aliPayBtn = aliPayBtn;
    [bgview addSubview:aliPayBtn];
    
    UIImageView *aliLogoView = [UIImageView new];
    aliLogoView.image = SYImageNamed(@"zhifubao");
    _aliLogoView = aliLogoView;
    [aliPayBtn addSubview:aliLogoView];
    
    UILabel *aliTitleLabel = [UILabel new];
    aliTitleLabel.textColor = SYColor(64, 64, 64);
    aliTitleLabel.font = SYFont(13, YES);
    aliTitleLabel.textAlignment = NSTextAlignmentLeft;
    aliTitleLabel.text = @"支付宝支付：";
    _aliTitleLabel = aliTitleLabel;
    [bgview addSubview:aliTitleLabel];
    
    UILabel *aliContentLabel = [UILabel new];
    aliContentLabel.textColor = SYColor(64, 64, 64);
    aliContentLabel.font = SYFont(9, YES);
    aliContentLabel.textAlignment = NSTextAlignmentLeft;
    aliContentLabel.text = @"推荐使用支付宝的用户使用";
    _aliContentLabel = aliContentLabel;
    [bgview addSubview:aliContentLabel];
    
    UIImageView *line2 = [UIImageView new];
    line2.backgroundColor = SYColorFromHexString(@"#F7D6F4");
    _line2 = line2;
    [bgview addSubview:line2];
}

- (void)_makeSubViewsConstraints {
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).offset(-60);
        make.center.equalTo(self.view);
        make.height.offset(264);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgview);
        make.height.offset(35);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(23);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel).offset(-8);
    }];
    [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview).offset(30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bgview).offset(-4);
        make.centerX.equalTo(self.bgview);
        make.top.equalTo(self.orderLabel.mas_bottom).offset(15);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(15);
        make.left.height.equalTo(self.orderLabel);
    }];
    [_wechatPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.left.width.equalTo(self.bgview);
        make.height.offset(65);
    }];
    [_wechatLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatPayBtn).offset(30);
        make.centerY.equalTo(self.wechatPayBtn);
        make.width.height.offset(49);
    }];
    [_wechatTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatLogoView.mas_right).offset(15);
        make.height.offset(13);
        make.bottom.equalTo(self.wechatLogoView).offset(-24.5);
    }];
    [_wechatContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatTitleLabel);
        make.top.equalTo(self.wechatTitleLabel.mas_bottom).offset(8);
        make.height.offset(10);
    }];
    [_aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.wechatPayBtn);
        make.top.equalTo(self.wechatPayBtn.mas_bottom).offset(4);
    }];
    [_aliLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.wechatLogoView);
        make.centerY.equalTo(self.aliPayBtn);
    }];
    [_aliTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliLogoView.mas_right).offset(15);
        make.height.offset(13);
        make.bottom.equalTo(self.aliLogoView).offset(-24.5);
    }];
    [_aliContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliTitleLabel);
        make.top.equalTo(self.aliTitleLabel.mas_bottom).offset(8);
        make.height.offset(10);
    }];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.line1);
        make.bottom.equalTo(self.aliPayBtn).offset(4);
    }];
}

- (void)dismissSelfView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SYSharedAppDelegate dismissVC:self];
    });
}

- (void)goBack {
    [self.viewModel.services popViewModelAnimated:YES];
}

@end
