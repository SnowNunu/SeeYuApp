//
//  SYProfileVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYProfileVC.h"
#import "NSDate+Extension.h"

@interface SYProfileVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UIButton *detailBtn;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *vipBgView;

@property (nonatomic, strong) UIImageView *vipImageView;

@property (nonatomic, strong) UILabel *vipLabel;

@property (nonatomic, strong) UIImageView *separateImageView;

@property (nonatomic, strong) UIView *authenticationBgView;

@property (nonatomic, strong) UIImageView *authenticationImageView;

@property (nonatomic, strong) UILabel *authenticationLabel;

@property (nonatomic ,strong) NSArray *dataSource;

@end

@implementation SYProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"我的动态",@"icon":@"icon_moment"},@{@"label":@"我的礼物",@"icon":@"icon_gift"},@{@"label":@"我的钱包",@"icon":@"icon_package"},@{@"label":@"我的钻石",@"icon":@"icon_diamond"},@{@"label":@"设置",@"icon":@"icon_setting"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        @strongify(self)
        if (![user.userName sy_isNullOrNil] && user.userName.length > 0) {
            self.aliasLabel.text = user.userName;
        }
        if (![user.userSignature sy_isNullOrNil] && user.userSignature.length > 0) {
            self.signatureLabel.text = user.userSignature;
        }
        if (![user.userHeadImg sy_isNullOrNil] && user.userHeadImg.length > 0) {
            [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
        if (user.userVipStatus == 1) {
            if (user.userVipExpiresAt != nil) {
                
                if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                    // 已过期
                    self.vipImageView.image = SYImageNamed(@"VIP_disable");
                } else {
                    // 未过期
                    self.vipImageView.image = SYImageNamed(@"VIP");
                }
            }
        } else {
            self.vipImageView.image = SYImageNamed(@"VIP_disable");
        }
        if (user.identityStatus == 1) {
            self.authenticationImageView.image = SYImageNamed(@"truePerson");
        } else {
            self.authenticationImageView.image = SYImageNamed(@"truePerson_disable");
        }
        if (user.userRegisterTime != nil) {
            NSTimeInterval interval = 8 * 3600 - [user.userRegisterTime timeIntervalSinceNow];
            if (interval > 7 * 24 * 3600) {
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"btn_checkin_cricle" target:self selector:@selector(openSigninView) textType:NO];
            }
        }
    }];
    [[self.detailBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.enterNextViewCommand execute:@(7)];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 172)];
    headerView.backgroundColor = [UIColor whiteColor];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    UITapGestureRecognizer *infoTap = [UITapGestureRecognizer new];
    [[infoTap rac_gestureSignal] subscribeNext:^(id x) {
        [self.viewModel.enterNextViewCommand execute:@(7)];
    }];
    [headerView addGestureRecognizer:infoTap];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    //用户头像
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.image = SYImageNamed(@"DefaultProfileHead_66x66");
    avatarImageView.layer.cornerRadius = 30.f;
    avatarImageView.clipsToBounds = YES;
    _avatarImageView = avatarImageView;
    [headerView addSubview:avatarImageView];
    
    // 用户昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = SYColor(193, 99, 237);
    aliasLabel.font = SYFont(16, YES);
    _aliasLabel = aliasLabel;
    [headerView addSubview:aliasLabel];
    
    // 用户签名
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.textColor = SYColor(193, 99, 237);
    signatureLabel.font = SYFont(11, YES);
    _signatureLabel = signatureLabel;
    [headerView addSubview:signatureLabel];
    
    // 用户信息详情
    UIButton *detailBtn = [UIButton new];
    [detailBtn setImage:SYImageNamed(@"arrorMore") forState:UIControlStateNormal];
    _detailBtn = detailBtn;
    [headerView addSubview:detailBtn];
    
    // 分隔线
    UIImageView *separateImageView = [UIImageView new];
    separateImageView.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    _separateImageView = separateImageView;
    [headerView addSubview:separateImageView];
    
    // 底色背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = SYColorFromHexString(@"#FAEFFF");
    bgView.layer.cornerRadius = 9.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [headerView addSubview:bgView];
    
    // vip状态背景
    UIView *vipBgView = [UIView new];
    _vipBgView = vipBgView;
    [bgView addSubview:vipBgView];
    UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[vipTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(5)];
    }];
    [bgView addGestureRecognizer:vipTap];
    
    // vip状态
    UIImageView *vipImageView = [UIImageView new];
    vipImageView.image = SYImageNamed(@"VIP_disable");
    _vipImageView = vipImageView;
    [vipBgView addSubview:vipImageView];
    
    // vip tips
    UILabel *vipLabel = [UILabel new];
    vipLabel.font = SYFont(14, YES);
    vipLabel.textAlignment = NSTextAlignmentCenter;
    vipLabel.textColor = SYColor(193, 99, 237);
    vipLabel.text = @"VIP特权";
    _vipLabel = vipLabel;
    [vipBgView addSubview:vipLabel];
    
    // 真人认证状态背景
    UIView *authenticationBgView = [UIView new];
    _authenticationBgView = authenticationBgView;
    [bgView addSubview:authenticationBgView];
    UITapGestureRecognizer *authenticationTap = [[UITapGestureRecognizer alloc] init];
    [[authenticationTap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.enterNextViewCommand execute:@(6)];
    }];
    [authenticationBgView addGestureRecognizer:authenticationTap];
    
    // 真人认证状态
    UIImageView *authenticationImageView = [UIImageView new];
    authenticationImageView.image = SYImageNamed(@"truePerson_disable");
    _authenticationImageView = authenticationImageView;
    [authenticationBgView addSubview:authenticationImageView];
    
    // authentication tips
    UILabel *authenticationLabel = [UILabel new];
    authenticationLabel.font = SYFont(14, YES);
    authenticationLabel.textAlignment = NSTextAlignmentCenter;
    authenticationLabel.textColor = SYColor(193, 99, 237);
    authenticationLabel.text = @"真人认证";
    _authenticationLabel = authenticationLabel;
    [authenticationBgView addSubview:authenticationLabel];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.left.equalTo(self.headerView).offset(15);
        make.top.equalTo(self.headerView).offset(20);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
        make.height.offset(18);
        make.top.equalTo(self.headerView).offset(30);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.height.offset(15);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(11);
    }];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(28);
        make.height.offset(20);
        make.centerY.equalTo(self.avatarImageView);
        make.right.equalTo(self.headerView).offset(-25);
    }];
    [_separateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.height.offset(1);
        make.bottom.equalTo(self.avatarImageView).offset(15);
        make.width.equalTo(self.headerView).offset(-18);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(3);
        make.right.equalTo(self.headerView).offset(-3);
        make.bottom.equalTo(self.headerView);
        make.top.equalTo(self.separateImageView.mas_bottom).offset(3);
    }];
    [_vipBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.offset((SY_SCREEN_WIDTH - 6) / 2);
    }];
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.vipLabel.mas_top).offset(5);
        make.height.offset(55);
        make.width.offset(55);
        make.centerX.equalTo(self.vipBgView);
    }];
    [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vipImageView);
        make.bottom.equalTo(self.vipBgView.mas_bottom).offset(-14);
        make.height.offset(15);
    }];
    [_authenticationBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bgView);
        make.width.offset((SY_SCREEN_WIDTH - 6) / 2);
    }];
    [_authenticationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authenticationLabel.mas_top).offset(5);
        make.width.height.offset(55);
        make.centerX.equalTo(self.authenticationBgView);
    }];
    [_authenticationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.authenticationImageView);
        make.bottom.equalTo(self.authenticationBgView.mas_bottom).offset(-14);
        make.height.offset(15);
    }];
}

- (void)openSigninView {
    SYSigninVM *signVM = [[SYSigninVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
    SYSigninVC *signVC = [[SYSigninVC alloc] initWithViewModel:signVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:signVC withAnimation:animation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _dataSource[indexPath.row];
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 7.5f;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColorFromHexString(@"#F5DEFF") : SYColorFromHexString(@"#F8E9FF");
    [cell.contentView addSubview:bgView];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = SYImageNamed(params[@"icon"]);
    [cell.contentView addSubview:iconImageView];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = params[@"label"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = SYFont(13, YES);
    contentLabel.textColor = SYColor(193, 99, 237);
    [cell.contentView addSubview:contentLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cell.contentView).offset(4);
        make.right.equalTo(cell.contentView).offset(-4);
        make.bottom.equalTo(cell.contentView);
    }];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(24);
        make.width.height.offset(22);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(24);
        make.centerY.equalTo(iconImageView);
        make.height.offset(20);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewModel.enterNextViewCommand execute:@(indexPath.row)];
}

@end
