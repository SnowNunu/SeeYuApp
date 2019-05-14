//
//  SYGuideVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGuideVC.h"
#import "JPVideoPlayerKit.h"

@interface SYGuideVC ()

//@property (nonatomic, strong) YYAnimatedImageView *gifImageView;

@property (nonatomic, strong) UIView *videoShowView;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation SYGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.loginCommand execute:nil];
    }];
    [[_registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.registerCommand execute:nil];
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
}

@end
