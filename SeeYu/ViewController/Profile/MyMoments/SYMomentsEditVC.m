//
//  SYMomentsEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/26.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYMomentsEditVC.h"

@interface SYMomentsEditVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *releaseBtn;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIImageView *divider0;

@property (nonatomic, strong) UIImageView *divider1;

@property (nonatomic, strong) UILabel *wordsLabel;

@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UIImageView *playImageView;

@property (nonatomic, strong) UICollectionView *imagesCollectionView;

@end

static NSString *reuseIdentifier = @"imagesListCellIdentifier";

@implementation SYMomentsEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"要退出动态编辑页面吗？" message:@"退出后当前添加的动态信息将会丢失" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel.services popViewModelAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [RACObserve(self.viewModel, imagesArray) subscribeNext:^(id x) {
        @strongify(self)
        [self.imagesCollectionView reloadData];
    }];
    [RACObserve(self.viewModel, type) subscribeNext:^(NSString *type) {
        @strongify(self)
        if ([type isEqualToString:@"video"]) {
            [self.videoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(180);
            }];
            [self.playImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.videoImageView).offset(6);
                make.width.offset(19);
                make.height.offset(19);
            }];
            if (self.viewModel.videoContentUrl != nil) {
                // 来自于自己拍摄的视频
                self.videoImageView.image = [[UIImage alloc] getVideoPreviewImage:self.viewModel.videoContentUrl];
            } else {
                self.videoImageView.image = self.viewModel.imagesArray.firstObject;
            }
        } else {
            [self.videoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
        }
    }];
    [_videoImageView bk_whenTapped:^{
        // 修改视频
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZLCustomCamera *camera = [ZLCustomCamera new];
                camera.allowTakePhoto = NO;
                camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                    self.viewModel.videoContentUrl = videoUrl;
                    self.videoImageView.image = [[UIImage alloc] getVideoPreviewImage:videoUrl];
                };
                [self showDetailViewController:camera sender:nil];
            } else if (buttonIndex == 2) {
                ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                actionSheet.configuration.maxSelectCount = 1;
                actionSheet.configuration.maxPreviewCount = 0;
                actionSheet.configuration.allowTakePhotoInLibrary = NO;
                actionSheet.configuration.allowMixSelect = NO;
                actionSheet.configuration.allowSelectVideo = YES;
                actionSheet.configuration.allowSelectImage = NO;
                actionSheet.configuration.navBarColor = SYColorFromHexString(@"#6B35DC");
                actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                // 选择回调
                [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                    self.viewModel.imagesArray = images;
                    self.viewModel.assetArray = assets;
                    self.videoImageView.image = images.firstObject;
                }];
                // 调用相册
                [actionSheet showPhotoLibraryWithSender:self];
            } else {
                return;
            }
        } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
        [sheet show];
    }];
    [[_releaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.viewModel.type isEqualToString:@"video"]) {
            // 先判断是拍摄的视频还是从相册选择的视频
            if (self.viewModel.videoContentUrl != nil || self.viewModel.imagesArray.count > 0) {
                self.viewModel.text = self.textView.text;
                [self.viewModel.releaseMomentCommand execute:nil];
            } else {
                [MBProgressHUD sy_showError:@"请先选择视频或照片"];
            }
        } else {
            if (self.viewModel.imagesArray.count > 0) {
                [self.viewModel.releaseMomentCommand execute:nil];
            } else {
                [MBProgressHUD sy_showError:@"请先选择视频或照片"];
            }
        }
        NSLog(@"%@",self.viewModel.assetArray);
        NSLog(@"%@",self.viewModel.imagesArray);
    }];
}

