//
//  SYRegisterView.m
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/31.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYRegisterView.h"

@interface SYRegisterView ()

/// 职业文本
@property(nonatomic, weak) UILabel *jobLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine1;

/// 收入文本
@property(nonatomic, weak) UILabel *incomeLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine2;

/// 身高文本
@property(nonatomic, weak) UILabel *heightLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine3;

/// 婚姻文本
@property(nonatomic, weak) UILabel *maritalStatusLabel;

/// 下划线
@property(nonatomic, weak) UIImageView *underLine4;

/// 特长文本
@property(nonatomic, weak) UILabel *specialtyLabel;

@end

@implementation SYRegisterView

+ (instancetype)registerView {
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
    UILabel *jobLabel = [[UILabel alloc]init];
    jobLabel.text = @"职业";
    jobLabel.textColor = SYColor(153, 153, 153);
    jobLabel.font = SYRegularFont(18);
    _jobLabel = jobLabel;
    [self addSubview:jobLabel];
    
    UITextField *jobTextField = [[UITextField alloc]init];
    jobTextField.font = SYRegularFont(20);
    jobTextField.textColor = SYColor(51, 51, 51);
    _jobTextField = jobTextField;
    [self addSubview:jobTextField];
    
    UIImageView *underLine1 = [[UIImageView alloc]init];
    underLine1.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine1 = underLine1;
    [self addSubview:underLine1];
    
    UILabel *incomeLabel = [[UILabel alloc]init];
    incomeLabel.text = @"收入";
    incomeLabel.textColor = SYColor(153, 153, 153);
    incomeLabel.font = SYRegularFont(18);
    _incomeLabel = incomeLabel;
    [self addSubview:incomeLabel];
    
    UIButton *incomeBtn = [[UIButton alloc]init];
    incomeBtn.titleLabel.font = SYRegularFont(20);
    [incomeBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    incomeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    incomeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _incomeBtn = incomeBtn;
    [self addSubview:incomeBtn];
    
    UIImageView *underLine2 = [[UIImageView alloc]init];
    underLine2.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine2 = underLine2;
    [self addSubview:underLine2];
    
    UILabel *heightLabel = [[UILabel alloc]init];
    heightLabel.text = @"身高";
    heightLabel.textColor = SYColor(153, 153, 153);
    heightLabel.font = SYRegularFont(18);
    _heightLabel = heightLabel;
    [self addSubview:heightLabel];
    
    UIButton *heightBtn = [[UIButton alloc]init];
    heightBtn.titleLabel.font = SYRegularFont(20);
    [heightBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    heightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    heightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _heightBtn = heightBtn;
    [self addSubview:heightBtn];
    
    UIImageView *underLine3 = [[UIImageView alloc]init];
    underLine3.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine3 = underLine3;
    [self addSubview:underLine3];
    
    UILabel *maritalStatusLabel = [[UILabel alloc]init];
    maritalStatusLabel.textColor = SYColor(153, 153, 153);
    maritalStatusLabel.font = SYRegularFont(18);
    maritalStatusLabel.text = @"婚姻";
    _maritalStatusLabel = maritalStatusLabel;
    [self addSubview:maritalStatusLabel];
    
    UIButton *maritalStatusBtn = [[UIButton alloc]init];
    maritalStatusBtn.titleLabel.font = SYRegularFont(20);
    [maritalStatusBtn setTitleColor:SYColor(51, 51, 51) forState:UIControlStateNormal];
    maritalStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    maritalStatusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _maritalStatusBtn = maritalStatusBtn;
    [self addSubview:maritalStatusBtn];
    
    UIImageView *underLine4 = [[UIImageView alloc]init];
    underLine4.backgroundColor = SYColorFromHexString(@"#ADADAD");
    _underLine4 = underLine4;
    [self addSubview:underLine4];
    
    UILabel *specialtyLabel = [[UILabel alloc]init];
    specialtyLabel.text = @"特长";
    specialtyLabel.textColor = SYColor(153, 153, 153);
    specialtyLabel.font = SYRegularFont(18);
    _specialtyLabel = specialtyLabel;
    [self addSubview:specialtyLabel];
    
    UIButton *strongTipsBtn = [[UIButton alloc]init];
    strongTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [strongTipsBtn setTitle:@"体壮如牛" forState:UIControlStateNormal];
    strongTipsBtn.titleLabel.font = SYRegularFont(13);
    [strongTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [strongTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    strongTipsBtn.borderWidth = 2.f;
    strongTipsBtn.cornerRadius = 12.f;
    strongTipsBtn.tag = 700;
    _strongTipsBtn = strongTipsBtn;
    [self addSubview:strongTipsBtn];
    
    UIButton *technologyTipsBtn = [[UIButton alloc]init];
    technologyTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [technologyTipsBtn setTitle:@"车技娴熟" forState:UIControlStateNormal];
    technologyTipsBtn.titleLabel.font = SYRegularFont(13);
    [technologyTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [technologyTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    technologyTipsBtn.borderWidth = 2.f;
    technologyTipsBtn.cornerRadius = 12.f;
    technologyTipsBtn.tag = 701;
    _technologyTipsBtn = technologyTipsBtn;
    [self addSubview:technologyTipsBtn];
    
    UIButton *steadyTipsBtn = [[UIButton alloc]init];
    steadyTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [steadyTipsBtn setTitle:@"稳重成熟" forState:UIControlStateNormal];
    steadyTipsBtn.titleLabel.font = SYRegularFont(13);
    [steadyTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [steadyTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    steadyTipsBtn.borderWidth = 2.f;
    steadyTipsBtn.cornerRadius = 12.f;
    steadyTipsBtn.tag = 702;
    _steadyTipsBtn = steadyTipsBtn;
    [self addSubview:steadyTipsBtn];
    
    UIButton *softTipsBtn = [[UIButton alloc]init];
    softTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [softTipsBtn setTitle:@"温柔体贴" forState:UIControlStateNormal];
    softTipsBtn.titleLabel.font = SYRegularFont(13);
    [softTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [softTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    softTipsBtn.borderWidth = 2.f;
    softTipsBtn.cornerRadius = 12.f;
    softTipsBtn.tag = 703;
    _softTipsBtn = softTipsBtn;
    [self addSubview:softTipsBtn];
    
    UIButton *smartTipsBtn = [[UIButton alloc]init];
    smartTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [smartTipsBtn setTitle:@"英俊潇洒" forState:UIControlStateNormal];
    smartTipsBtn.titleLabel.font = SYRegularFont(13);
    [smartTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [smartTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    smartTipsBtn.borderWidth = 2.f;
    smartTipsBtn.cornerRadius = 12.f;
    smartTipsBtn.tag = 704;
    _smartTipsBtn = smartTipsBtn;
    [self addSubview:smartTipsBtn];
    
    UIButton *durableTipsBtn = [[UIButton alloc]init];
    durableTipsBtn.layer.borderColor = [SYColorFromHexString(@"#9F69EB") CGColor];
    [durableTipsBtn setTitle:@"耐力持久" forState:UIControlStateNormal];
    durableTipsBtn.titleLabel.font = SYRegularFont(13);
    [durableTipsBtn setTitleColor:SYColorFromHexString(@"#9F69EB") forState:UIControlStateNormal];
    [durableTipsBtn setTitleColor:SYColorFromHexString(@"#FFFFFF") forState:UIControlStateSelected];
    durableTipsBtn.borderWidth = 2.f;
    durableTipsBtn.cornerRadius = 12.f;
    durableTipsBtn.tag = 705;
    _durableTipsBtn = durableTipsBtn;
    [self addSubview:durableTipsBtn];
    
    UIButton *completeBtn = [[UIButton alloc]init];
    [completeBtn setBackgroundImage:[UIImage yy_imageWithColor:SYColorFromHexString(@"#9F69EB")] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = SYRegularFont(20);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTintColor:SYColorFromHexString(@"#FF1FFF")];
    completeBtn.tag = 901;
    _completeBtn = completeBtn;
    [self addSubview:completeBtn];
}

#pragma mark - 添加控件约束
- (void)_makeSubViewsConstraints {
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(45);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_jobTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.jobLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.jobLabel.mas_right).offset(30);
    }];
    [_underLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobLabel);
        make.top.equalTo(self.jobLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.incomeLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.incomeLabel.mas_right).offset(30);
    }];
    [_underLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.incomeLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel);
        make.top.equalTo(self.incomeLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_heightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.heightLabel);
        make.right.equalTo(self).offset(-50);
        make.left.equalTo(self.heightLabel.mas_right).offset(30);
    }];
    [_underLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_maritalStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel);
        make.top.equalTo(self.heightLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_maritalStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maritalStatusLabel.mas_right).offset(30);
        make.top.height.equalTo(self.maritalStatusLabel);
        make.right.equalTo(self).offset(-50);
    }];
    [_underLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maritalStatusLabel);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.maritalStatusLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    [_specialtyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maritalStatusLabel);
        make.top.equalTo(self.maritalStatusLabel.mas_bottom).offset(40);
        make.width.offset(50);
        make.height.offset(20);
    }];
    [_strongTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specialtyLabel);
        make.left.equalTo(self.specialtyLabel.mas_right).offset(20);
        make.width.offset(65);
        make.height.offset(25);
    }];
    [_technologyTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.strongTipsBtn);
        make.left.equalTo(self.strongTipsBtn.mas_right).offset(15);
    }];
    if (SY_SCREEN_MAX_LENGTH <= 568.f) {
        [_steadyTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.equalTo(self.strongTipsBtn);
            make.top.equalTo(self.strongTipsBtn.mas_bottom).offset(15);
        }];
        [_softTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.top.equalTo(self.steadyTipsBtn);
            make.left.equalTo(self.steadyTipsBtn.mas_right).offset(15);
        }];
        [_smartTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.equalTo(self.steadyTipsBtn);
            make.top.equalTo(self.steadyTipsBtn.mas_bottom).offset(15);
        }];
        [_durableTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.top.equalTo(self.smartTipsBtn);
            make.left.equalTo(self.smartTipsBtn.mas_right).offset(15);
        }];
    } else {
        [_steadyTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.width.equalTo(self.strongTipsBtn);
            make.left.equalTo(self.technologyTipsBtn.mas_right).offset(15);
        }];
        [_softTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.equalTo(self.strongTipsBtn);
            make.top.equalTo(self.strongTipsBtn.mas_bottom).offset(15);
        }];
        [_smartTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.equalTo(self.softTipsBtn);
            make.left.equalTo(self.softTipsBtn.mas_right).offset(15);
        }];
        [_durableTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.equalTo(self.softTipsBtn);
            make.left.equalTo(self.smartTipsBtn.mas_right).offset(15);
        }];
    }
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.offset(49);
    }];
}

@end
