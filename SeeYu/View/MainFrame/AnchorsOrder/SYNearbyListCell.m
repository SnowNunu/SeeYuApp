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
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.cornerRadius = 4.f;
    headImageView.layer.masksToBounds = YES;
    _headImageView = headImageView;
    [self addSubview:headImageView];
    
    UIView *infoBgView = [UIView new];
    infoBgView.backgroundColor = SYColorAlpha(83, 16, 114, 0.3);
    _infoBgView = infoBgView;
    [self addSubview:infoBgView];
    
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
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
    }];
}

@end