- (void)_setupSubViews {
    UIButton *backBtn = [UIButton new];
    [backBtn setBackgroundImage:SYImageNamed(@"backBtn_black") forState:UIControlStateNormal];
    _backBtn = backBtn;
    [self.view addSubview:backBtn];
    
    UIButton *releaseBtn = [UIButton new];
    releaseBtn.backgroundColor = SYColorFromHexString(@"#9F69EB");
    [releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseBtn.layer.masksToBounds = YES;
    releaseBtn.layer.cornerRadius = 7.f;
    _releaseBtn = releaseBtn;
    [self.view addSubview:releaseBtn];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = SYRegularFont(17);
    textView.textContainerInset = UIEdgeInsetsMake(14, 16, 22, 16 + 5); // 上左下右
    textView.backgroundColor = self.view.backgroundColor;
    _textView = textView;
    [self.view addSubview:textView];
    
    // 分割线
    UIImageView *divider0 = [[UIImageView alloc] init];
    _divider0 = divider0;
    [self.view addSubview:divider0];
    
    UIImageView *divider1 = [[UIImageView alloc] init];
    _divider1 = divider1;
    [self.view addSubview:divider1];
    divider0.backgroundColor = divider1.backgroundColor = SY_MAIN_LINE_COLOR_1;
    
    /// 数字number
    UILabel *wordsLabel = [[UILabel alloc] init];
    wordsLabel.textColor = SY_MAIN_TEXT_COLOR_1;
    wordsLabel.font = SYRegularFont(12);
    wordsLabel.text = @"100";
    wordsLabel.textAlignment = NSTextAlignmentRight;
    wordsLabel.backgroundColor = self.view.backgroundColor;
    _wordsLabel = wordsLabel;
    [self.view addSubview:wordsLabel];
    
    /// 限制文字个数
    [textView sy_limitMaxLength:100];
    
    /// 监听数据变化
    @weakify(self);
    [[RACSignal merge:@[RACObserve(textView, text),textView.rac_textSignal]] subscribeNext:^(NSString * text) {
        @strongify(self);
        self.wordsLabel.text = [NSString stringWithFormat:@"%zd",100 - text.length];
    }];
    
    UIImageView *videoImageView = [UIImageView new];
    videoImageView.userInteractionEnabled = YES;
    videoImageView.backgroundColor = [UIColor blackColor];
    _videoImageView = videoImageView;
    [self.view addSubview:videoImageView];
    
    UIImageView *playImageView = [UIImageView new];
    playImageView.image = SYImageNamed(@"play");
    _playImageView = playImageView;
    [videoImageView addSubview:playImageView];
    
    CGFloat width = (SY_SCREEN_WIDTH - 4 * 15) / 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15; // 最小行间距
    layout.minimumInteritemSpacing = 15; // 最小左右间距
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.estimatedItemSize = CGSizeMake(width, width);
    UICollectionView *imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    imagesCollectionView.delegate = self;
    imagesCollectionView.dataSource = self;
    imagesCollectionView.backgroundColor = self.view.backgroundColor;
    [imagesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _imagesCollectionView = imagesCollectionView;
    [self.view addSubview:imagesCollectionView];
}

- (void)_makeSubViewsConstraints {
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(25);
        make.width.offset(30);
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.releaseBtn);
    }];
    [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(60);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(15 + SY_APPLICATION_STATUS_BAR_HEIGHT);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseBtn.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(150);
    }];
    [_divider0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.textView);
        make.height.offset(0.5f);
    }];
    [_divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(0.5);
        make.bottom.equalTo(self.textView);
    }];
    [_wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.textView).with.offset(-9);
    }];
    [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.width.offset(103);
        make.height.offset(0);
        make.top.equalTo(self.textView.mas_bottom).offset(5);
    }];
    [_imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.videoImageView.mas_bottom);
        make.height.offset(SY_SCREEN_WIDTH - 2 * 15);
    }];
}

#pragma mark UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.viewModel.type isEqualToString:@"video"]) {
        return 0;
    } else {
        return self.viewModel.cellIsFull ? 9 : self.viewModel.imagesArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [cell.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];
    if (indexPath.row == self.viewModel.imagesArray.count) {
        imageView.image = SYImageNamed(@"btn_moment_addPic");
    } else {
        imageView.image = self.viewModel.imagesArray[indexPath.row];
    }
    if ([self.viewModel.type isEqualToString:@"video"]) {
        imageView.image = nil;
    } else {
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.imagesArray.count) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZLCustomCamera *camera = [ZLCustomCamera new];
                camera.allowTakePhoto = YES;
                camera.allowRecordVideo = NO;
                camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                    if (image != nil) {
                        NSMutableArray<UIImage *> *tempArray = [NSMutableArray arrayWithArray:self.viewModel.imagesArray];
                        [tempArray addObject:image];
                        self.viewModel.imagesArray = [NSArray arrayWithArray:tempArray];
                    }
                };
                [self showDetailViewController:camera sender:nil];
            } else if (buttonIndex == 2) {
                ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
                actionSheet.configuration.maxSelectCount = 9 - self.viewModel.imagesArray.count;
                actionSheet.configuration.maxPreviewCount = 0;
                actionSheet.configuration.allowTakePhotoInLibrary = NO;
                actionSheet.configuration.allowMixSelect = NO;
                actionSheet.configuration.allowSelectImage = YES;
                actionSheet.configuration.allowSelectVideo = NO;
                actionSheet.configuration.navBarColor = SYColorFromHexString(@"#6B35DC");
                actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
                // 选择回调
                [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                    // 这里不能空选
                    NSMutableArray<UIImage *> *tempImagesArray = [NSMutableArray arrayWithArray:self.viewModel.imagesArray];
                    [tempImagesArray addObjectsFromArray:images];
                    NSMutableArray<PHAsset *> *tempAssetsArray = [NSMutableArray arrayWithArray:self.viewModel.assetArray];
                    [tempAssetsArray addObjectsFromArray:assets];
                    self.viewModel.cellIsFull = tempImagesArray.count == 9 ? YES : NO;
                    self.viewModel.imagesArray = [NSArray arrayWithArray:tempImagesArray];
                    self.viewModel.assetArray = [NSArray arrayWithArray:tempAssetsArray];
                }];
                // 调用相册
                [actionSheet showPhotoLibraryWithSender:self];
            }
        } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
        [sheet show];
    } else {
        ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
        actionSheet.configuration.maxSelectCount = 9;
        actionSheet.configuration.maxPreviewCount = 0;
        actionSheet.configuration.allowTakePhotoInLibrary = NO;
        actionSheet.configuration.allowMixSelect = NO;
        actionSheet.configuration.allowSelectImage = YES;
        actionSheet.configuration.allowSelectVideo = NO;
        actionSheet.configuration.navBarColor = SYColorFromHexString(@"#6B35DC");
        actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
        actionSheet.arrSelectedAssets = [NSMutableArray arrayWithArray:self.viewModel.assetArray];
        // 选择回调
        [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            // 这里不能空选
            PHAsset *asset = assets.firstObject;
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                self.viewModel.type = @"video";
            } else {
                self.viewModel.type = @"images";
            }
            self.viewModel.cellIsFull = images.count == 9 ? YES : NO;
            self.viewModel.imagesArray = images;
            self.viewModel.assetArray = assets;
        }];
        // 调用相册
        [actionSheet showPhotoLibraryWithSender:self];
    }
}

@end
