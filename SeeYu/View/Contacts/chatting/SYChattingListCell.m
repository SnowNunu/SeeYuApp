//
//  SYChattingListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYChattingListCell.h"

@implementation SYChattingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 8.5f;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    _bgView = bgView;
    [self.contentView addSubview:bgView];
    
    // 用户头像
    UIImageView *avatarImageView = [UIImageView new];
    avatarImageView.layer.cornerRadius = 22.f;
    avatarImageView.clipsToBounds = YES;    // 子视图超过父视图部分进行裁剪
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [avatarImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _avatarImageView = avatarImageView;
    [bgView addSubview:avatarImageView];
    
    // 用户昵称
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.font = SYFont(11, YES);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.textColor = SYColor(100, 100, 100);
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
    
    // 消息内容
    UILabel *contentLabel = [UILabel new];
    contentLabel.font = SYFont(10, YES);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = SYColor(100, 100, 100);
//    contentLabel.textColor = SYColor(193, 99, 237);
    _contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    // 最后一条消息时间
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = SYFont(10, YES);
    timeLabel.textAlignment = NSTextAlignmentRight;
//    timeLabel.textColor = SYColor(193, 99, 237);
    timeLabel.textColor = SYColor(100, 100, 100);
    _timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    // 角标背景
    UIView *badgeBgView = [UIView new];
    badgeBgView.backgroundColor = [UIColor clearColor];
    _badgeBgView = badgeBgView;
    [self.contentView addSubview:badgeBgView];
    [self.contentView bringSubviewToFront:badgeBgView];
    
    // 未读消息数角标
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:badgeBgView alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeBackgroundColor = [UIColor redColor];   //setting color
    badgeView.badgePositionAdjustment = CGPointMake(0, 5); //微调小红点位置
    badgeView.badgeOverlayColor = [UIColor clearColor]; //设置外圈颜色
    badgeView.badgeStrokeColor = [UIColor redColor];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    _badgeView = badgeView;
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = SYColor(242, 242, 242);
    _lineImageView = lineImageView;
    [bgView addSubview:lineImageView];
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(7.5);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(13);
        make.height.offset(15);
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aliasLabel.mas_bottom).offset(7);
        make.height.left.equalTo(self.aliasLabel);
        make.right.equalTo(self.timeLabel.mas_left).offset(-5);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-16);
        make.centerY.equalTo(self.bgView);
        make.height.offset(20);
        make.width.offset(35);
    }];
    [_badgeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatarImageView);
    }];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bgView);
        make.height.offset(1);
    }];
}

@end
