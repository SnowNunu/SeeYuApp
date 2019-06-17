//
//  SYGiftListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/6/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYGiftListCell.h"

@implementation SYGiftListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIButton *giftBtn = [UIButton new];
    [giftBtn setImage:SYImageNamed(@"message_border") forState:UIControlStateSelected];
    _giftBtn = giftBtn;
    [self.contentView addSubview:giftBtn];
    
    UIImageView *imageView = [UIImageView new];
    _imageView = imageView;
    [giftBtn addSubview:imageView];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = SYColorFromHexString(@"#9F69EB");
    priceLabel.font = SYRegularFont(13);
    _priceLabel = priceLabel;
    [giftBtn addSubview:priceLabel];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = SYColorFromHexString(@"#999999");
    titleLabel.font = SYRegularFont(12);
    _titleLabel = titleLabel;
    [giftBtn addSubview:titleLabel];
}

- (void)_makeSubViewsConstraints {
    CGFloat btnWidth = (SY_SCREEN_WIDTH - 15 * 7) / 4 - 1;
    CGFloat btnHeight = 1.45 * btnWidth;
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftBtn).offset(0.125 * btnHeight);
        make.centerX.equalTo(self.giftBtn);
        make.width.height.offset(btnWidth * 0.58);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.height.offset(12);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.height.offset(12);
    }];
}

@end
