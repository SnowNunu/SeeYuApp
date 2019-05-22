//
//  SYDiamondsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYDiamondsVC.h"
#import "WebChatPayH5VIew.h"

@interface SYDiamondsVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerBgView;

@property (nonatomic, strong) UIImageView *topLineView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *bottomLineView;

@property (nonatomic, strong) UILabel *diamondsLabel;

@property (nonatomic, strong) UILabel *diamondsNumberLabel;

@end

@implementation SYDiamondsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestDiamondsPriceInfoCommand execute:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
//    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user.userDiamond > 0) {
            self.diamondsNumberLabel.text = [NSString stringWithFormat:@"%d",user.userDiamond];
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
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 120)];
    _headerBgView = headerBgView;
    tableView.tableHeaderView = headerBgView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIImageView *topLineView = [UIImageView new];
    topLineView.backgroundColor = SYColorFromHexString(@"#F7D6F4");
    _topLineView = topLineView;
    [headerBgView addSubview:topLineView];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = SYImageNamed(@"diamond_bg");
    _bgImageView = bgImageView;
    [headerBgView addSubview:bgImageView];
    
    UIImageView *bottomLineView = [UIImageView new];
    bottomLineView.backgroundColor = SYColorFromHexString(@"#F7D6F4");
    _bottomLineView = bottomLineView;
    [headerBgView addSubview:bottomLineView];
    
    UILabel *diamondsLabel = [UILabel new];
    diamondsLabel.textColor = SYColor(193, 99, 237);
    diamondsLabel.textAlignment = NSTextAlignmentLeft;
    diamondsLabel.font = SYFont(13, YES);
    diamondsLabel.text = @"您的钻石余额：";
    _diamondsLabel = diamondsLabel;
    [headerBgView addSubview:diamondsLabel];
    
    UILabel *diamondsNumberLabel = [UILabel new];
    diamondsNumberLabel.textColor = SYColor(193, 99, 237);
    diamondsNumberLabel.textAlignment = NSTextAlignmentCenter;
    diamondsNumberLabel.font = SYFont(25, YES);
    diamondsNumberLabel.text = @"0";
    _diamondsNumberLabel = diamondsNumberLabel;
    [headerBgView addSubview:diamondsNumberLabel];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBgView).offset(5);
        make.centerX.equalTo(self.headerBgView);
        make.height.offset(1);
        make.width.equalTo(self.headerBgView).offset(-20);
    }];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.bottomLineView.mas_top).offset(-5);
        make.centerX.equalTo(self.headerBgView);
        make.width.equalTo(self.headerBgView).offset(-5);
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.topLineView);
        make.bottom.equalTo(self.headerBgView).offset(-4);
    }];
    [_diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgImageView).offset(6);
        make.height.offset(15);
    }];
    [_diamondsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgImageView);
        make.height.offset(25);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SYGoodsModel *model = self.viewModel.datasource[indexPath.row];
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColorFromHexString(@"#F0CFFF") : SYColorFromHexString(@"#F5DFFF");
    [cell.contentView addSubview:bgView];
    
    UIImageView *diamondsImageView = [UIImageView new];
    diamondsImageView.image = SYImageNamed(@"diamond");
    [cell.contentView addSubview:diamondsImageView];
    
    UILabel *diamondsAmountLabel = [UILabel new];
    diamondsAmountLabel.textAlignment = NSTextAlignmentLeft;
    diamondsAmountLabel.textColor = SYColor(193, 99, 237);
    diamondsAmountLabel.text = model.goodsName;
    diamondsAmountLabel.font = SYFont(15, YES);
    [cell.contentView addSubview:diamondsAmountLabel];
    
    UILabel *diamondsPriceLabel = [UILabel new];
    diamondsPriceLabel.textAlignment = NSTextAlignmentRight;
    diamondsPriceLabel.textColor = SYColor(193, 99, 237);
    diamondsPriceLabel.text = [NSString stringWithFormat:@"￥%@元",model.goodsMoney];
    diamondsPriceLabel.font = SYFont(15, YES);
    [cell.contentView addSubview:diamondsPriceLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(4);
        make.left.equalTo(cell.contentView).offset(2);
        make.right.equalTo(cell.contentView).offset(-2);
        make.bottom.equalTo(cell.contentView);
    }];
    [diamondsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.width.height.offset(20);
        make.left.equalTo(bgView).offset(12);
    }];
    [diamondsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.height.offset(15);
        make.left.equalTo(diamondsImageView.mas_right).offset(10);
    }];
    [diamondsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-20);
        make.height.offset(15);
        make.centerY.equalTo(diamondsAmountLabel);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGoodsModel *model = self.viewModel.datasource[indexPath.row];
    NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUserId,@"goodsId":model.goodsId,@"rechargeType":@"1"};
    [self.viewModel.requestPayInfoCommand execute:params];
}

@end
