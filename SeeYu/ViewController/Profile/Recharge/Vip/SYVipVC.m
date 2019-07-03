//
//  SYVipVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVipVC.h"

@interface SYVipVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *rightImagesArray;

@property (nonatomic, strong) NSArray *rightTextsArray;

@property (nonatomic, assign) BOOL auditPass;

@end

@implementation SYVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _rightImagesArray = @[@"match",@"chat",@"private",@"checkin",@"vipMark",@"anchor"];
    _rightTextsArray = @[@"速配特权",@"开心畅聊",@"私密预览",@"签到奖励",@"尊贵标识",@"主播观看"];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if ([cache containsObjectForKey:@"auditPass"]) {
        // 有缓存数据优先读取缓存数据
        self.auditPass = [(NSString *)[cache objectForKey:@"auditPass"] isEqualToString:@"1"];
    } else {
        self.auditPass = NO;
    }
    [self loadDatasourceByAuditPassState];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorInset = UIEdgeInsetsZero;
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 10)];
//    _headerView = headerView;
//    tableView.tableHeaderView = headerView;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadDatasourceByAuditPassState {
//    if (_auditPass) {
    [self.viewModel.requestVipPriceInfoCommand execute:nil];
//    } else {
//        NSArray *namesArr = @[@"一个月",@"六个月",@"终身"];
//        NSArray *pricesArr = @[@"68",@"93",@"98"];
//        NSArray *productIdArr = @[@"com.xm.lovemiyue.vip.one",@"com.xm.lovemiyue.vip.six",@"com.xm.lovemiyue.vip.lifelong"];
//        NSMutableArray *tempArr = [NSMutableArray new];
//        for (int i = 0; i < 3; i++) {
//            SYGoodsModel *model = [SYGoodsModel new];
//            model.goodsId = [NSString stringWithFormat:@"%d",i + 1];
//            model.goodsName = namesArr[i];
//            model.goodsMoney = pricesArr[i];
//            model.productId = productIdArr[i];
//            [tempArr addObject:model];
//        }
//        self.viewModel.datasource = [NSArray arrayWithArray:tempArr];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 125.f;
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
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.layer.cornerRadius = 8.f;
    bgImageView.layer.masksToBounds = YES;
    bgImageView.image = SYImageNamed(@"vip_eachItem_bg");
    [cell.contentView addSubview:bgImageView];
    
    UILabel *vipTimeLabel = [UILabel new];
    vipTimeLabel.textAlignment = NSTextAlignmentLeft;
    vipTimeLabel.textColor = SYColor(255, 255, 255);
    vipTimeLabel.text = model.goodsName;
    vipTimeLabel.font = SYFont(18, YES);
    [bgImageView addSubview:vipTimeLabel];
    
    UIView *vipPriceBgView = [UIView new];
    vipPriceBgView.backgroundColor = SYColor(205, 132, 197);
    vipPriceBgView.layer.masksToBounds = YES;
    vipPriceBgView.layer.cornerRadius = 10.f;
    [bgImageView addSubview:vipPriceBgView];
    
    UILabel *vipPriceLabel = [UILabel new];
    vipPriceLabel.textAlignment = NSTextAlignmentCenter;
    vipPriceLabel.textColor = SYColor(255, 255, 255);
    vipPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.goodsMoney];
    vipPriceLabel.font = SYFont(12, YES);
    [vipPriceBgView addSubview:vipPriceLabel];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(2);
        make.right.equalTo(cell.contentView).offset(-2);
        make.bottom.equalTo(cell.contentView).offset(-3);
    }];
    [vipTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgImageView);
        make.height.offset(20);
        make.left.equalTo(bgImageView).offset(20);
    }];
    [vipPriceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(64);
        make.height.offset(20);
        make.centerY.equalTo(bgImageView);
        make.right.equalTo(bgImageView).offset(-9);
    }];
    [vipPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(vipPriceBgView);
        make.height.offset(15);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGoodsModel *model = self.viewModel.datasource[indexPath.row];
    [self openPayView:model];
//    if (_auditPass) {
//        [self openPayView:model];
//    } else {
//        [[RMStore defaultStore] addPayment:model.productId success:^(SKPaymentTransaction *transaction) {
//            NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
//            NSData *receipt;
//            receipt = [NSData dataWithContentsOfURL:receiptUrl];
//
//            NSString *transReceipt = [receipt base64EncodedStringWithOptions:0];
//
//            NSLog(@"transReceipt = %@", transReceipt);
//            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"购买成功", @"") message:[NSString stringWithFormat:@"transReceipt = %@", transReceipt] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//            [alerView show];
//        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
//
//        }];
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 10)];
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    [view addSubview:lineImageView];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view).offset(6);
        make.height.offset(1);
    }];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 60)];
    
    UIImageView *lineTop = [UIImageView new];
    lineTop.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    [view addSubview:lineTop];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.font = SYFont(12, YES);
    tipsLabel.textColor = SYColor(193, 99, 237);
    tipsLabel.text = @"特殊权限：";
    [view addSubview:tipsLabel];
    
    CGFloat margin = (SY_SCREEN_WIDTH - 50 * _rightTextsArray.count) / (_rightTextsArray.count + 1);
    for (int i = 0; i < _rightTextsArray.count; i++) {
        UIImageView *icon = [UIImageView new];
        icon.image = SYImageNamed(_rightImagesArray[i]);
        [view addSubview:icon];
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SYColor(193, 99, 237);
        label.font = SYFont(10, YES);
        label.text = _rightTextsArray[i];
        [view addSubview:label];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(50);
            make.left.equalTo(view).offset(margin + (margin + 50) * i);
            make.top.equalTo(tipsLabel.mas_bottom).offset(9);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).offset(9);
            make.centerX.equalTo(icon);
            make.height.offset(12);
        }];
    }
    
    UIImageView *lineBottom = [UIImageView new];
    lineBottom.backgroundColor = SYColorFromHexString(@"#F6D1F2");
    [view addSubview:lineBottom];
    
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.right.equalTo(view).offset(-10);
        make.top.equalTo(view);
        make.height.offset(1);
    }];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTop.mas_bottom).offset(9);
        make.left.equalTo(view).offset(12);
        make.height.offset(12);
    }];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(lineTop);
        make.top.equalTo(tipsLabel.mas_bottom).offset(100);
    }];
    return view;
}

// 打开支付通道选择页面
- (void)openPayView:(SYGoodsModel *)model {
    SYPayVM *payVM = [[SYPayVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:model}];
    SYPayVC *payVC = [[SYPayVC alloc] initWithViewModel:payVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:payVC withAnimation:animation];
}

@end
