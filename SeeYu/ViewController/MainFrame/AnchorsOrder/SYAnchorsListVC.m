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

NSString * const anchorsListCell = @"anchorsListCell";

@interface SYAnchorsListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UIView *bgView;

@end

@implementation SYAnchorsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestAnchorsListCommand execute:nil];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, anchorsArray) subscribeNext:^(NSArray *array) {
        NSLog(@"数组变化了");
        [self.tableView reloadData];
    }];
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    _bgView = bgView;
    [self.view addSubview:bgView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView sy_registerCell:SYAnchorsListCell.class forCellReuseIdentifier:anchorsListCell];
    _tableView = tableView;
    [bgView addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.height.equalTo(self.view).offset(- 40 - SY_APPLICATION_TAB_BAR_HEIGHT);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.anchorsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    SYAnchorsListCell *cell = [tableView dequeueReusableCellWithIdentifier:anchorsListCell forIndexPath:indexPath];
    if(!cell){
        cell = [[SYAnchorsListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:anchorsListCell];
    }
    SYAnchorsModel *model = self.viewModel.anchorsArray[indexPath.row];
    cell.aliasLabel.text = model.userName;
    if (![model.userSignature sy_isNullOrNil]) {
        cell.signatureLabel.text = model.userSignature;
    }
    if (![model.userSpecialty sy_isNullOrNil] && ![model.userSpecialty isEqualToString:@""]) {
        [cell setTipsByHobby:model.userSpecialty];
    }
    [cell setStarsByLevel:model.anchorStarLevel];
    cell.voicePriceLabel.text = [NSString stringWithFormat:@"%@钻石/分钟",model.anchorChatCost];
    cell.onlineStatusImageView.image = model.userOnline == 0 ? SYImageNamed(@"home_icon_offline") : SYImageNamed(@"home_icon_online");
    [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:model.showPhoto] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.8 * SY_SCREEN_WIDTH;
}

@end
