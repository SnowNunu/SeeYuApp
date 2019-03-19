//
//  SYFriendsListVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListVC.h"
#import "SYFriendsList.h"
#import "PinYinForObjc.h"
#import "SYFriendGroupModel.h"
#import "NSMutableArray+FilterElement.h"
#import "SYFriendsListCell.h"
#import "SYFriendModel.h"
#import "SYSearchFriendsResultVC.h"

@interface SYFriendsListVC () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView; // 好友列表视图

@property (nonatomic, strong) NSMutableArray *aliasArray; // 全部好友昵称

@property (nonatomic, strong) NSMutableArray *sectionIndexArray; // 存放字母索引的数组

@property (nonatomic, strong) NSMutableArray *array;    // 重新排序分组后的数据源数组

@property (nonatomic, strong) NSMutableArray *searchList; // 搜索结果的数组

@property (nonatomic, strong) UISearchController *searchFriendsController;  // 好友搜索框

@property (nonatomic, strong) SYSearchFriendsResultVC *searchResultController;  // 好友搜索结果

@end

@implementation SYFriendsListVC

#pragma mark 懒加载部分内容
- (NSMutableArray *)aliasArray {
    if (_aliasArray == nil) {
        _aliasArray = [NSMutableArray new];
    }
    return _aliasArray;
}

- (NSMutableArray *)sectionIndexArray {
    if (_sectionIndexArray == nil) {
        _sectionIndexArray = [NSMutableArray new];
    }
    return _sectionIndexArray;
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
    [self.viewModel.getFriendsListCommand execute:nil];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self _setupSearchController];
}

- (void)bindViewModel {
    @weakify(self)
    [RACObserve(self.viewModel, freshFriendCount) subscribeNext:^(NSString *count) {
        NSLog(@"新的朋友数量：%d",[count intValue]);
    }];
    [RACObserve(self.viewModel, userFriendsArray) subscribeNext:^(NSArray *friendsList) {
        if (friendsList.count > 1) {
            @strongify(self)
            for (NSDictionary *dict in friendsList) {
                [self.aliasArray addObject:dict[@"userFriendName"]];
            }
            for (NSString *string in self.aliasArray) {
                NSString *header = [PinYinForObjc chineseConvertToPinYinHead:string];
                [self.sectionIndexArray addObject:header];
            }
            // 去除数组中相同的元素
            self.sectionIndexArray = [self.sectionIndexArray filterTheSameElement];
            // 数组排序
            [self.sectionIndexArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *string1 = obj1;
                NSString *string2 = obj2;
                return [string1 compare:string2];
            }];
            if ([self.sectionIndexArray[0] isEqualToString:@"#"]) {
                [self.sectionIndexArray replaceObjectAtIndex:0 withObject:@"☆"];
                [self.sectionIndexArray addObject:@"#"];
            } else {
                [self.sectionIndexArray insertObject:@"☆" atIndex:0];
            }
        } else {
            // 用户注册时默认添加红娘为好友
            if (friendsList.count == 0) {
                return;
            }
            [self.sectionIndexArray addObject:@"☆"];
        }
        // 目前已经获得所有的首字母，现在就是需要把全部数据按首字母排序
        NSMutableArray *friendsModelArray = [NSMutableArray new];
        for (NSString *string in self.sectionIndexArray) {
            NSMutableArray *tempArray = [NSMutableArray new];
            if ([string isEqualToString:@"☆"]) {
                [tempArray addObject:@{@"userFriendId": @"10000",@"userFriendName": @"新的朋友",@"userHeadImg":@"icon_newFriend"}];
                for (NSDictionary *dict in friendsList) {
                    if ([dict[@"userFriendName"] isEqualToString:@"红娘客服"]) {
                        [tempArray addObject:dict];
                    }
                }
            } else {
                for (NSDictionary *dict in friendsList) {
                    if ([[PinYinForObjc chineseConvertToPinYinHead:dict[@"userFriendName"]] isEqualToString:string]) {
                        if (![dict[@"userFriendName"] isEqualToString:@"红娘客服"]) {
                            [tempArray addObject:dict];
                        }
                    }
                }
            }
            SYFriendGroupModel *group = [SYFriendGroupModel getGroupsWithArray:tempArray groupTitle:string];
            [friendsModelArray addObject:group];
        }
        self.array = friendsModelArray;
        [self.tableView reloadData];
    }];
}

