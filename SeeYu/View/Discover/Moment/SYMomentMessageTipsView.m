//
//  SYMomentMessageTipsView.m
//  SYDevelopExample
//
//  Created by senba on 2017/7/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMomentMessageTipsView.h"
#import "SYMomentProfileViewModel.h"
@interface SYMomentMessageTipsView ()

/// 右箭头
@property (nonatomic, readwrite, weak) UIImageView *rightArrow;

/// viewModel
@property (nonatomic, readwrite, strong) SYMomentProfileViewModel *viewModel;

@end

@implementation SYMomentMessageTipsView

+ (instancetype)messageTipsView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
    }
    return self;
}

#pragma mark - BindData
- (void)bindViewModel:(SYMomentProfileViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self yy_setImageWithURL:viewModel.unreadUser.profileImageUrl forState:UIControlStateNormal placeholder:SYDefaultAvatar(SYDefaultAvatarTypeSmall) options:YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask completion:nil];
    
    
    
    @weakify(self);
    [[RACObserve(viewModel , unread)
      distinctUntilChanged]
     subscribeNext:^(NSNumber * unread) {
         @strongify(self);
         [self setTitle:viewModel.unreadTips forState:UIControlStateNormal];
     }];
}


#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.backgroundColor = [UIColor whiteColor];
    
    [self setBackgroundImage:[SYImageNamed(@"wx_AlbumTimeLineTipBkg_50x40") resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateNormal];
    [self setBackgroundImage:[SYImageNamed(@"wx_AlbumTimeLineTipBkgHL_50x40") resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)] forState:UIControlStateHighlighted];
    
    /// setup
    self.titleLabel.font = SYMediumFont(12.0f);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    /// 右箭头
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:SYImageNamed(@"wx_albumTimeLineTipArrow_15x15") highlightedImage:SYImageNamed(@"wx_AlbumTimeLineTipArrowHL_15x15")];
    self.rightArrow = rightArrow;
    [self addSubview:rightArrow];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /// 布局头像
    self.imageView.sy_size = CGSizeMake(SYMomentProfileViewTipsViewAvatarWH, SYMomentProfileViewTipsViewAvatarWH);
    self.imageView.sy_x = SYMomentProfileViewTipsViewInnerInset;
    self.imageView.sy_centerY = self.sy_height * .5f;
    
    
    /// 布局右箭头
    self.rightArrow.sy_x =  self.sy_width - SYMomentProfileViewTipsViewRightInset - SYMomentProfileViewTipsViewRightArrowWH;
    self.rightArrow.sy_centerY = self.imageView.sy_centerY ;
    
    
    /// 布局文字
    self.titleLabel.sy_x = CGRectGetMaxX(self.imageView.frame)+SYMomentProfileViewTipsViewInnerInset;
    self.titleLabel.sy_width = CGRectGetMinX(self.rightArrow.frame)-self.titleLabel.sy_x-SYMomentProfileViewTipsViewInnerInset;
    self.titleLabel.sy_centerY = self.imageView.sy_centerY ;
    
}
@end
