//
//  SYWalletVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/22.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYWalletVC.h"
#import "SYWalletDetailModel.h"

@interface SYWalletVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *lineTop;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *totalAmountTitleLabel;

@property (nonatomic, strong) UILabel *totalAmountContentLabel;

@property (nonatomic, strong) UIView *withdrawalView;

@property (nonatomic, strong) UIImageView *withdrawalImageView;

@property (nonatomic, strong) UILabel *withdrawalLabel;

@property (nonatomic, strong) UILabel *withdrawalTitleLabel;

@property (nonatomic, strong) UILabel *withdrawalContentLabel;

@property (nonatomic, strong) UILabel *freezeTitleLabel;

@property (nonatomic, strong) UILabel *freezeContentLabel;

@property (nonatomic, strong) UIImageView *lineBottom;

@property (nonatomic, strong) UILabel *detailsLabel;

@property (nonatomic, strong) UIView *moreInfoView;

@property (nonatomic, strong) UIImageView *moreInfoImageView;

@property (nonatomic, strong) UILabel *moreInfoLabel;

@end

@implementation SYWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestIncomeInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, detailModel) subscribeNext:^(SYWalletDetailModel *model) {
        if (model != nil) {
            self.totalAmountContentLabel.text = [NSString stringWithFormat:@"%d",model.balance];
            self.withdrawalContentLabel.text = [NSString stringWithFormat:@"%d",model.availableWithdrawBalance];
            self.freezeContentLabel.text = [NSString stringWithFormat:@"%d",model.lockBalance];
        }
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.estimatedRowHeight = 80.f;    // 动态计算行高
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 69 + (SY_SCREEN_WIDTH - 20) * 0.455)];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIImageView *lineTop = [UIImageView new];
    lineTop.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    _lineTop = lineTop;
    [headerView addSubview:lineTop];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = SYImageNamed(@"myMoney_bg");
    _bgImageView = bgImageView;
    [headerView addSubview:bgImageView];
    
    UILabel *totalAmountTitleLabel = [UILabel new];
    totalAmountTitleLabel.text = @"总金额";
    totalAmountTitleLabel.font = SYFont(12, YES);
    totalAmountTitleLabel.textColor = SYColor(67, 53, 73);
    _totalAmountTitleLabel = totalAmountTitleLabel;
    [headerView addSubview:totalAmountTitleLabel];
    
    UILabel *totalAmountContentLabel = [UILabel new];
    totalAmountContentLabel.text = @"0";
    totalAmountContentLabel.font = SYFont(12, YES);
    totalAmountContentLabel.textColor = SYColor(67, 53, 73);
    _totalAmountContentLabel = totalAmountContentLabel;
    [headerView addSubview:totalAmountContentLabel];
    
    UIView *withdrawalView = [UIView new];
    _withdrawalView = withdrawalView;
    [headerView addSubview:withdrawalView];
    [withdrawalView bk_whenTapped:^{
        NSLog(@"点击了提现");
    }];
    
    UIImageView *withdrawalImageView = [UIImageView new];
    withdrawalImageView.image = SYImageNamed(@"right");
    _withdrawalImageView = withdrawalImageView;
    [withdrawalView addSubview:withdrawalImageView];
    
    UILabel *withdrawalLabel = [UILabel new];
    withdrawalLabel.textAlignment = NSTextAlignmentRight;
    withdrawalLabel.textColor = SYColor(67, 53, 73);
    withdrawalLabel.font = SYFont(12, YES);
    withdrawalLabel.text = @"提现";
    _withdrawalLabel = withdrawalLabel;
    [withdrawalView addSubview:withdrawalLabel];
    
    UILabel *withdrawalTitleLabel = [UILabel new];
    withdrawalTitleLabel.text = @"提现金额";
    withdrawalTitleLabel.font = SYFont(12, YES);
    withdrawalTitleLabel.textColor = SYColor(67, 53, 73);
    _withdrawalTitleLabel = withdrawalTitleLabel;
    [headerView addSubview:withdrawalTitleLabel];
    
    UILabel *withdrawalContentLabel = [UILabel new];
    withdrawalContentLabel.text = @"0";
    withdrawalContentLabel.font = SYFont(12, YES);
    withdrawalContentLabel.textColor = SYColor(67, 53, 73);
    _withdrawalContentLabel = withdrawalContentLabel;
    [headerView addSubview:withdrawalContentLabel];
    
    UILabel *freezeTitleLabel = [UILabel new];
    freezeTitleLabel.text = @"冻结金额";
    freezeTitleLabel.font = SYFont(12, YES);
    freezeTitleLabel.textColor = SYColor(67, 53, 73);
    _freezeTitleLabel = freezeTitleLabel;
    [headerView addSubview:freezeTitleLabel];
    
    UILabel *freezeContentLabel = [UILabel new];
    freezeContentLabel.text = @"0";
    freezeContentLabel.font = SYFont(12, YES);
    freezeContentLabel.textColor = SYColor(67, 53, 73);
    _freezeContentLabel = freezeContentLabel;
    [headerView addSubview:freezeContentLabel];
    
    UIImageView *lineBottom = [UIImageView new];
    lineBottom.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    _lineBottom = lineBottom;
    [headerView addSubview:lineBottom];
    
    UILabel *detailsLabel = [UILabel new];
    detailsLabel.textAlignment = NSTextAlignmentLeft;
    detailsLabel.textColor = SYColor(193, 99, 237);
    detailsLabel.font = SYFont(15, YES);
    detailsLabel.text = @"每日详情";
    _detailsLabel = detailsLabel;
    [headerView addSubview:detailsLabel];
    
    UIView *moreInfoView = [UIView new];
    _moreInfoView = moreInfoView;
    [headerView addSubview:moreInfoView];
    [moreInfoView bk_whenTapped:^{
        NSLog(@"点击了更多数据");
    }];
    
    UIImageView *moreInfoImageView = [UIImageView new];
    moreInfoImageView.image = SYImageNamed(@"arrorMore");
    _moreInfoImageView = moreInfoImageView;
    [moreInfoView addSubview:moreInfoImageView];
    
    UILabel *moreInfoLabel = [UILabel new];
    moreInfoLabel.textAlignment = NSTextAlignmentRight;
    moreInfoLabel.textColor = SYColor(193, 99, 237);
    moreInfoLabel.font = SYFont(11, YES);
    moreInfoLabel.text = @"更多数据";
    _moreInfoLabel = moreInfoLabel;
    [moreInfoView addSubview:moreInfoLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = SY_SCREEN_WIDTH - 20;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.centerX.equalTo(self.headerView);
        make.width.offset(SY_SCREEN_WIDTH - 15);
        make.top.equalTo(self.headerView).offset(7);
    }];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.width.offset(width);
        make.top.equalTo(self.lineTop.mas_bottom).offset(5);
        make.height.offset(width * 0.455);
    }];
    [_totalAmountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(24);
        make.left.equalTo(self.bgImageView).offset(30);
        make.height.offset(12);
    }];
    [_totalAmountContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.totalAmountTitleLabel);
        make.top.equalTo(self.totalAmountTitleLabel.mas_bottom).offset(15);
    }];
    [_withdrawalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawalLabel);
        make.right.equalTo(self.withdrawalImageView);
        make.top.height.equalTo(self.withdrawalImageView);
    }];
    [_withdrawalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(24);
        make.right.equalTo(self.bgImageView).offset(-15);
        make.width.offset(13);
        make.height.offset(15);
    }];
    [_withdrawalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.withdrawalImageView.mas_left).offset(-8);
        make.height.equalTo(self.withdrawalImageView);
        make.centerY.equalTo(self.withdrawalImageView);
    }];
    [_withdrawalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalAmountContentLabel.mas_bottom).offset(35);
        make.left.height.equalTo(self.totalAmountTitleLabel);
    }];
    [_withdrawalContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawalTitleLabel.mas_bottom).offset(10);
        make.left.height.equalTo(self.totalAmountTitleLabel);
    }];
    [_freezeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.withdrawalTitleLabel);
        make.left.equalTo(self.withdrawalTitleLabel.mas_right).offset(85);
    }];
    [_freezeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.freezeTitleLabel);
        make.bottom.equalTo(self.withdrawalContentLabel);
    }];
    [_lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.lineTop);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(7);
    }];
    [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.lineBottom).offset(12);
        make.height.offset(15);
    }];
    [_moreInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moreInfoLabel);
        make.right.equalTo(self.moreInfoImageView);
        make.top.height.equalTo(self.moreInfoImageView);
    }];
    [_moreInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.moreInfoLabel);
        make.right.equalTo(self.headerView).offset(-19);
        make.width.offset(17);
        make.height.offset(12);
    }];
    [_moreInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreInfoImageView.mas_left).offset(-4);
        make.height.equalTo(self.moreInfoImageView);
        make.bottom.equalTo(self.detailsLabel);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (indexPath.row > 0) {
        params = self.viewModel.datasource[indexPath.row - 1];
    }
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColorFromHexString(@"#F8E9FF") : SYColorFromHexString(@"#F4DEFF");
    [cell.contentView addSubview:bgView];
    
    UILabel *timeLabel = [UILabel new];
    if (indexPath.row == 0) {
        timeLabel.text = @"日期";
    } else {
        timeLabel.text = params[@"datetime"];
    }
    timeLabel.textColor = SYColor(193, 99, 237);
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = SYFont(10, YES);
    [cell.contentView addSubview:timeLabel];
    
    UILabel *incomeLabel = [UILabel new];
    if (indexPath.row == 0) {
        incomeLabel.text = @"收入（元）";
    } else {
        NSNumber *money = params[@"money"];
        incomeLabel.text = [NSString stringWithFormat:@"%d",money.intValue];
    }
    incomeLabel.textColor = SYColor(193, 99, 237);
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    incomeLabel.font = SYFont(10, YES);
    [cell.contentView addSubview:incomeLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell);
        make.left.equalTo(cell).offset(2);
        make.right.equalTo(cell).offset(-2);
        make.bottom.equalTo(cell).offset(-1);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        if (indexPath.row == 0) {
            make.left.equalTo(cell).offset(63);
        } else {
            make.left.equalTo(cell).offset(38);
        }
        make.height.offset(10);
    }];
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(timeLabel);
        if (indexPath.row == 0) {
            make.right.equalTo(cell).offset(-36.5);
        } else {
            make.right.equalTo(cell).offset(-52.5);
        }
    }];
    return cell;
}

@end
