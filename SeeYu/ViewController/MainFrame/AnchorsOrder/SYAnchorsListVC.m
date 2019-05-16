//
//  SYAnchorsListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsListVC.h"
#import "SYAnchorsListCell.h"
#import "SYAnchorsModel.h"
#import "UIScrollView+SYRefresh.h"

NSString * const anchorsListCell = @"anchorsListCell";

@interface SYAnchorsListVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDict;

@end

@implementation SYAnchorsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellIdentifierDict = [NSMutableDictionary new];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestAnchorsListCommand execute:@"1"];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, anchorsArray) subscribeNext:^(NSArray *array) {
        [self.collectionView reloadData];
    }];
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.f;    // 上下间距
    layout.minimumInteritemSpacing = 3.f;   // 左右间距
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;   // 垂直滚动
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = self.view.backgroundColor;
    [collectionView registerClass:[SYAnchorsListCell class] forCellWithReuseIdentifier:anchorsListCell];
    _collectionView = collectionView;
    [bgView addSubview:collectionView];
    
    // 添加下拉刷新控件
    @weakify(self);
    [_collectionView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerHeaderRefresh];
    }];
    [_collectionView.mj_header beginRefreshing];
    
    /// 上拉加载
    [_collectionView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerFooterRefresh];
    }];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(5);
        make.right.equalTo(self.bgView).offset(-5);
    }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.anchorsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = SY_SCREEN_WIDTH - 10;
    if (indexPath.row == 0) {
        return CGSizeMake(width , width * 0.55);
    } else {
        return CGSizeMake((width - 3) / 2, width * 0.55);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYAnchorsListCell * cell = (SYAnchorsListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:anchorsListCell forIndexPath:indexPath];
    SYAnchorsModel *model = self.viewModel.datasource[indexPath.row];
    cell.voicePriceLabel.text = [NSString stringWithFormat:@"%@/分钟",model.anchorChatCost];
    cell.onlineStatusImageView.image = model.userOnline == 0 ? SYImageNamed(@"busy") : SYImageNamed(@"online");
    if (![model.userSpecialty sy_isNullOrNil] && ![model.userSpecialty isEqualToString:@""]) {
        [cell setTipsByHobby:model.userSpecialty];
    }
    [cell setScrollAliasLabel:model.userName];
    [cell setStarsByLevel:model.anchorStarLevel];

    
    [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:model.showPhoto] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    return cell;
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestAnchorsListCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
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
- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestAnchorsListCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
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
