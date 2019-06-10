//
//  SYFriendsListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListVC.h"
#import "SYFriendsList.h"
#import "NSMutableArray+FilterElement.h"
#import "SYFriendsListCell.h"
#import "SYFriendModel.h"
#import "SYSingleChattingVC.h"

@interface SYFriendsListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView; // 好友列表视图

@property (nonatomic, strong) NSMutableArray *firstLetterArray; // 存放字母索引的数组

@property (nonatomic, strong) NSMutableArray *sortedModelArray;    // 重新排序分组后的数据源数组

@end

@implementation SYFriendsListVC

#pragma mark 懒加载部分内容
- (NSMutableArray *)firstLetterArray {
    if (_firstLetterArray == nil) {
        _firstLetterArray = [NSMutableArray new];
    }
    return _firstLetterArray;
}

- (NSMutableArray *)sortedModelArray {
    if (_sortedModelArray == nil) {
        _sortedModelArray = [NSMutableArray new];
    }
    return _sortedModelArray;
}

- (instancetype)initWithViewModel:(SYFriendsListVM *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.getFriendsListCommand execute:nil];
}

- (void)bindViewModel {
    @weakify(self)
    [RACObserve(self.viewModel, userFriendsArray) subscribeNext:^(NSArray<SYFriendModel *> *array) {
        @strongify(self)
        if (array.count > 0) {
            BMChineseSortSetting.share.sortMode = 1;
            BMChineseSortSetting.share.needStable = YES;
            BMChineseSortSetting.share.specialCharPositionIsFront = NO;
            NSMutableArray<SYFriendModel *> *tempArray = [NSMutableArray new];
            NSMutableArray<SYFriendModel *> *sortArray = [NSMutableArray arrayWithArray:array];
            for (SYFriendModel *model in array) {
                if ([model.userFriendName isEqualToString:@"红娘客服"] || [model.userFriendName isEqualToString:@"系统消息"]) {
                    [tempArray addObject:model];
                    [sortArray removeObject:model];
                }
            }
            [BMChineseSort sortAndGroup:[NSArray arrayWithArray:sortArray] key:@"userFriendName" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
                if (isSuccess) {
                    [sectionTitleArr insertObject:@"☆" atIndex:0];
                    self.firstLetterArray = sectionTitleArr;
                    SYFriendModel *model = [SYFriendModel new];
                    model.userFriendName = @"新的朋友";
                    model.userFriendId = @"10000";
                    [tempArray insertObject:model atIndex:0];
                    [sortedObjArr insertObject:tempArray atIndex:0];
                    self.sortedModelArray = sortedObjArr;
                    [self.tableView reloadData];
                }
            }];
        }
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionIndexColor = SYColorAlpha(211, 26, 191, 0.5); // 设置默认时索引值颜色
    [tableView registerClass:[SYFriendsListCell class] forCellReuseIdentifier:@"SYFriendsListCell"];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SY_APPLICATION_TAB_BAR_HEIGHT);
    }];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.firstLetterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortedModelArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYFriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYFriendsListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SYFriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYFriendsListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *array = self.sortedModelArray[indexPath.section];
    SYFriendModel *friendModel = array[indexPath.row];
    cell.friendId = friendModel.userFriendId;
    cell.aliasLabel.text = friendModel.userFriendName;
    cell.bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColorFromHexString(@"#F0CFFF") : SYColorFromHexString(@"#F5DFFF");
    if ([friendModel.userFriendName isEqualToString:@"新的朋友"]) {
        cell.headImageView.image = SYImageNamed(@"icon_newFriend");
        if (self.viewModel.freshFriendCount > 0) {
            cell.badgeView.badgeText = [NSString stringWithFormat:@"%d",self.viewModel.freshFriendCount];
            [cell.badgeView setNeedsLayout];
        } else {
            cell.badgeView.badgeText = nil;
            [cell.badgeView setNeedsLayout];
        }
    } else if ([friendModel.userFriendName isEqualToString:@"红娘客服"]) {
        [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:friendModel.userHeadImg] placeholder:SYImageNamed(@"icon_cusService") options:SYWebImageOptionAutomatic completion:NULL];
        cell.badgeView.badgeText = nil;
        [cell.badgeView setNeedsLayout];
    } else if ([friendModel.userFriendName isEqualToString:@"系统消息"]) {
        [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:friendModel.userHeadImg] placeholder:SYImageNamed(@"icon_systemCall") options:SYWebImageOptionAutomatic completion:NULL];
        cell.badgeView.badgeText = nil;
        [cell.badgeView setNeedsLayout];
    } else {
        if ([friendModel.userHeadImg sy_isNullOrNil]) {
            cell.headImageView.image = SYImageNamed(@"anchor_deafult_image");
        } else {
            if (friendModel.userHeadImgFlag == 1) {
                // 头像审核通过
                [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:friendModel.userHeadImg] placeholder:SYImageNamed(@"anchor_deafult_image") options:SYWebImageOptionAutomatic completion:NULL];
            } else {
                cell.headImageView.image = SYImageNamed(@"anchor_deafult_image");
            }
        }
        cell.badgeView.badgeText = nil;
        [cell.badgeView setNeedsLayout];
    }
    return cell;
}

// 右侧的索引标题数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.firstLetterArray;
}

// 返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text = self.firstLetterArray[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 22.5)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // 显示分区的 label
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = SYFont(16.5,YES);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = SYColorAlpha(211, 26, 191, 0.5);
    [bgView addSubview:label];
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = SYColorAlpha(211, 26, 191, 0.5);
    [bgView addSubview:line];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(24);
        make.centerY.equalTo(bgView);
        make.height.offset(15);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(2);
        make.left.equalTo(label.mas_right).offset(9);
        make.centerY.equalTo(label);
        make.right.equalTo(bgView).offset(-20);
    }];
    return bgView;
}

// 设置表头的高度。如果使用自定义表头，该方法必须要实现，否则自定义表头无法执行，也不会报错
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 22.5;
    }
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = self.sortedModelArray[indexPath.section];
    SYFriendModel *friendModel = array[indexPath.row];
    if ([friendModel.userFriendName isEqualToString:@"新的朋友"]) {
        [self.viewModel.enterNewFriendsViewCommand execute:nil];
    } else {
        SYSingleChattingVC *conversationVC = [[SYSingleChattingVC alloc] init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = friendModel.userFriendId;
        conversationVC.title = friendModel.userFriendName;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

@end
