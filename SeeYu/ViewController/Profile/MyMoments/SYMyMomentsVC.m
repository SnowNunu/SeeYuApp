//
//  SYMyMomentsVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMyMomentsVC.h"
#import "SYMyMomentsListCell.h"
#import "SYMomentsEditVM.h"

@interface SYMyMomentsVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *headerBgView;

@property (nonatomic, strong) UILabel *currentYearLabel;

@property (nonatomic, strong) UILabel *currentDayLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIImageView *uploadImageView;

@end

@implementation SYMyMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.requestAllMineMomentsCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            [self.tableView reloadData];
        }
    }];
    [self.uploadImageView bk_whenTapped:^{
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZLCustomCamera *camera = [ZLCustomCamera new];
                camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                    SYMomentsEditVM *vm = [[SYMomentsEditVM alloc] initWithServices:self.viewModel.services params:nil];
                    if (image != nil) {
                        vm.type = @"images";
                        vm.imagesArray = @[image];
                    } else if (videoUrl != nil) {
                        vm.type = @"video";
                        vm.videoContentUrl = videoUrl;
                    }
                    [self.viewModel.enterMomentsEditView execute:vm];
                };
                [self showDetailViewController:camera sender:nil];
            } else if (buttonIndex == 2) {
                ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                actionSheet.configuration.maxSelectCount = 9;
                actionSheet.configuration.maxPreviewCount = 0;
                actionSheet.configuration.allowTakePhotoInLibrary = NO;
                actionSheet.configuration.allowMixSelect = NO;
                actionSheet.configuration.navBarColor = SYColorFromHexString(@"#6B35DC");
                actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                // 选择回调
                [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                    PHAsset *asset = assets.firstObject;
                    SYMomentsEditVM *vm = [[SYMomentsEditVM alloc] initWithServices:self.viewModel.services params:nil];
                    if (asset.mediaType == PHAssetMediaTypeVideo) {
                        vm.type = @"video";
                    } else {
                        vm.type = @"images";
                    }
                    vm.imagesArray = images;
                    vm.assetArray = assets;
                    vm.cellIsFull = images.count == 9 ? YES : NO;
                    [self.viewModel.enterMomentsEditView execute:vm];
                }];
                
                // 调用相册
                [actionSheet showPhotoLibraryWithSender:self];
            } else {
                return;
            }
        } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
        [sheet show];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44.0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SYMyMomentsListCell class] forCellReuseIdentifier:@"myMomentsListCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 120)];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIView *headerBgView = [UIView new];
    headerView.layer.cornerRadius = 10.f;
    headerView.layer.masksToBounds = YES;
    headerBgView.backgroundColor = SYColorFromHexString(@"#F0CFFF");
    _headerBgView = headerBgView;
    [headerView addSubview:headerBgView];
    
    UILabel *currentYearLabel = [UILabel new];
    currentYearLabel.font = SYFont(14,YES);
    currentYearLabel.textColor = SYColor(193, 99, 237);
    currentYearLabel.textAlignment = NSTextAlignmentLeft;
    currentYearLabel.text = [NSString stringWithFormat:@"%@年",[NSDate sy_currentYear]];
    _currentYearLabel = currentYearLabel;
    [headerView addSubview:currentYearLabel];
    
    UILabel *currentDayLabel = [UILabel new];
    currentDayLabel.font = SYFont(13,YES);
    currentDayLabel.textColor = SYColor(193, 99, 237);
    currentDayLabel.textAlignment = NSTextAlignmentLeft;
    currentDayLabel.text = @"今天";
    _currentDayLabel = currentDayLabel;
    [headerView addSubview:currentDayLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.font = SYFont(13,YES);
    tipsLabel.textColor = SYColor(193, 99, 237);
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.text = @"发布新的动态";
    _tipsLabel = tipsLabel;
    [headerView addSubview:tipsLabel];
    
    UIImageView *uploadImageView = [UIImageView new];
    uploadImageView.image = SYImageNamed(@"add_moment");
    uploadImageView.userInteractionEnabled = YES;
    _uploadImageView = uploadImageView;
    [headerView addSubview:uploadImageView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(2);
        make.left.equalTo(self.headerView).offset(2);
        make.right.equalTo(self.headerView).offset(-2);
        make.bottom.equalTo(self.headerView);
    }];
    [_currentYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBgView).offset(10);
        make.left.equalTo(self.headerBgView).offset(10);
        make.height.offset(15);
    }];
    [_currentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.currentYearLabel);
        make.height.offset(15);
        make.top.equalTo(self.currentYearLabel.mas_bottom).offset(5);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentYearLabel.mas_right).offset(10);
        make.centerY.height.equalTo(self.currentYearLabel);
    }];
    [_uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsLabel);
        make.width.height.offset(80);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(5);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 110.f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYMyMomentsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMomentsListCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[SYMyMomentsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myMomentsListCell"];
    }
    SYMomentsModel *model = self.viewModel.datasource[indexPath.row];
    cell.aliasLabel.text = self.viewModel.services.client.currentUser.userName;
    if (model.momentTime != nil && model.momentTime.length > 0) {
        cell.yearLabel.text = [NSString stringWithFormat:@"%@年",[model.momentTime substringToIndex:4]];
        if ([[model.momentTime substringToIndex:10] isEqualToString:[[NSDate sy_currentTimestamp] substringToIndex:10]]) {
            // 首条数据为当天的数据，则不显示月日
            cell.dayLabel.text = @"今日";
            cell.monthLabel.text = @"";
        } else {
            cell.dayLabel.text = [model.momentTime substringWithRange:NSMakeRange(8, 2)];
            cell.monthLabel.text = [NSString stringWithFormat:@"%@月",[model.momentTime substringWithRange:NSMakeRange(5, 2)]];
        }
        cell.timeLabel.text = [NSString compareCurrentTime:model.momentTime];
    } else {
        cell.yearLabel.text = @"";
        cell.dayLabel.text = @"";
        cell.monthLabel.text = @"";
        cell.timeLabel.text = @"";
    }
    if (model.momentContent != nil && model.momentContent.length > 0) {
        cell.contentLabel.text = model.momentContent;
    } else {
        cell.contentLabel.text = @"";
    }
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
