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
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"要退出动态编辑页面吗？" message:@"退出后当前添加的动态信息将会丢失" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel.services popViewModelAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    [RACObserve(self.viewModel, imagesArray) subscribeNext:^(id x) {
        [self.imagesCollectionView reloadData];
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
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseBtn.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.offset(150);
    }];
    [self.divider0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.textView);
        make.height.offset(0.5f);
    }];
    [self.divider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(0.5);
        make.bottom.equalTo(self.textView);
    }];
    [self.wordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.textView).with.offset(-9);
    }];
    [_imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.textView.mas_bottom).offset(5);
        make.height.offset(SY_SCREEN_WIDTH - 2 * 15);
    }];
}

#pragma mark UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.cellIsFull ? 9 : self.viewModel.imagesArray.count + 1;
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.imagesArray.count) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            
        } otherButtonTitles:@"拍摄",@"从手机相册选择", nil];
        [sheet show];
    } else {
        ZLPhotoActionSheet *actionSheet = [ZLPhotoActionSheet new];
        actionSheet.configuration.maxSelectCount = 9;
        actionSheet.configuration.maxPreviewCount = 0;
        actionSheet.configuration.allowTakePhotoInLibrary = NO;
        actionSheet.configuration.allowMixSelect = NO;
        actionSheet.configuration.navBarColor = SYColorFromHexString(@"#9F69EB");
        actionSheet.configuration.bottomBtnsNormalTitleColor = SYColorFromHexString(@"#9F69EB");
        actionSheet.arrSelectedAssets = [NSMutableArray arrayWithArray:self.viewModel.assetArray];
        // 选择回调
        [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            self.viewModel.cellIsFull = images.count == 9 ? YES : NO;
            self.viewModel.imagesArray = images;
            self.viewModel.assetArray = assets;
        }];
        // 调用相册
        [actionSheet showPhotoLibraryWithSender:self];
    }
}

@end
