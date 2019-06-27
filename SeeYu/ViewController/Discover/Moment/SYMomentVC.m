//
//  SYMomentVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentVC.h"
#import "SYMomentListCell.h"
#import "SYMomentsModel.h"

@interface SYMomentVC () <UITableViewDelegate, UITableViewDataSource>

@end

NSString * const identifier = @"momentListCellIdentifier";

@implementation SYMomentVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestMomentsCommand execute:@(1)];
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
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            [self.tableView reloadData];
        }
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYMomentListCell class] forCellReuseIdentifier:identifier];
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44.0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    // 添加下拉刷新控件
    @weakify(self);
    [self.tableView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
        /// 加载下拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerHeaderRefresh];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    /// 上拉加载
    [self.tableView sy_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        /// 加载上拉刷新的数据
        @strongify(self);
        [self tableViewDidTriggerFooterRefresh];
    }];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma  mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYMomentListCell *cell = (SYMomentListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SYMomentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SYMomentsModel *model = self.viewModel.datasource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model.userHeadImg != nil && model.userHeadImg.length > 0) {
        [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
    } else {
        cell.headImageView.image = SYWebAvatarImagePlaceholder();
    }
    cell.aliasLabel.text = model.userName;
    cell.contentLabel.text = model.momentContent;
    if (model.momentPhotos != nil && model.momentPhotos.length > 0) {
        [cell _setupPhotosViewByUrls:model.momentPhotos];
    } else {
        [cell emptyPhotosView];
    }
    if (model.momentVideo != nil && model.momentVideo.length > 0) {
        [cell _setupVideoShowViewBy:model.momentVideo];
    } else {
        [cell emptyVideoView];
    }
    cell.timeLabel.text = [NSString compareCurrentTime:model.momentTime];
    cell.block = ^{
        [self openRechargeTipsView];
    };
    return cell;
}

#pragma mark - 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self)
    [[[self.viewModel.requestMomentsCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum = 1;
    } error:^(NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }];
}

#pragma mark - 上拉刷新事件
- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestMomentsCommand execute:@(self.viewModel.pageNum + 1)] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.pageNum += 1;
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    } completed:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
        if (self.viewModel.currentPageValues.count < self.viewModel.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
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

@end
