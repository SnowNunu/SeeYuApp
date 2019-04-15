//
//  SYSelfieVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSelfieVC.h"

@interface SYSelfieVC ()

@property (nonatomic, strong) UILabel *takePhotoLabel;

@property (nonatomic, strong) UIView *takePhotoBgView;

@property (nonatomic, strong) UIImageView *takePhotoImageView;

@property (nonatomic, strong) UILabel *takePhotoTipsLabel;

@property (nonatomic, strong) UILabel *takeVideoLabel;

@property (nonatomic, strong) UIView *takeVideoBgView;

@property (nonatomic, strong) UIImageView *takeVideoImageView;

@property (nonatomic, strong) UILabel *takeVideoTipsLabel;

@property (nonatomic, strong) UIButton *uploadBtn;

@end

@implementation SYSelfieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (void)_setupSubViews {
    UILabel *takePhotoLabel = [UILabel new];
    takePhotoLabel.textColor = SYColor(51, 51, 51);
    takePhotoLabel.font = SYRegularFont(18);
    takePhotoLabel.textAlignment = NSTextAlignmentLeft;
    takePhotoLabel.text = @"拍摄照片";
    _takePhotoLabel = takePhotoLabel;
    [self.view addSubview:takePhotoLabel];
    
    UIView *takePhotoBgView = [UIView new];
    takePhotoBgView.backgroundColor = SYColorFromHexString(@"#E9E9E9");
    takePhotoBgView.layer.borderWidth = 1.f;
    takePhotoBgView.layer.borderColor = SYColorFromHexString(@"#CCCCCC").CGColor;
    _takePhotoBgView = takePhotoBgView;
    [self.view addSubview:takePhotoBgView];
    
    UIImageView *takePhotoImageView = [UIImageView new];
    takePhotoImageView.image = SYImageNamed(@"upload_plus");
    _takePhotoImageView = takePhotoImageView;
    [takePhotoBgView addSubview:takePhotoImageView];
    
    UILabel *takePhotoTipsLabel = [UILabel new];
    takePhotoTipsLabel.textColor = SYColor(153, 153, 153);
    takePhotoTipsLabel.font = SYRegularFont(12);
    takePhotoTipsLabel.textAlignment = NSTextAlignmentLeft;
    takePhotoTipsLabel.text = @"建议在网络良好状态下上传，并注意照片反光";
    _takePhotoTipsLabel = takePhotoTipsLabel;
    [self.view addSubview:takePhotoTipsLabel];
    
    UILabel *takeVideoLabel = [UILabel new];
    takeVideoLabel.textColor = SYColor(51, 51, 51);
    takeVideoLabel.font = SYRegularFont(18);
    takeVideoLabel.textAlignment = NSTextAlignmentLeft;
    takeVideoLabel.text = @"拍摄视频";
    _takeVideoLabel = takeVideoLabel;
    [self.view addSubview:takeVideoLabel];
    
    UIView *takeVideoBgView = [UIView new];
    takeVideoBgView.backgroundColor = SYColorFromHexString(@"#E9E9E9");
    takeVideoBgView.layer.borderWidth = 1.f;
    takeVideoBgView.layer.borderColor = SYColorFromHexString(@"#CCCCCC").CGColor;
    _takeVideoBgView = takeVideoBgView;
    [self.view addSubview:takeVideoBgView];
    
    UIImageView *takeVideoImageView = [UIImageView new];
    takeVideoImageView.image = SYImageNamed(@"upload_plus");
    _takeVideoImageView = takeVideoImageView;
    [self.view addSubview:takeVideoImageView];
    
    UILabel *takeVideoTipsLabel = [UILabel new];
    takeVideoTipsLabel.textColor = SYColor(153, 153, 153);
    takeVideoTipsLabel.font = SYRegularFont(12);
    takeVideoTipsLabel.textAlignment = NSTextAlignmentLeft;
    takeVideoTipsLabel.text = @"保持正面拍摄5秒钟";
    _takeVideoTipsLabel = takeVideoTipsLabel;
    [self.view addSubview:takeVideoTipsLabel];
    
    UIButton *uploadBtn = [UIButton new];
    [uploadBtn setBackgroundColor:SYColorFromHexString(@"#9F69EB")];
    [uploadBtn setTitle:@"提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = SYRegularFont(18);
    _uploadBtn = uploadBtn;
    [self.view addSubview:uploadBtn];
}

- (void)_makeSubViewsConstraints {
    [_takePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.height.offset(20);
    }];
    CGFloat height = (SY_SCREEN_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT - 225) / 2;
    [_takePhotoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height);
        make.width.equalTo(self.takePhotoBgView.mas_height).multipliedBy(0.666);
        make.left.equalTo(self.takePhotoLabel);
        make.top.equalTo(self.takePhotoLabel.mas_bottom).offset(15);
    }];
    [_takePhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.takePhotoBgView);
        make.width.height.offset(33);
    }];
    [_takePhotoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takePhotoBgView.mas_bottom).offset(15);
        make.left.equalTo(self.takePhotoBgView);
        make.height.offset(15);
    }];
    [_takeVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.takePhotoTipsLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    [_takeVideoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(self.takePhotoBgView);
        make.top.equalTo(self.takeVideoLabel.mas_bottom).offset(15);
    }];
    [_takeVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.takeVideoBgView);
        make.width.height.offset(33);
    }];
    [_takeVideoTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takeVideoBgView.mas_bottom).offset(15);
        make.left.equalTo(self.takePhotoBgView);
        make.height.offset(15);
    }];
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.offset(50);
    }];
}

@end

