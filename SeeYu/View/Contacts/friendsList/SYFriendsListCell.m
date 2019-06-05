//
//  SYFriendsListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListCell.h"

@implementation SYFriendsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubViews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubViews {
    UIView *bgView = [UIView new];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 9.f;
    _bgView = bgView;
    [self.contentView addSubview:bgView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.cornerRadius = 22.f;
    headImageView.clipsToBounds = YES;    // 子视图超过父视图部分进行裁剪
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _headImageView = headImageView;
    [bgView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.font = SYFont(12,YES);
    aliasLabel.textColor = SYColor(193, 99, 237);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [bgView addSubview:aliasLabel];
    
    // 未读消息数角标
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self.contentView alignment:JSBadgeViewAlignmentCenterRight];
    badgeView.badgeBackgroundColor = [UIColor redColor];   //setting color
    badgeView.badgePositionAdjustment = CGPointMake(-30, 0); //微调小红点位置
    badgeView.badgeOverlayColor = [UIColor clearColor]; //设置外圈颜色
    badgeView.badgeStrokeColor = [UIColor redColor];
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    _badgeView = badgeView;
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44.f);
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(7.5);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.height.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
