//
//  SYBaseInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYBaseInfoEditVC.h"

@interface SYBaseInfoEditVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataSource;

@property (nonatomic, strong) ZYImagePicker *imagePicker;

@end

@implementation SYBaseInfoEditVC

- (ZYImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[ZYImagePicker alloc]init];
        _imagePicker.resizableClipArea = NO;
        _imagePicker.clipSize = CGSizeMake(SY_SCREEN_WIDTH - 60, SY_SCREEN_WIDTH - 60);
        _imagePicker.slideColor = [UIColor whiteColor];
        _imagePicker.slideWidth = 4;
        _imagePicker.slideLength = 40;
        _imagePicker.didSelectedImageBlock = ^BOOL(UIImage *selectedImage) {
            return YES;
        };
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataSource = @[@[@{@"label":@"头像",@"kind":@"image"}],@[@{@"label":@"昵称",@"kind":@"text"},@{@"label":@"性别",@"kind":@"label"},@{@"label":@"ID号",@"kind":@"label"},@{@"label":@"个性签名",@"kind":@"text"}],@[@{@"label":@"年龄",@"kind":@"text"},@{@"label":@"城市",@"kind":@"text"},@{@"label":@"收入",@"kind":@"text"},@{@"label":@"身高",@"kind":@"text"},@{@"label":@"婚姻",@"kind":@"text"}],@[@{@"label":@"学历",@"kind":@"text"},@{@"label":@"职业",@"kind":@"text"},@{@"label":@"生日",@"kind":@"text"},@{@"label":@"体重",@"kind":@"text"},@{@"label":@"星座",@"kind":@"text"},@{@"label":@"爱好",@"kind":@"text"}]];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, user) subscribeNext:^(SYUser *user) {
        if (user != nil) {
            [self.tableView reloadData];
        }
    }];
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
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataSource[section];
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 15.f;
    }
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
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *array = _dataSource[indexPath.section];
    NSDictionary *params = array[indexPath.row];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = SYColor(51, 51, 51);
    titleLabel.font = SYRegularFont(16);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = params[@"label"];
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 15.f;
    avatarImageView.image = SYImageNamed(@"DefaultProfileHead_66x66");
    [cell.contentView addSubview:avatarImageView];
    if (![params[@"kind"] isEqualToString:@"image"]) {
        avatarImageView.hidden = YES;
    }
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = SYColor(153, 153, 153);
    contentLabel.font = SYRegularFont(12);
    contentLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:contentLabel];
    if ([params[@"kind"] isEqualToString:@"image"]) {
        contentLabel.hidden = YES;
    }
    
    UIImageView *arrowImageView = [UIImageView new];
    arrowImageView.image = SYImageNamed(@"detail_back");
    [cell.contentView addSubview:arrowImageView];
    if ([params[@"kind"] isEqualToString:@"label"]) {
        arrowImageView.hidden = YES;
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(15);
    }];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-15);
        make.width.height.offset(30);
        make.centerY.equalTo(cell.contentView);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-15);
        make.centerY.equalTo(cell.contentView);
        make.height.offset(15);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-15);
        make.width.offset(7);
        make.height.offset(14);
    }];
    if (indexPath.section == 0) {
        if (self.viewModel.user.userHeadImg != nil && self.viewModel.user.userHeadImg.length > 0) {
            [avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.viewModel.user.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userName != nil && self.viewModel.user.userName.length > 0) {
                contentLabel.text = self.viewModel.user.userName;
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userGender != nil && self.viewModel.user.userGender.length > 0) {
                contentLabel.text = self.viewModel.user.userGender;
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userId != nil && self.viewModel.user.userId.length > 0) {
                contentLabel.text = self.viewModel.user.userId;
            }
        } else {
            if (self.viewModel.user.userSignature != nil && self.viewModel.user.userSignature.length > 0) {
                contentLabel.text = self.viewModel.user.userSignature;
            } else {
                contentLabel.text = @"未填写";
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userAge != nil && self.viewModel.user.userAge.length > 0) {
                contentLabel.text = self.viewModel.user.userAge;
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userAddress != nil && self.viewModel.user.userAddress.length > 0) {
                contentLabel.text = self.viewModel.user.userAddress;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userIncome != nil && self.viewModel.user.userIncome.length > 0) {
                contentLabel.text = self.viewModel.user.userIncome;
            }
        } else if (indexPath.row == 3) {
            if (self.viewModel.user.userHeight != nil && self.viewModel.user.userHeight.length > 0) {
                contentLabel.text = self.viewModel.user.userHeight;
            }
        } else {
            if (self.viewModel.user.userMarry != nil && self.viewModel.user.userMarry.length > 0) {
                contentLabel.text = self.viewModel.user.userMarry;
            }
        }
    } else {
        if (indexPath.row == 0) {
            if (self.viewModel.user.userEdu != nil && self.viewModel.user.userEdu.length > 0) {
                contentLabel.text = self.viewModel.user.userEdu;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 1) {
            if (self.viewModel.user.userProfession != nil && self.viewModel.user.userProfession.length > 0) {
                contentLabel.text = self.viewModel.user.userProfession;
            }
        } else if (indexPath.row == 2) {
            if (self.viewModel.user.userBirthday != nil && self.viewModel.user.userBirthday.length > 0) {
                contentLabel.text = self.viewModel.user.userBirthday;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 3) {
            if (self.viewModel.user.userWeight != nil && self.viewModel.user.userWeight.length > 0) {
                contentLabel.text = self.viewModel.user.userWeight;
            } else {
                contentLabel.text = @"未填写";
            }
        } else if (indexPath.row == 4) {
            if (self.viewModel.user.userConstellation != nil && self.viewModel.user.userConstellation.length > 0) {
                contentLabel.text = self.viewModel.user.userConstellation;
            } else {
                contentLabel.text = @"未填写";
            }
        } else {
            if (self.viewModel.user.userSpecialty != nil && self.viewModel.user.userSpecialty.length > 0) {
                contentLabel.text = self.viewModel.user.userSpecialty;
            } else {
                contentLabel.text = @"未填写";
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        @weakify(self)
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            @strongify(self)
            __weak typeof(self) weakSelf = self;
            if (buttonIndex == 0) return ;
            if (buttonIndex == 1) {
                // 拍照
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_camera;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    [weakSelf.viewModel.uploadAvatarImageCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            } else {
                // 相册
                weakSelf.imagePicker.isCustomCamera = YES;
                weakSelf.imagePicker.imageSorceType = sourceType_SavedPhotosAlbum;
                weakSelf.imagePicker.clippedBlock = ^(UIImage *clippedImage) {
                    [weakSelf.viewModel.uploadAvatarImageCommand execute:[clippedImage resetSizeOfImageData:clippedImage maxSize:300]];
                };
                [weakSelf presentViewController:weakSelf.imagePicker.pickerController animated:YES completion:nil];
            }
        } otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet show];
    } else if (indexPath.section == 1) {
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 选择年龄
            NSMutableArray *ageArray = [NSMutableArray new];
            for (int i = 0 ; i < 80; i++) {
                [ageArray addObject:[NSString stringWithFormat:@"%d",18 + i]];
            }
            [self showPickerWithTitle:@"请选择年龄" andDataArrays:ageArray andSelectedValue:self.viewModel.user.userAge andType:@"age"];
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            // 选择收入
            NSMutableArray *incomeArray = [@[@"2000以下",@"2000-5000",@"5000-10000",@"10000-20000",@"20000以上"] mutableCopy];
            [self showPickerWithTitle:@"请选择收入" andDataArrays:incomeArray andSelectedValue:self.viewModel.user.userIncome andType:@"income"];
        } else if (indexPath.row == 3) {
            // 选择身高
            NSMutableArray *heightArray = [NSMutableArray new];
            for (int i = 0 ; i <= 60; i++) {
                [heightArray addObject:[NSString stringWithFormat:@"%d",140 + i]];
            }
            [self showPickerWithTitle:@"请选择身高" andDataArrays:heightArray andSelectedValue:self.viewModel.user.userHeight andType:@"height"];
        } else {
            // 选择婚姻状态
            NSMutableArray *marryArray = [@[@"未婚",@"已婚",@"离异",@"保密"] mutableCopy];
            [self showPickerWithTitle:@"请选择婚姻状态" andDataArrays:marryArray andSelectedValue:self.viewModel.user.userMarry andType:@"marry"];
        }
    } else {
        if (indexPath.row == 0) {
            // 选择学历
            NSMutableArray *eduArray = [@[@"初中",@"中专",@"高中",@"大专",@"本科",@"本科以上"] mutableCopy];
            [self showPickerWithTitle:@"请选择学历" andDataArrays:eduArray andSelectedValue:self.viewModel.user.userEdu andType:@"edu"];
        } else if (indexPath.row == 1) {
            // 选择职业
            NSMutableArray *jobArray = [@[@"教师",@"工人",@"记者",@"演员",@"厨师",@"医生",@"护士",@"司机",@"军人",@"律师",@"商人",@"会计",@"店员",@"出纳",@"作家",@"导游",@"模特",@"警察",@"歌手",@"画家",@"裁缝",@"翻译",@"法官",@"保安",@"花匠",@"服务员",@"清洁工",@"建筑师",@"理发师",@"采购员",@"设计师",@"消防员",@"机修工",@"推销员",@"魔术师",@"模特儿",@"邮递员",@"售货员",@"救生员",@"运动员",@"工程师",@"飞行员",@"管理员",@"机械师",@"经纪人",@"审计员",@"漫画家",@"园艺师",@"科学家",@"主持人",@"程序员"] mutableCopy];
            [self showPickerWithTitle:@"请选择职业" andDataArrays:jobArray andSelectedValue:self.viewModel.user.userProfession andType:@"job"];
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            // 选择体重
            NSMutableArray *weightArray = [NSMutableArray new];
            for (int i = 0 ; i < 170; i++) {
                [weightArray addObject:[NSString stringWithFormat:@"%d",30 + i]];
            }
            [self showPickerWithTitle:@"请选择体重" andDataArrays:weightArray andSelectedValue:self.viewModel.user.userWeight andType:@"weight"];
        } else if (indexPath.row == 4) {
            // 选择星座
            NSMutableArray *constellationArray = [@[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"] mutableCopy];
            [self showPickerWithTitle:@"请选择学历" andDataArrays:constellationArray andSelectedValue:self.viewModel.user.userConstellation andType:@"constellation"];
        } else {
            // 选择爱好
            [self.viewModel.enterHobbyChooseViewCommand execute:nil];
        }
    }
}

// 显示滑动选择页
- (void)showPickerWithTitle:(NSString*)title andDataArrays: (NSMutableArray*)array andSelectedValue: (NSString*) value andType: (NSString*) type {
    NSInteger row = [array indexOfObject:value];
    @weakify(self)
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:array initialSelection:row doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if ([type isEqualToString:@"age"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userAge":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"job"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userProfession":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"income"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userIncome":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"height"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userHeight":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"marry"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userMarry":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"edu"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userEdu":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"weight"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userWeight":array[selectedIndex]}];
            }
        } else if ([type isEqualToString:@"constellation"]) {
            if (selectedIndex != row) {
                [self.viewModel.updateUserInfoCommand execute:@{@"userId":self.viewModel.user.userId,@"userConstellation":array[selectedIndex]}];
            }
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"取消了选择");
    } origin:self.view];
    [picker showActionSheetPicker];
}

@end
