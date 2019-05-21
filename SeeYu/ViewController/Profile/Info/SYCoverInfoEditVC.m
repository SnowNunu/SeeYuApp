//
//  SYCoverInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYCoverInfoEditVC.h"
#import "SYUserInfoEditModel.h"

@interface SYCoverInfoEditVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *modifyCoverBtn;

@end

@implementation SYCoverInfoEditVC

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
        if (model != nil) {
            if (model.showPhoto == nil || model.showPhoto.length == 0) {
                self.tipsLabel.hidden = NO;
                [self.modifyCoverBtn setTitle:@"添加封面" forState:UIControlStateNormal];
            } else {
                self.tipsLabel.hidden = YES;
                [self.modifyCoverBtn setTitle:@"修改封面" forState:UIControlStateNormal];
                self.coverImageView.yy_imageURL = [NSURL URLWithString:model.showPhoto];
            }
        }
    }];
    [[self.modifyCoverBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.viewModel.model.showPhoto == nil || ![self.viewModel.model.showPhotoStatus isEqualToString:@"0"]) {
            @strongify(self)
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) return ;
                if (buttonIndex == 1) {
                    // 拍照
                    ZLCustomCamera *camera = [ZLCustomCamera new];
                    camera.allowTakePhoto = YES;
                    camera.allowRecordVideo = NO;
                    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                        self.tipsLabel.hidden = YES;
                        [self.viewModel.uploadUserCoverCommand execute:[image resetSizeOfImageData:image maxSize:300]];
                    };
                    [self showDetailViewController:camera sender:nil];
                } else {
                    // 相册
                    ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                    actionSheet.configuration.maxSelectCount = 1;
                    actionSheet.configuration.maxPreviewCount = 0;
                    actionSheet.configuration.allowTakePhotoInLibrary = NO;
                    actionSheet.configuration.allowMixSelect = NO;
                    actionSheet.configuration.navBarColor = SYColorFromHexString(@"#9F69EB");
                    actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                    // 选择回调
                    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                        self.tipsLabel.hidden = YES;
                        [self.viewModel.uploadUserCoverCommand execute:[images[0] resetSizeOfImageData:images[0] maxSize:300]];
                    }];
                    // 调用相册
                    [actionSheet showPhotoLibraryWithSender:self];
                }
            } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [sheet show];
        } else {
            [MBProgressHUD sy_showTips:@"封面审核中,暂不能修改"];
        }
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
    
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.image = SYImageNamed(@"add_image");
    coverImageView.layer.borderWidth = 1.f;
    coverImageView.layer.borderColor = SYColorFromHexString(@"#ECACED").CGColor;
    _coverImageView = coverImageView;
    [bgView addSubview:coverImageView];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = SYFont(11, YES);
    tipsLabel.textColor = SYColorFromHexString(@"#F6A7FD");
    tipsLabel.text = @"暂无封面";
    _tipsLabel = tipsLabel;
    [coverImageView addSubview:tipsLabel];
    
    UIButton *modifyCoverBtn = [UIButton new];
    [modifyCoverBtn setTitle:@"添加封面" forState:UIControlStateNormal];
    [modifyCoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyCoverBtn.titleLabel.font = SYFont(13, YES);
    modifyCoverBtn.backgroundColor = SYColorFromHexString(@"#BF99E7");
    modifyCoverBtn.layer.cornerRadius = 9.f;
    modifyCoverBtn.layer.masksToBounds = YES;
    _modifyCoverBtn = modifyCoverBtn;
    [bgView addSubview:modifyCoverBtn];
}

- (void)_makeSubViewsConstraints {
    CGFloat width = SY_SCREEN_WIDTH - 4 - 30;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(2);
        make.right.equalTo(self.view).offset(-2);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.modifyCoverBtn.mas_bottom).offset(40);
    }];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(40);
        make.centerX.equalTo(self.view);
        make.width.height.offset(width);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coverImageView);
        make.bottom.equalTo(self.coverImageView).offset(-67.5);
        make.height.offset(14);
    }];
    [_modifyCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(20);
        make.height.offset(34);
        make.width.offset(120);
        make.centerX.equalTo(self.bgView);
    }];
}

@end