- (void)_setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)_setupSearchController {
    self.searchResultController = [[SYSearchFriendsResultVC alloc] init];
//    self.searchResultController.delegate = self;
    _searchFriendsController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    _searchFriendsController.delegate = self;
//    _searchController.delegateCustom = self;
    _searchFriendsController.searchResultsUpdater = self;
    _searchFriendsController.dimsBackgroundDuringPresentation = NO;
    _searchFriendsController.hidesNavigationBarDuringPresentation = NO;
    _searchFriendsController.searchBar.delegate = self;
    _searchFriendsController.searchBar.frame = CGRectMake(self.searchFriendsController.searchBar.frame.origin.x, 0, self.searchFriendsController.searchBar.frame.size.width, 50);
    _searchFriendsController.searchBar.placeholder = @"用户昵称";
    _searchFriendsController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchFriendsController.searchBar.returnKeyType = UIReturnKeyDone;
    _searchFriendsController.searchBar.backgroundColor = SYColorFromHexString(@"#9F69EB");
    self.tableView.tableHeaderView = self.searchFriendsController.searchBar;
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SY_APPLICATION_TAB_BAR_HEIGHT);
    }];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchFriendsController.active ? 1 : self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchFriendsController.active) {
        return 0;
    }
    SYFriendGroupModel *group = self.array[section];
    return group.friends.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SYFriendsListCell";
    SYFriendsListCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[SYFriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SYFriendGroupModel *group = self.array[indexPath.section];
    SYFriendModel *friendModel = group.friends[indexPath.row];
    cell.friendId = friendModel.userFriendId;
    cell.aliasLabel.text = friendModel.userFriendName;
    if ([friendModel.userFriendName isEqualToString:@"新的朋友"]) {
        cell.headImageView.image = SYImageNamed(@"icon_newFriend");
    } else if ([friendModel.userFriendName isEqualToString:@"红娘客服"]) {
        cell.headImageView.image = SYImageNamed(@"icon_cusService");
    } else {
        if ([friendModel.userHeadImg sy_isNullOrNil]) {
            cell.headImageView.image = SYImageNamed(@"icon_cusService");
        } else {
            [cell.headImageView yy_setImageWithURL:[NSURL URLWithString:friendModel.userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
        }
    }
    return cell;
}

// 右侧的索引标题数组
- (NSArray *)sectionIndexArrayAtIndexes:(NSIndexSet *)indexes {
    return self.searchFriendsController.active ? nil : self.sectionIndexArray;
}

// 返回cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SYFriendGroupModel *group = self.array[section];
    // 背景图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 42)];
    bgView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    // 显示分区的 label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SY_SCREEN_WIDTH - 40, 42)];
    label.text = group.groupTitle;
    label.font = SYRegularFont(15);
    [bgView addSubview:label];
    return bgView;
}

// 设置表头的高度。如果使用自定义表头，该方法必须要实现，否则自定义表头无法执行，也不会报错
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchFriendsController.active || section == 0) {
        return 0;
    } else {
        return 42;
    }
}

// cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *searchString = [self.searchFriendsController.searchBar text];
    // 移除搜索结果数组的数据
//    [self.searchList removeAllObjects];
//    //过滤数据
//    self.searchList= [SearchResultHandle getSearchResultBySearchText:searchString dataArray:self.dataArray];
//    if (searchString.length==0&&self.searchList!= nil) {
//        [self.searchList removeAllObjects];
//    }
//    self.searchList = [self.searchList filterTheSameElement];
//    NSMutableArray *dataSource = nil;
//    if ([self.searchList count]>0) {
//        dataSource = [NSMutableArray array];
//        // 结局了数据重复的问题
//        for (NSString *str in self.searchList) {
//            FollowModel *model = [[FollowModel alloc] init];
//            model.nickname = str;
//            model.img_Url = nil;
//            [dataSource addObject:model];
//        }
//    }
//    //刷新表格
//    self.searchResultController.dataSource = dataSource;
//    [self.searchResultController.tableView reloadData];
//    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self searchControllerDissmiss];
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [self searchControllerDissmiss];
//}

@end
