//
//  SYPrivacyVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYPrivacyVC.h"
#import "UIScrollView+SYRefresh.h"

@interface SYPrivacyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SYPrivacyVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestPrivacyCommand execute:@"1"];
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            [self.collectionView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SY_SCREEN_WIDTH - 14) / 2;
    layout.itemSize = CGSizeMake(width, width * 0.9);
    layout.minimumLineSpacing = 4.f;
    layout.minimumInteritemSpacing = 4.f;
    layout.sectionInset = UIEdgeInsetsMake(4, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"privacyViewCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    // 添加下拉刷新控件
    @weakify(self);
    [_collectionView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self collectionViewDidTriggerHeaderRefresh];
    }];
    [_collectionView.mj_header beginRefreshing];
    
    /// 上拉加载
    [_collectionView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self collectionViewDidTriggerFooterRefresh];
    }];
}

- (void)_makeSubViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
// 分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYPrivacyModel *model = self.viewModel.datasource[indexPath.row];
    static NSString *cellIndentifer = @"privacyViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    
    // 展示图片
    UIImageView *photoShowView = [UIImageView new];
    photoShowView.layer.cornerRadius = 6.f;
    photoShowView.contentMode = UIViewContentModeScaleAspectFill;
    photoShowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [photoShowView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    photoShowView.clipsToBounds = YES;
    [photoShowView yy_setImageWithURL:[NSURL URLWithString:model.showPhoto] placeholder:SYImageNamed(@"errorPic") options:SYWebImageOptionAutomatic completion:NULL];
    [cell.contentView addSubview:photoShowView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurEffectView.frame = cell.contentView.bounds;
    if (![self judgeVipStatus]) {
        if (indexPath.row > 1) {
            [photoShowView addSubview:blurEffectView];
        }
    }

    // 播放图标
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"play");
    [photoShowView addSubview:playImageView];
    
    //底部背景
    UIView *shadowBgView = [UIView new];
    shadowBgView.backgroundColor = SYColorAlpha(83, 16, 114, 0.3);
    [photoShowView addSubview:shadowBgView];
    
    // 昵称文本
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.text = model.userName;
    aliasLabel.font = SYFont(11, YES);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    [shadowBgView addSubview:aliasLabel];
    
    [photoShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(photoShowView).offset(6);
        make.width.offset(19);
        make.height.offset(19);
    }];
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell.contentView);
        make.height.offset(22);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shadowBgView).offset(6);
        make.centerY.equalTo(shadowBgView);
        make.height.offset(15);
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self judgeVipStatus]) {
        if (indexPath.row > 1) {
            [self openRechargeTipsView];
            return;
        }
    }
    SYPrivacyModel *model = self.viewModel.datasource[indexPath.row];
    NSDictionary *params = @{SYViewModelUtilKey:[model yy_modelToJSONObject]};
    [self.viewModel.enterPrivacyShowViewCommand execute:params];
}

// 判断当前会员状态
- (BOOL)judgeVipStatus {
    SYUser *user = self.viewModel.services.client.currentUser;
    if (user.userVipStatus == 1) {
        if (user.userVipExpiresAt != nil) {
            if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                // 会员已过期的情况
                return NO;
            } else {
                // 会员未过期
                return YES;
            }
        } else {
            return NO;
        }
    } else {
        // 未开通会员
        return NO;
    }
}

// 打开权限弹窗
- (void)openRechargeTipsView {
    SYPopViewVM *popVM = [[SYPopViewVM alloc] initWithServices:self.viewModel.services params:nil];
    popVM.type = @"vip";
    SYPopViewVC *popVC = [[SYPopViewVC alloc] initWithViewModel:popVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:popVC withAnimation:animation];
}

#pragma mark - 下拉刷新事件
- (void)collectionViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestPrivacyCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum = 1;
        [self.collectionView.mj_footer resetNoMoreData];
    } error:^(NSError *error) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
    }];
}

#pragma mark - 上拉刷新事件
- (void)collectionViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestPrivacyCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum += 1;
    } error:^(NSError *error) {
        @strongify(self);
        [self.collectionView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}

@end
