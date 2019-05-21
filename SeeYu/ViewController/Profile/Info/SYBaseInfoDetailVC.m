//
//  SYBaseInfoDetailVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYBaseInfoDetailVC.h"
#import "SYUserInfoEditModel.h"

@interface SYBaseInfoDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYBaseInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _datasource = @[@{@"propertyName":@"昵称：",@"propertyValue":@"userName"},@{@"propertyName":@"性别：",@"propertyValue":@"userGender"},@{@"propertyName":@"年龄：",@"propertyValue":@"userAge"},@{@"propertyName":@"身高：",@"propertyValue":@"userHeight"},@{@"propertyName":@"体重：",@"propertyValue":@"userWeight"},@{@"propertyName":@"婚姻：",@"propertyValue":@"userMarry"},@{@"propertyName":@"生日：",@"propertyValue":@"userBirthday"},@{@"propertyName":@"学历：",@"propertyValue":@"userEdu"},@{@"propertyName":@"职业：",@"propertyValue":@"userProfession"},@{@"propertyName":@"收入：",@"propertyValue":@"userIncome"},@{@"propertyName":@"星座：",@"propertyValue":@"userConstellation"},@{@"propertyName":@"签名：",@"propertyValue":@"userSignature"},@{@"propertyName":@"爱好：",@"propertyValue":@"userSpecialty"}];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestUserShowInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

- (void)_setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _datasource[indexPath.row];
    NSMutableDictionary *infoParams = [self.viewModel.user mj_keyValues];
    NSString *title = params[@"propertyName"];
    NSString *content = infoParams[params[@"propertyValue"]];
    if ([title isEqualToString:@"爱好："]) {
        content = [content stringByReplacingOccurrencesOfString:@"," withString:@" "];
    }
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = indexPath.row % 2 == 0 ? SYColor(240, 207, 255) : SYColor(245, 223, 255);
    [cell.contentView addSubview:bgView];
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = SYColor(193, 99, 237);
    infoLabel.font = SYFont(12, YES);
    if (content != nil && content.length > 0) {
        infoLabel.text = [NSString stringWithFormat:@"%@%@",title,content];
    } else {
        infoLabel.text = title;
    }
    infoLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:infoLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cell.contentView).offset(2);
        make.right.equalTo(cell.contentView).offset(-2);
        make.bottom.equalTo(cell.contentView);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(20);
        make.height.offset(12);
    }];
    return cell;
}

@end
