//
//  SYSigninVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/24.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYSigninVC.h"

@interface SYSigninVC ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *signinBtn;

@end

@implementation SYSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (void)_setupSubViews {
    self.view.backgroundColor = SYColorAlpha(0, 0, 0, 0.2);
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SYAppDelegate sharedDelegate] dismissViewController:self];
        });
    }];
    [self.view addGestureRecognizer:tap];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 15.f;
    _bgView = bgView;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tapNone = [UITapGestureRecognizer new];
    [[tapNone rac_gestureSignal] subscribeNext:^(id x) {
        //
    }];
    [bgView addGestureRecognizer:tapNone];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = SYColor(159, 105, 235);
    titleLabel.textColor = SYColor(255, 255, 255);
    titleLabel.font = SYRegularFont(17);
    titleLabel.text = @"";
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat height = (SY_SCREEN_WIDTH - 30) * 0.82;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.height.offset(height);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.equalTo(self.bgView);
        make.height.equalTo(self.bgView).multipliedBy(0.14);
    }];
}

@end
