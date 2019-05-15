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

@property (nonatomic, strong) UILabel *currentYearLabel;

@property (nonatomic, strong) UILabel *currentDayLabel;

@property (nonatomic, strong) UIImageView *uploadImageView;

@end

@implementation SYMyMomentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestAllMineMomentsCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, yearArray) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            [self.tableView reloadData];
        }
    }];
    [self.uploadImageView bk_whenTapped:^{
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZLCustomCamera *camera = [ZLCustomCamera new];
                camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
//                    // 自己需要在这个地方进行图片或者视频的保存
                    SYMomentsEditVM *vm = [[SYMomentsEditVM alloc] initWithServices:self.viewModel.services params:nil];
                    [self.viewModel.enterMomentsEditView execute:vm];
                };
                [self showDetailViewController:camera sender:nil];
            } else if (buttonIndex == 2) {
                ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                actionSheet.configuration.maxSelectCount = 9;
                actionSheet.configuration.maxPreviewCount = 0;
                actionSheet.configuration.allowTakePhotoInLibrary = NO;
                actionSheet.configuration.allowMixSelect = NO;
                actionSheet.configuration.navBarColor = SYColorFromHexString(@"#9F69EB");
                actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                // 选择回调
                [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                    PHAsset *asset = assets[0];
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
    tableView.estimatedRowHeight = 80.f;    // 动态计算行高
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 155)];
    _headerView = headerView;
    tableView.tableHeaderView = headerView;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UILabel *currentYearLabel = [UILabel new];
    currentYearLabel.font = SYRegularFont(32);
    currentYearLabel.textColor = SYColor(51, 51, 51);
    currentYearLabel.textAlignment = NSTextAlignmentLeft;
    currentYearLabel.text = [NSString stringWithFormat:@"%@年",[NSDate sy_currentYear]];
    _currentYearLabel = currentYearLabel;
    [headerView addSubview:currentYearLabel];
    
    UILabel *currentDayLabel = [UILabel new];
    currentDayLabel.font = SYRegularFont(30);
    currentDayLabel.textColor = SYColor(51, 51, 51);
    currentDayLabel.textAlignment = NSTextAlignmentLeft;
    currentDayLabel.text = @"今天";
    _currentDayLabel = currentDayLabel;
    [headerView addSubview:currentDayLabel];
    
    UIImageView *uploadImageView = [UIImageView new];
    uploadImageView.image = SYImageNamed(@"btn_addMoment");
    uploadImageView.userInteractionEnabled = YES;
    _uploadImageView = uploadImageView;
    [headerView addSubview:uploadImageView];
}

- (void)_makeSubViewsConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_currentYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(30);
        make.left.equalTo(self.headerView).offset(15);
        make.height.offset(30);
    }];
    [_currentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentYearLabel);
        make.height.offset(30);
        make.top.equalTo(self.currentYearLabel.mas_bottom).offset(15);
    }];
    [_uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(103);
        make.width.height.offset(80);
        make.top.equalTo(self.currentDayLabel);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.yearArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *year = self.viewModel.yearArray[section];
    NSArray *modelArray = self.viewModel.modelDictionary[year];
    return modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 75.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 75)];
        UILabel *yearLabel = [UILabel new];
        yearLabel.textAlignment = NSTextAlignmentLeft;
        yearLabel.font = [UIFont boldSystemFontOfSize:32];
        yearLabel.textColor = SYColor(51, 51, 51);
        yearLabel.text = [NSString stringWithFormat:@"%@年",self.viewModel.yearArray[section]];
        [view addSubview:yearLabel];
        [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.height.offset(30);
            make.bottom.equalTo(view);
        }];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"momentListCell%ld%ld",indexPath.section,indexPath.row];
    SYMyMomentsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[SYMyMomentsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *year = self.viewModel.yearArray[indexPath.section];
    NSArray *modelArray = self.viewModel.modelDictionary[year];
    SYMomentsModel *model = modelArray[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (![[model.momentTime substringToIndex:10] isEqualToString:[[NSDate sy_currentTimestamp] substringToIndex:10]]) {
            // 首条数据为当天的数据，则不显示月日
            [cell setDayAndMonthLabel:model.momentTime];
        }
    } else if (indexPath.row == 0) {
        // 非当年的首条显示日月
        [cell setDayAndMonthLabel:model.momentTime];
    } else {
        // 判断与上一条的年月日是否相同，不相同再显示
        SYMomentsModel *lastModel = modelArray[indexPath.row - 1];
        if (![[lastModel.momentTime substringToIndex:10] isEqualToString:[model.momentTime substringToIndex:10]]) {
            [cell setDayAndMonthLabel:model.momentTime];
        }
    }
    if (model.momentContent != nil && model.momentContent.length > 0) {
        cell.contentLabel.text = model.momentContent;
    }
    if (model.momentPhotos != nil && model.momentPhotos.length > 0) {
        [cell setPhotosShowView:model.momentPhotos];
    }
    if (model.momentVideo != nil && model.momentVideo.length > 0) {
        [cell setVideoShowView:model.momentVideo];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
