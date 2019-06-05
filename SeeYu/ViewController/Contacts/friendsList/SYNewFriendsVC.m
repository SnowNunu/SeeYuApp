//
//  SYNewFriendsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/30.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNewFriendsVC.h"
#import "SYNewFriendModel.h"

@interface SYNewFriendsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYNewFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestNewFriendsCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *usersArray) {
        if (usersArray.count > 0) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SYNewFriendsListCell"];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYNewFriendsListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYNewFriendsListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYNewFriendModel *model = self.viewModel.datasource[indexPath.row];
    
    UIView *bgView = [UIView new];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 9.f;
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColorFromHexString(@"#F0CFFF") : SYColorFromHexString(@"#F5DFFF");
    [cell.contentView addSubview:bgView];
    
    // 好友头像
    UIImageView *avatarView = [UIImageView new];
    avatarView.layer.cornerRadius = 22.f;
    avatarView.clipsToBounds = YES;
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [avatarView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [bgView addSubview:avatarView];
    
    // 好友昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.text = model.userFriendName;
    aliasLabel.font = SYFont(11,YES);
    aliasLabel.textColor = SYColor(193, 99, 237);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:aliasLabel];
    
    // 好友ID
    UILabel *idLabel = [UILabel new];
    idLabel.text = [NSString stringWithFormat:@"ID：%@",model.userFriendId];
    idLabel.font = SYFont(10,YES);
    idLabel.textColor = SYColor(193, 99, 237);
    idLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:idLabel];
    
    // 同意按钮按钮
    UIButton *agreeFriendBtn = [UIButton new];
    [agreeFriendBtn setBackgroundColor:SYColorFromHexString(@"#EB7BE1")];
    [agreeFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeFriendBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeFriendBtn.titleLabel.font = SYFont(13, YES);
    agreeFriendBtn.layer.cornerRadius = 9.f;
    agreeFriendBtn.layer.masksToBounds = YES;
    [[agreeFriendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SYUser *user = self.viewModel.services.client.currentUser;
        if (user.userVipStatus == 1) {
            if (user.userVipExpiresAt != nil) {
                if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                    // 已过期
                    [self openRechargeTipsView:@"vip"];
                } else {
                    // 未过期
                    [self.viewModel.agreeFriendRequestCommand execute:model.userFriendId];
                }
            } else {
                [self openRechargeTipsView:@"vip"];
            }
        } else {
            // 未开通会员
            [self openRechargeTipsView:@"vip"];
        }
    }];
    [bgView addSubview:agreeFriendBtn];
    
    // 目前好友关系状态
    UILabel *relationStatusLabel = [UILabel new];
    relationStatusLabel.font = SYFont(11,YES);
    relationStatusLabel.textColor = SYColor(193, 99, 237);
    relationStatusLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:relationStatusLabel];
    
    if (model.userHeadImg == nil || model.userHeadImg.length == 0 || model.userHeadImgFlag != 1) {
        avatarView.image = SYImageNamed(@"anchor_deafult_image");
    } else {
        [avatarView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYImageNamed(@"anchor_deafult_image") options:SYWebImageOptionAutomatic completion:NULL];
    }
    if ([model.relation_status isEqualToString:@"2"]) {
        relationStatusLabel.hidden = YES;
        agreeFriendBtn.hidden = NO;
    } else {
        relationStatusLabel.hidden = NO;
        agreeFriendBtn.hidden = YES;
        if ([model.relation_status isEqualToString:@"1"]) {
            relationStatusLabel.text = @"已通过";
        } else {
            relationStatusLabel.text = @"已删除";
        }
    }
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(3);
        make.left.equalTo(cell.contentView).offset(2);
        make.right.equalTo(cell.contentView).offset(-2);
        make.bottom.equalTo(cell.contentView);
    }];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.centerY.equalTo(bgView);
        make.left.equalTo(cell.contentView).offset(10);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(8);
        make.right.equalTo(agreeFriendBtn.mas_left).offset(-15);
        make.top.equalTo(avatarView);
        make.height.offset(15);
    }];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(aliasLabel);
        make.top.equalTo(aliasLabel.mas_bottom).offset(10);
    }];
    [agreeFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.width.offset(50);
        make.centerY.equalTo(bgView);
        make.height.offset(18);
    }];
    [relationStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(agreeFriendBtn);
    }];
    return cell;
}

// 打开充值提示
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
