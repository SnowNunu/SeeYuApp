//
//  SYBootRegisterView.m
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYBootRegisterView.h"

@interface SYBootRegisterView ()

/// 昵称文本
@property(nonatomic, weak) UILabel *aliasLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine1;

/// 年龄文本
@property(nonatomic, weak) UILabel *ageLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine2;

/// 性别文本
@property(nonatomic, weak) UILabel *genderLabel;

@end

@implementation SYBootRegisterView

+ (instancetype)bootRegisterView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 添加子控件
        [self _setupSubViews];
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)_setupSubViews {
    UILabel *aliasLabel = [[UILabel alloc]init];
    aliasLabel.text = @"昵称";
    aliasLabel.textColor = SYColor(153, 153, 153);
    aliasLabel.font = SYRegularFont(18);
    _aliasLabel = aliasLabel;
    [self addSubview:aliasLabel];
    
    UITextField *aliasTextField = [[UITextField alloc]init];
    aliasTextField.font = SYRegularFont(20);
    aliasTextField.textColor = SYColor(51, 51, 51);
    [aliasTextField sy_limitMaxLength:SYNicknameMaxWords];
    _aliasTextField = aliasTextField;
    [self addSubview:_aliasTextField];
    
    UIImageView *underLine1 = [[UIImageView alloc]init];
    underLine1.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine1 = underLine1;
    [self addSubview:underLine1];
    
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.text = @"年龄";
    ageLabel.textColor = SYColor(153, 153, 153);
    ageLabel.font = SYRegularFont(18);
    _ageLabel = ageLabel;
    [self addSubview:ageLabel];
    
    UIButton *ageBtn = [[UIButton alloc]init];
    ageBtn.titleLabel.font = SYRegularFont(20);
    [ageBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    ageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _ageBtn = ageBtn;
    [self addSubview:ageBtn];
    
    UIImageView *underLine2 = [[UIImageView alloc]init];
    underLine2.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine2 = underLine2;
    [self addSubview:underLine2];
    
    UILabel *genderLabel = [[UILabel alloc]init];
    genderLabel.text = @"性别";
    genderLabel.textColor = SYColor(153, 153, 153);
    genderLabel.font = SYRegularFont(18);
    _genderLabel = genderLabel;
    [self addSubview:genderLabel];
    
    UIButton *maleBtn = [[UIButton alloc]init];
    [maleBtn setBackgroundImage:SYImageNamed(@"reg_sex_male_normal") forState:UIControlStateNormal];
    [maleBtn setBackgroundImage:SYImageNamed(@"reg_sex_male_pressed") forState:UIControlStateSelected];
    maleBtn.selected = YES;
    _maleBtn = maleBtn;
    [self addSubview:_maleBtn];
    
    UILabel *maleLabel = [[UILabel alloc]init];
    maleLabel.text = @"男";
    maleLabel.textColor = SYColor(196, 145, 253);
    maleLabel.font = SYRegularFont(20);
    _maleLabel = maleLabel;
    [self addSubview:maleLabel];
    
    UIButton *femaleBtn = [[UIButton alloc]init];
    [femaleBtn setBackgroundImage:SYImageNamed(@"reg_sex_female_normal") forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:SYImageNamed(@"reg_sex_female_pressed") forState:UIControlStateSelected];
    _femaleBtn = femaleBtn;
    [self addSubview:_femaleBtn];
    
    UILabel *femaleLabel = [[UILabel alloc]init];
    femaleLabel.text = @"女";
    femaleLabel.textColor = SYColor(153, 153, 153);
    femaleLabel.font = SYRegularFont(20);
    _femaleLabel = femaleLabel;
    [self addSubview:femaleLabel];
    
    UIButton *nextBtn = [[UIButton alloc]init];
    [nextBtn setBackgroundImage:[UIImage yy_imageWithColor:SYColorFromHexString(@"#9F69EB")] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = SYRegularFont(20);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTintColor:SYColorFromHexString(@"#FFFFFF")];
    nextBtn.tag = 801;
    _nextBtn = nextBtn;
    [self addSubview:nextBtn];
}

#pragma mark - 添加控件约束
- (void)_makeSubViewsConstraints {
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(45);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_aliasTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.aliasLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.aliasLabel.mas_right).offset(30);
    }];
    [_underLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.right.equalTo(self.aliasTextField);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.aliasTextField);
        make.centerY.equalTo(self.ageLabel);
        make.right.equalTo(self).offset(-50);
    }];
    [_underLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliasLabel);
        make.top.equalTo(self.ageLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(self.genderLabel.mas_right).offset(30);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleBtn.mas_right).offset(15);
        make.width.height.offset(25);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(self.maleLabel.mas_right).offset(45);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.femaleBtn.mas_right).offset(15);
        make.width.height.offset(25);
        make.centerY.equalTo(self.genderLabel);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(49);
    }];
}

@end
