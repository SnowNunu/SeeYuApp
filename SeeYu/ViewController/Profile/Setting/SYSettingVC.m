//
//  SYSettingVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/11.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSettingVC.h"
#import "NSObject+SY.h"

@interface SYSettingVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) BOOL notificationState;

@property (nonatomic, assign) BOOL voiceState;

@end

@implementation SYSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@{@"label":@"提醒通知",@"kind":@"switch"},@{@"label":@"免责声明",@"kind":@"arrow"},@{@"label":@"关于我们",@"kind":@"arrow"},@{@"label":@"清理缓存",@"kind":@"label"},@{@"label":@"音效",@"kind":@"switch"}];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    self.notificationState = ![RCIM sharedRCIM].disableMessageNotificaiton;
    self.voiceState = ![RCIM sharedRCIM].disableMessageAlertSound;
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
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
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *params = _dataSource[indexPath.row];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = params[@"label"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = SYRegularFont(16);
    [cell.contentView addSubview:contentLabel];
    
    if ([params[@"kind"] isEqualToString:@"switch"]) {
        UISwitch *mySwitch = [UISwitch new];
        [cell.contentView addSubview:mySwitch];
        [mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
        }];
        if (indexPath.row == 0) {
            mySwitch.on = self.notificationState;
        } else {
            mySwitch.on = self.voiceState;
        }
        [[mySwitch rac_newOnChannel] subscribeNext:^(id x) {
            NSNumber *state = (NSNumber *)x;
            if (indexPath.row == 0) {
                [RCIM sharedRCIM].disableMessageNotificaiton = ![state boolValue];
            } else {
                [RCIM sharedRCIM].disableMessageAlertSound = ![state boolValue];
            }
        }];
    } else if ([params[@"kind"] isEqualToString:@"arrow"]) {
        UIButton *arrowBtn = [UIButton new];
        [arrowBtn setImage:SYImageNamed(@"tableview_arrow") forState:UIControlStateNormal];
        [cell.contentView addSubview:arrowBtn];
        [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.width.offset(7);
            make.height.offset(14);
        }];
    } else {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = SYColor(153, 153, 153);
        label.font = SYRegularFont(12);
        label.text = [NSString stringWithFormat:@"%.2fMB",[self getFolderSize]];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.height.offset(20);
        }];
    }
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.width.offset(80);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(20);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        [self.viewModel.enterDisclaimerViewCommand execute:nil];
    } else if (indexPath.row == 2) {
        [self.viewModel.enterAboutViewCommand execute:nil];
    }  else if (indexPath.row == 3) {
        [NSObject sy_showAlertViewWithTitle:@"" message:@"确定要清除所有的缓存数据吗？" confirmTitle:@"确定" cancelTitle:@"取消" confirmAction:^{
            [self removeCache];
        } cancelAction:^{
            
        }];
    }
}

// 缓存大小
- (CGFloat)getFolderSize {
    CGFloat folderSize = 0.f;
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",files.count);
    for(NSString *path in files) {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        //累加
        folderSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    return folderSize /1024.0/1024.0;
}

- (void)removeCache {
    //===============清除缓存==============
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    //返回路径中的文件数组
    NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                [MBProgressHUD sy_showTips:@"缓存清除成功"];
                [self.tableView reloadData];
            } else {
                NSLog(@"清除失败");
                [MBProgressHUD sy_showTips:@"缓存清除失败"];
            }
        }
    }
}

@end
