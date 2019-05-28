//
//  SYTabBar.m
//  WeChat
//
//  Created by senba on 2017/9/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYTabBar.h"
#import "JSBadgeView.h"

@interface SYTabBar ()

/// divider
@property (nonatomic, readwrite, weak) UIView *divider ;

@property (nonatomic, weak) JSBadgeView *badgeView;

@end

@implementation SYTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /// 去掉tabBar的分割线,以及背景图片
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage sy_resizableImage:@"tabbarBkg_5x49"]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadgeValue) name:@"refreshBadgeValue" object:nil];
        
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgeBackgroundColor = [UIColor redColor];   //setting color
        badgeView.badgePositionAdjustment = CGPointMake(- SY_SCREEN_WIDTH / 2 + 20, 10); //微调小红点位置
        badgeView.badgeOverlayColor = [UIColor clearColor]; //设置外圈颜色
        badgeView.badgeStrokeColor = [UIColor redColor];
        [self bringSubviewToFront:badgeView];
        _badgeView = badgeView;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.divider];
    self.divider.sy_height = SYGlobalBottomLineHeight;
    self.divider.sy_width = SY_SCREEN_WIDTH;
}

- (void)refreshBadgeValue {
    // 未读消息数角标
    @weakify(self)
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        if (totalUnreadCount > 0) {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%d",totalUnreadCount];
            [self.badgeView setNeedsLayout];
        } else {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%d",totalUnreadCount];
            [self.badgeView setNeedsLayout];
        }
    });
}

- (void)dealloc {
    SYDealloc;
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshBadgeValue" object:nil];
}

@end
