//
//  SYSearchFriendsHeaderView.m
//  WeChat
//
//  Created by senba on 2017/9/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYSearchFriendsHeaderView.h"
#import "SYSearchFriendsHeaderViewModel.h"
@interface SYSearchFriendsHeaderView ()
/// WeChatId
@property (weak, nonatomic) IBOutlet UILabel *weChatIdLabel;

/// 二维码
@property (weak, nonatomic) IBOutlet UIButton *qrCodeBtn;

/// viewModel
@property (nonatomic, readwrite, strong) SYSearchFriendsHeaderViewModel *viewModel;
@end


@implementation SYSearchFriendsHeaderView

+ (instancetype)headerView{
    return [self sy_viewFromXib];
}

- (void)bindViewModel:(SYSearchFriendsHeaderViewModel *)viewModel{
    self.viewModel = viewModel;
    self.weChatIdLabel.text = [NSString stringWithFormat:@"我的微信号：%@",viewModel.user.wechatId];
    [self.weChatIdLabel sizeToFit];
    [self setNeedsLayout];
}

#pragma mark - 事件处理
- (IBAction)_qrCodeBtnDidClicked:(UIButton *)sender {
    /// 点击二维码
    
}

- (IBAction)_searchBtnDidClicked:(UIButton *)sender {
//    [self.viewModel.searchCommand execute:nil];
    /// 回调
    !self.searchCallback ? : self.searchCallback(self);
}
#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.weChatIdLabel.sy_width + 13 + 20;
    
    self.weChatIdLabel.sy_x = (self.sy_width - width)*.5;
    self.weChatIdLabel.sy_height = 36.0f;
    
    self.qrCodeBtn.sy_size = CGSizeMake(20, 20);
    self.qrCodeBtn.sy_x = self.weChatIdLabel.right + 13.0f;
    self.qrCodeBtn.sy_centerY = self.weChatIdLabel.sy_centerY;
}

@end
