//
//  SYCommonVC.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYCommonVC.h"
#import "SYCommonHeaderView.h"
#import "SYCommonFooterView.h"
#import "SYCommonCell.h"

@interface SYCommonVC ()
/// viewModel
@property (nonatomic, readwrite, strong) SYCommonViewModel *viewModel;
@end

@implementation SYCommonVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override
- (void)bindViewModel{
    [super bindViewModel];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(SY_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

- (void)configureCell:(SYCommonCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [SYCommonCell cellWithTableView:tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.itemViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /// fetch cell
    SYCommonCell *cell = (SYCommonCell *)[self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
    id object = groupViewModel.itemViewModels[indexPath.row];
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    [cell setIndexPath:indexPath rowsInSection:groupViewModel.itemViewModels.count];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SYCommonFooterView *footerView = [SYCommonFooterView footerViewWithTableView:tableView];
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [footerView bindViewModel:groupViewModel];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SYCommonHeaderView *headerView = [SYCommonHeaderView headerViewWithTableView:tableView];
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [headerView bindViewModel:groupViewModel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
    SYCommonItemViewModel *itemViewModel = groupViewModel.itemViewModels[indexPath.row];
    return itemViewModel.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SYCommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    return groupViewModel.footerHeight;
}
@end
