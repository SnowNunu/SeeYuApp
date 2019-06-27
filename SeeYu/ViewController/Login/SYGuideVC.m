//
//  SYGuideVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGuideVC.h"
#import "JPVideoPlayerKit.h"

@interface SYGuideVC () <TYLabelDelegate>

//@property (nonatomic, strong) YYAnimatedImageView *gifImageView;

@property (nonatomic, strong) UIView *videoShowView;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *registerBtn;

/// 同意协议按钮
@property (nonatomic, weak) UIButton *agreementBtn;

/// 注册协议
@property (nonatomic, weak) TYLabel *registerTips;

/// 隐私政策
@property (nonatomic, weak) TYLabel *privacyTips;

@end

@implementation SYGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.agreementBtn.selected) {
            [self.viewModel.loginCommand execute:nil];
        } else {
            [MBProgressHUD sy_showTips:@"请先同意注册协议与隐私政策"];
        }
    }];
    [[_registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.agreementBtn.selected) {
            [self.viewModel.registerCommand execute:nil];
        } else {
            [MBProgressHUD sy_showTips:@"请先同意注册协议与隐私政策"];
        }
    }];
    [[_agreementBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.agreementBtn.selected = !self.agreementBtn.selected;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login" ofType:@"mp4"]];
    [_videoShowView jp_playVideoWithURL:fileUrl options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        playerModel.muted = YES;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_videoShowView jp_stopPlay];
}

- (void)_setupSubViews {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"login.gif" ofType:nil];
//    YYImage *giftImage = [YYImage imageWithContentsOfFile:path];
//    YYAnimatedImageView *gifImageView = [YYAnimatedImageView new];
//    gifImageView.contentMode = UIViewContentModeScaleAspectFill;
//    gifImageView.image = giftImage;
//    _gifImageView = gifImageView;
//    [self.view addSubview:gifImageView];
    
    UIView *videoShowView = [[UIView alloc] initWithFrame:self.view.bounds];
    _videoShowView = videoShowView;
    [self.view addSubview:videoShowView];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitleColor:SYColor(159, 105, 235) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = SYRegularFont(18);
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20.f;
    _loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor = SYColor(159, 105, 235);
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = SYRegularFont(18);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 20.f;
    _registerBtn = registerBtn;
    [self.view addSubview:registerBtn];
    
    TYLabel *registerTips = [TYLabel new];
    registerTips.backgroundColor = [UIColor clearColor];
    registerTips.attributedText = [self setAgreementText:@"register"];
    registerTips.delegate = self;
    registerTips.tag = 958;
    _registerTips = registerTips;
    [self.view addSubview:registerTips];
    
    TYLabel *privacyTips = [TYLabel new];
    privacyTips.backgroundColor = [UIColor clearColor];
    privacyTips.attributedText = [self setAgreementText:@"privacy"];
    privacyTips.delegate = self;
    privacyTips.tag = 988;
    _privacyTips = privacyTips;
    [self.view addSubview:privacyTips];
    
    UIButton *agreementBtn = [UIButton new];
    [agreementBtn setImage:SYImageNamed(@"agree_btn_unselected") forState:UIControlStateNormal];
    [agreementBtn setImage:SYImageNamed(@"agree_btn_selected") forState:UIControlStateSelected];
    agreementBtn.selected = YES;
    _agreementBtn = agreementBtn;
    [self.view addSubview:agreementBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat margin = (SY_SCREEN_WIDTH - 30 - 2 * 100 ) / 2;
//    [_gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(40);
        make.left.equalTo(self.view).offset(margin);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(self.loginBtn);
        make.left.equalTo(self.loginBtn.mas_right).offset(30);
    }];
    [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerTips.mas_left);
        make.centerY.equalTo(self.registerTips);
        make.width.height.offset(20);
    }];
    [_registerTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-20);
        make.height.offset(30);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    [_privacyTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerTips.mas_right);
        make.height.centerY.equalTo(self.registerTips);
    }];
}

- (NSAttributedString *)setAgreementText:(NSString *)type {
    NSMutableAttributedString *attString = [NSMutableAttributedString new];
    NSString *text;
    if ([type isEqualToString:@"register"]) {
        text = @"同意用户-注册协议";
    } else {
        text = @"与-隐私政策";
    }
    NSArray *textArray = [text componentsSeparatedByString:@"-"];
    NSArray *colorArray = @[SYColorFromHexString(@"#454E55"),SYColorFromHexString(@"#237CB7")];
    NSInteger index = 0;
    for (NSString *text in textArray) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
        // 设置当前文本字体
        attributedString.ty_color = colorArray[index];
        // 设置当前文本颜色
        attributedString.ty_font = SYFont(15, YES);
        if (index == 1) {
            attributedString.ty_underLineStyle = NSUnderlineStyleSingle;
            TYTextHighlight *textHighlight = [TYTextHighlight new];
            NSRange range = NSMakeRange(0, 4);
            [attributedString addTextHighlightAttribute:textHighlight range:range];
        }
        [attString appendAttributedString:attributedString];
        ++index;
    }
    return attString;
}

- (void)label:(TYLabel *)label didTappedTextHighlight:(TYTextHighlight *)textHighlight {
    if (label.tag == 958) {
        [self.viewModel.enterRegisterAgreementViewCommand execute:nil];
    } else {
        [self.viewModel.enterPrivacyAgreementViewCommand execute:nil];
    }
}


@end
