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
    [RACObserve(self.viewModel, datasource) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYMomentListCell class] forCellReuseIdentifier:@"momentListCell"];
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44.0;
    _tableView = tableView;
    [self.view addSubview:tableView];
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
    //填充视频数据
    SYMomentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SYMomentListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"momentListCell"];
    }
    SYMomentsModel *model = self.viewModel.datasource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
    cell.aliasLabel.text = model.userName;
    cell.contentLabel.text = model.momentContent;
    if (model.momentPhotos != nil && model.momentPhotos.length > 0) {
        [cell _setupPhotosViewByUrls:model.momentPhotos];
    }
    cell.timeLabel.text = [NSString compareCurrentTime:model.momentTime];
    return cell;
}

@end
