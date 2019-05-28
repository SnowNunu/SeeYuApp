//
//  SYAddFriendsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAddFriendsVC.h"

@interface SYAddFriendsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIView *idTextBgView;

@property (nonatomic, strong) UITextField *idTextField;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _sendRequest = NO;
    if (self.viewModel.friendId != nil && self.viewModel.friendId.length > 0) {
        self.idTextField.text = self.viewModel.friendId;
        [self searchFriend];
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    [[self.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self searchFriend];
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *usersArray) {
        if (usersArray.count > 0) {
            [self.tableView reloadData];
        } else {
            if (self.sendRequest) {
                [MBProgressHUD sy_showError:@"未查询到该好友"];
            }
        }
    }];
}

- (void)_setupSubViews {
    UIView *idTextBgView = [UIView new];
    idTextBgView.backgroundColor = SYColor(240, 207, 255);
    idTextBgView.layer.cornerRadius = 9.5f;
    idTextBgView.layer.masksToBounds = YES;
    _idTextBgView = idTextBgView;
    [self.view addSubview:idTextBgView];
    
    UITextField *idTextField = [UITextField new];
    idTextField.font = SYFont(14, YES);
    idTextField.textColor = [UIColor whiteColor];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"用户ID/用户昵称" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:SYFont(12, YES)}];
    idTextField.attributedPlaceholder = attrString;
    idTextField.layer.cornerRadius = 9.5f;
    idTextField.backgroundColor = SYColorFromHexString(@"#D8A8EE");
    idTextField.textAlignment = NSTextAlignmentCenter;
    _idTextField = idTextField;
    [self.view addSubview:idTextField];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SYAddFriendsListCell"];
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIButton *searchBtn = [UIButton new];
    searchBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTintColor:[UIColor whiteColor]];
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
}

- (void)_makeSubViewsConstraints {
    [self.idTextBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(2.5);
        make.right.equalTo(self.view).offset(-2.5);
        make.top.equalTo(self.view).offset(2.5);
        make.height.offset(57);
    }];
    [self.idTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.idTextBgView);
        make.top.equalTo(self.idTextBgView).offset(10);
        make.bottom.equalTo(self.idTextBgView).offset(-10);
        make.width.equalTo(self.idTextBgView).offset(-20);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.top.equalTo(self.idTextBgView.mas_bottom);
        make.bottom.equalTo(self.searchBtn.mas_top);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59.5f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYAddFriendsListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYAddFriendsListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    SYUser *user = self.viewModel.datasource[indexPath.row];
    
    UIView *bgView = [UIView new];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 7.5f;
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColor(240, 207, 255) : SYColor(245, 223, 255);
    [cell.contentView addSubview:bgView];
    
    // 好友头像
    UIImageView *avatarView = [UIImageView new];
    avatarView.layer.cornerRadius = 22.5f;
    avatarView.clipsToBounds = YES;
    [avatarView yy_setImageWithURL:[NSURL URLWithString:user.userHeadImg] placeholder:SYDefaultAvatar(SYDefaultAvatarTypeDefualt) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    [bgView addSubview:avatarView];
    
    // 好友昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.text = user.userName;
    aliasLabel.font = SYFont(11, YES);
    aliasLabel.textColor = SYColor(193, 99, 237);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:aliasLabel];
    
    // 好友ID
    UILabel *idLabel = [UILabel new];
    idLabel.text = [NSString stringWithFormat:@"ID：%@",user.userId];
    idLabel.font = SYFont(10, YES);
    idLabel.textColor = SYColor(193, 99, 237);
    idLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:idLabel];
    
    // 添加还有按钮
    UIButton *addFriendBtn = [UIButton new];
    [addFriendBtn setBackgroundImage:SYImageNamed(@"agreeBtn_bg") forState:UIControlStateNormal];
    [addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addFriendBtn setTitle:@"添加" forState:UIControlStateNormal];
    addFriendBtn.titleLabel.font = SYFont(10, YES);
    [[addFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYUser *user = self.viewModel.services.client.currentUser;
        if (user.userVipStatus == 1) {
            if (user.userVipExpiresAt != nil) {
                NSComparisonResult result = [user.userVipExpiresAt compare:[NSDate date]];
                if (result == NSOrderedDescending) {
                    // 会员未过期
                    [self.viewModel.addFriendRequestCommand execute:user.userId];
                } else {
                    // 会员已过期的情况
                    [self openRechargeTipsView:@"vip"];
                }
            }
        } else {
            // 未开通会员
            [self openRechargeTipsView:@"vip"];
        }
    }];
    [cell.contentView addSubview:addFriendBtn];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(2.5);
        make.left.equalTo(cell.contentView).offset(2.5);
        make.right.equalTo(cell.contentView).offset(-2.5);
        make.bottom.equalTo(cell.contentView);
    }];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(10);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(10);
        make.top.equalTo(bgView).offset(16);
        make.height.offset(10);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(aliasLabel);
        make.top.equalTo(aliasLabel.mas_bottom).offset(8);
    }];
    [addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-10);
        make.width.offset(55);
        make.centerY.equalTo(bgView);
        make.height.offset(20);
    }];
    return cell;
}

// 搜索好友
- (void)searchFriend {
    if ([self.idTextField.text sb_trimAllWhitespace].length > 0) {
        self.sendRequest = YES;
        NSString *string = [self.idTextField.text sb_trimAllWhitespace];
        if ([string isEqualToString:self.viewModel.services.client.currentUserId] || [string isEqualToString:self.viewModel.services.client.currentUser.userName]) {
            [MBProgressHUD sy_showTips:@"不能添加自己为好友"];
        } else {
            [self.viewModel.searchFriendsCommand execute:[self.idTextField.text sb_trimAllWhitespace]];
        }
    } else {
        [MBProgressHUD sy_showTips:@"请先输入好友昵称或者id"];
    }
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

@end
