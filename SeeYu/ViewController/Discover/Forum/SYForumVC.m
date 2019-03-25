//
//  SYForumVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumVC.h"
#import "SYForumListCell.h"
#import "SYForumModel.h"

@interface SYForumVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYForumVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                /// 请求第一页的网络数据
                [self.viewModel.requestForumsCommand execute:@1];
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
    @weakify(self)
    [[RACObserve(self.viewModel, datasource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYForumListCell class] forCellReuseIdentifier:@"forumListCell"];
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
    SYForumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SYForumListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumListCell"];
    }
    SYForumModel *model = self.viewModel.datasource[indexPath.row];
    cell.titleLabel.text = model.forumTitle;
    cell.contentLabel.text = model.forumContent;
    cell.commentsNumLabel.text = model.counts;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYForumModel *model = self.viewModel.datasource[indexPath.row];
    NSDictionary *params = @{SYViewModelUtilKey:[model yy_modelToJSONObject]};
    [self.viewModel.enterForumsDetailViewCommand execute:params];
}

@end
