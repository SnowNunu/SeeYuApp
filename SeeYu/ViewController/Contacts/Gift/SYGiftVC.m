//
//  SYGiftVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftVC.h"
#import "SYDiamondsVC.h"
#import "SYDiamondsVM.h"

static NSString *reuseIdentifier = @"giftListCellIdentifier";

@interface SYGiftVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *diamondsLabel;

@property (nonatomic, strong) UIButton *rechargeBtn;

@property (nonatomic, strong) UIButton *sendGiftBtn;

@property (nonatomic, strong) UICollectionView *giftsCollectionView;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SYGiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestGiftsListCommand execute:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;  // 这里需要先关闭，不然会导致单聊界面错乱
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user != nil) {
            self.diamondsLabel.text = [NSString stringWithFormat:@"我的钻石：%d",user.userDiamond];
        }
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(id x) {
        [self.giftsCollectionView reloadData];
    }];
    [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.block) {
                self.block();
            }
            [SYSharedAppDelegate dismissVC:self];
        });
    }];
    [[self.sendGiftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectIndex == 0) {
            [MBProgressHUD sy_showTips:@"请先选择一个礼物" addedToView:self.view];
        } else {
            int leftDiamonds = self.viewModel.user.userDiamond;
            NSDictionary *params = self.viewModel.datasource[self.selectIndex - 958];
            SYGiftListModel *model = [SYGiftListModel yy_modelWithDictionary:params];
            int price = model.giftPrice;
            if (leftDiamonds > price) {
                NSDictionary *parmas = @{@"userId":self.viewModel.services.client.currentUser.userId,@"receiveUserId":self.viewModel.friendId,@"giftId":[NSString stringWithFormat:@"%d",model.giftId],@"giftNumber":@"1"};
                [self.viewModel.sendGiftCommand execute:parmas];
            } else {
                [MBProgressHUD sy_showTips:@"剩余钻石数量不足，请先进行充值" addedToView:self.view];
            }
        }
    }];
    [self.viewModel.sendGiftCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYUser *user) {
        self.viewModel.user = user;
        [self.viewModel.services.client saveUser:user];
        [MBProgressHUD sy_showTips:@"礼物赠送成功" addedToView:self.view];
    }];
    [self.viewModel.sendGiftCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error addedToView:self.view];
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
    bgView.layer.cornerRadius = 15.f;
    bgView.layer.masksToBounds = YES;
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UILabel *diamondsLabel = [UILabel new];
    diamondsLabel.textAlignment = NSTextAlignmentLeft;
    diamondsLabel.textColor = SYColorFromHexString(@"#9F69EB");
    diamondsLabel.font =SYRegularFont(16);
    diamondsLabel.text = [NSString stringWithFormat:@"我的钻石：%d",self.viewModel.user.userDiamond];
    _diamondsLabel = diamondsLabel;
    [bgView addSubview:diamondsLabel];
    
    UIButton *rechargeBtn = [UIButton new];
    rechargeBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = SYRegularFont(16);
    rechargeBtn.layer.cornerRadius = 12.5f;
    rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn = rechargeBtn;
    [bgView addSubview:rechargeBtn];
    
    CGFloat btnWidth = (SY_SCREEN_WIDTH - 15 * 7) / 4;
    CGFloat btnHeight = 1.45 * btnWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20; // 最小行间距
    layout.minimumInteritemSpacing = 15; // 最小左右间距
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(btnWidth, btnHeight);
    
    UICollectionView *giftsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    giftsCollectionView.delegate = self;
    giftsCollectionView.dataSource = self;
    giftsCollectionView.backgroundColor = [UIColor whiteColor];
    [giftsCollectionView registerClass:[SYGiftListCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _giftsCollectionView = giftsCollectionView;
    [bgView addSubview:giftsCollectionView];
    
    UIButton *sendGiftBtn = [UIButton new];
    sendGiftBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [sendGiftBtn setTitle:@"赠送" forState:UIControlStateNormal];
    [sendGiftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendGiftBtn.titleLabel.font = SYRegularFont(17);
    _sendGiftBtn = sendGiftBtn;
    [bgView addSubview:sendGiftBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat btnWidth = (SY_SCREEN_WIDTH - 15 * 7) / 4;
    CGFloat btnHeight = 1.45 * btnWidth;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.rechargeBtn.mas_top).offset(-10);
    }];
    [_diamondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rechargeBtn);
        make.left.equalTo(self.bgView).offset(15);
        make.height.offset(20);
    }];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.width.offset(60);
        make.height.offset(25);
        make.bottom.equalTo(self.giftsCollectionView.mas_top).offset(-10);
    }];
    [_giftsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.sendGiftBtn.mas_top);
        make.height.offset(btnHeight * 2 + 20 * 2);
    }];
    [_sendGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.left.equalTo(self.bgView);
        make.height.offset(35);
    }];
}

#pragma mark UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftListCell * cell = (SYGiftListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 获取model
    NSDictionary *params = self.viewModel.datasource[indexPath.row];
    SYGiftListModel *model = [SYGiftListModel yy_modelWithDictionary:params];
    [[cell.giftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self selectGift:indexPath.row];
    }];
    cell.giftBtn.selected = self.selectIndex == indexPath.row + 958;
    
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:model.giftImg] placeholder:[UIImage imageWithColor:[UIColor whiteColor]] options:SYWebImageOptionAutomatic completion:NULL];
    cell.priceLabel.text = [NSString stringWithFormat:@"%d钻石",model.giftPrice];
    cell.titleLabel.text = model.giftName;
    return cell;
}

// 选择礼物
- (void)selectGift:(NSInteger)tag {
    self.selectIndex = tag + 958;
    [self.giftsCollectionView reloadData];
}

@end
