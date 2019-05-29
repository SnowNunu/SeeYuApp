//
//  SYVideoInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVideoInfoEditVC.h"

@interface SYVideoInfoEditVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *modifyVideoBtn;

@end

@implementation SYVideoInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestUserShowInfoCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, model) subscribeNext:^(SYUserInfoEditModel *model) {
        @strongify(self)
        if (model != nil && ![model.showVideo isEqualToString:@""]) {
            if (model.showVideo == nil || model.showVideo.length == 0) {
                self.tipsLabel.hidden = NO;
                self.playBtn.hidden = YES;
                [self.modifyVideoBtn setTitle:@"添加视频" forState:UIControlStateNormal];
            } else {
                if ([model.showVideoStatus isEqualToString:@"2"]) {
                    self.tipsLabel.hidden = NO;
                    self.playBtn.hidden = YES;
                    [self.modifyVideoBtn setTitle:@"修改视频" forState:UIControlStateNormal];
                    self.videoImageView.image = SYImageNamed(@"add_image");
                    [MBProgressHUD sy_showError:@"视频审核不通过，请重新上传"];
                } else {
                    self.tipsLabel.hidden = YES;
                    self.playBtn.hidden = NO;
                    [self.modifyVideoBtn setTitle:@"修改视频" forState:UIControlStateNormal];
                    self.videoImageView.image = [UIImage sy_thumbnailImageForVideo:[NSURL URLWithString:model.showVideo] atTime:1];
                }
            }
        }
    }];
    [[self.modifyVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.model.showVideo == nil || ![self.viewModel.model.showVideoStatus isEqualToString:@"0"]) {
            @strongify(self)
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) return ;
                if (buttonIndex == 1) {
                    // 拍摄
                    ZLCustomCamera *camera = [ZLCustomCamera new];
                    camera.allowTakePhoto = NO;
                    camera.allowRecordVideo = YES;
                    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                        self.tipsLabel.hidden = YES;
                        [self.viewModel.uploadUserVideoCommand execute:[NSData dataWithContentsOfURL:videoUrl]];
                    };
                    [self showDetailViewController:camera sender:nil];
                } else {
                    // 相册
                    ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                    actionSheet.configuration.maxSelectCount = 1;
                    actionSheet.configuration.maxPreviewCount = 0;
                    actionSheet.configuration.allowTakePhotoInLibrary = NO;
                    actionSheet.configuration.allowMixSelect = NO;
                    actionSheet.configuration.allowSelectImage = NO;
                    actionSheet.configuration.allowSelectGif = NO;
                    actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
                    actionSheet.configuration.navBarColor = SYColorFromHexString(@"#6B35DC");
                    actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                    // 选择回调
                    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                        self.tipsLabel.hidden = YES;
                        [self getVideoFromPHAsset:assets[0] Complete:^(NSData *data, NSString *fileName) {
                            [self.viewModel.uploadUserVideoCommand execute:data];
                        }];
                    }];
                    // 调用相册
                    [actionSheet showPhotoLibraryWithSender:self];
                }
            } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
            [sheet show];
        } else {
            [MBProgressHUD sy_showTips:@"视频审核中,暂不能修改"];
        }
    }];
    [[self.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
        data.url = [NSURL URLWithString:self.viewModel.model.showVideo];
        data.sourceObject = self.videoImageView;
        data.autoPlayCount = 1;
        data.allowSaveToPhotoAlbum = NO;
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = @[data];
        browser.currentIndex = 0;
        [browser show];
    }];
}

- (void)_setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [UIView new];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 9.f;
    bgView.backgroundColor = SYColor(249, 228, 254);
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIImageView *videoImageView = [UIImageView new];
    videoImageView.image = SYImageNamed(@"add_image");
    videoImageView.layer.borderWidth = 1.f;
    videoImageView.layer.borderColor = SYColorFromHexString(@"#ECACED").CGColor;
    videoImageView.userInteractionEnabled = YES;
    _videoImageView = videoImageView;
    [bgView addSubview:videoImageView];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = SYFont(11, YES);
    tipsLabel.textColor = SYColorFromHexString(@"#F6A7FD");
    tipsLabel.text = @"暂无视频";
    _tipsLabel = tipsLabel;
    [videoImageView addSubview:tipsLabel];
    
    UIButton *playBtn = [UIButton new];
    [playBtn setImage:SYImageNamed(@"icon_videoPlay") forState:UIControlStateNormal];
    playBtn.hidden = YES;
    _playBtn = playBtn;
    [videoImageView addSubview:playBtn];
    
    UIButton *modifyVideoBtn = [UIButton new];
    [modifyVideoBtn setTitle:@"添加视频" forState:UIControlStateNormal];
    [modifyVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyVideoBtn.titleLabel.font = SYFont(13, YES);
    modifyVideoBtn.backgroundColor = SYColorFromHexString(@"#BF99E7");
    modifyVideoBtn.layer.cornerRadius = 9.f;
    modifyVideoBtn.layer.masksToBounds = YES;
    _modifyVideoBtn = modifyVideoBtn;
    [bgView addSubview:modifyVideoBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = SY_SCREEN_WIDTH - 4 - 30;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(2);
        make.right.equalTo(self.view).offset(-2);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.modifyVideoBtn.mas_bottom).offset(40);
    }];
    [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(40);
        make.centerX.equalTo(self.view);
        make.width.height.offset(width);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoImageView);
        make.bottom.equalTo(self.videoImageView).offset(-67.5);
        make.height.offset(14);
    }];
    [_modifyVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoImageView.mas_bottom).offset(20);
        make.height.offset(34);
        make.width.offset(120);
        make.centerX.equalTo(self.bgView);
    }];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoImageView);
        make.width.height.offset(80);
    }];
}

- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void(^)(NSData *data,NSString *fileName))result {
    NSArray * assetResources = [PHAssetResource assetResourcesForAsset: asset];
    PHAssetResource *resource;
    for (PHAssetResource * assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo || assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString * fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHAssetResourceRequestOptions * options = [[PHAssetResourceRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress) {
            NSLog(@"%f",progress);
        };
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
        [[NSFileManager defaultManager] removeItemAtPath: PATH_MOVIE_FILE error: nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource: resource toFile: [NSURL fileURLWithPath: PATH_MOVIE_FILE] options: options completionHandler: ^(NSError * _Nullable error) {
            NSLog(@"%@",error);
            if (error) {
                [MBProgressHUD sy_showTips:@"iCloud视频下载失败" addedToView:self.view];
                result(nil, nil);
            } else {
                NSData *data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath: PATH_MOVIE_FILE]];
                result(data, fileName);
            }
        }];
    } else {
        result(nil, nil);
    }
}

@end
