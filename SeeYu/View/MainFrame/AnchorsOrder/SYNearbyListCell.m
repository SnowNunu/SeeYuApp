//
//  SYNearbyListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/16.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYNearbyListCell.h"

@implementation SYNearbyListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIImageView *defaultImageView = [UIImageView new];
    _defaultImageView = defaultImageView;
    [self.contentView addSubview:defaultImageView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    UIImageView *vipImageView = [UIImageView new];
    vipImageView.image = SYImageNamed(@"vip_logo");
    _vipImageView = vipImageView;
    [self.contentView addSubview:vipImageView];
    
    UILabel *distanceLabel = [UILabel new];
    distanceLabel.textColor = SYColor(255, 255, 255);
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = SYFont(9, YES);
    _distanceLabel = distanceLabel;
    [self.contentView addSubview:distanceLabel];
    
    UIView *infoBgView = [UIView new];
    infoBgView.backgroundColor = SYColorAlpha(83, 16, 114, 0.3);
    _infoBgView = infoBgView;
    [self.contentView addSubview:infoBgView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = SYColor(255, 255, 255);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYFont(11, YES);
    _aliasLabel = aliasLabel;
    [infoBgView addSubview:aliasLabel];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textColor = SYColor(255, 255, 255);
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font = SYFont(9, YES);
    _signatureLabel = signatureLabel;
    [infoBgView addSubview:signatureLabel];
}

- (void)_makeSubViewsConstraints {
    [_defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18);
        make.bottom.equalTo(self.infoBgView.mas_top).offset(-18);
        make.centerX.equalTo(self);
        make.width.equalTo(self.defaultImageView.mas_height).multipliedBy(1.175);
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5);
        make.height.offset(12);
        make.width.offset(25);
    }];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.offset(10);
    }];
    [_infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.equalTo(self);
        make.height.offset(36.5);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.signatureLabel);
        make.bottom.equalTo(self.signatureLabel.mas_top).offset(-6);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView).offset(5);
        make.bottom.equalTo(self.infoBgView).offset(-6);
        make.height.offset(10);
        make.right.equalTo(self.infoBgView).offset(-5);
    }];
}

@end
