//
//  SYAnchorsListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsListCell.h"

@implementation SYAnchorsListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    self.layer.cornerRadius = 3.5f;
    self.layer.masksToBounds = YES;
    
    UIImageView *headImageView = [UIImageView new];
//    headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    headImageView.clipsToBounds = YES;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.backgroundColor = SYColorAlpha(83, 16, 114, 0.3);
    _bgImageView = bgImageView;
    [self.contentView addSubview:bgImageView];
    
    UIImageView *onlineStatusImageView = [UIImageView new];
    _onlineStatusImageView = onlineStatusImageView;
    [self.contentView addSubview:onlineStatusImageView];
    
    UIImageView *voiceImageView = [UIImageView new];
    voiceImageView.image = SYImageNamed(@"play");
    _voiceImageView = voiceImageView;
    [bgImageView addSubview:voiceImageView];
    
    UIImageView *diamondImageView = [UIImageView new];
    diamondImageView.image = SYImageNamed(@"diamond");
    _diamondImageView = diamondImageView;
    [bgImageView addSubview:diamondImageView];
    
    UILabel *voicePriceLabel = [UILabel new];
    voicePriceLabel.textAlignment = NSTextAlignmentRight;
    voicePriceLabel.textColor = [UIColor whiteColor];
    voicePriceLabel.font = SYFont(9, YES);
    _voicePriceLabel = voicePriceLabel;
    [bgImageView addSubview:voicePriceLabel];
}

- (void)_makeSubViewsConstraints {
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [_onlineStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.right.equalTo(self.contentView).offset(-2);
        make.width.offset(54);
        make.height.offset(20);
    }];
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(19);
        make.height.offset(14);
        make.right.equalTo(self.diamondImageView.mas_left).offset(-2);
        make.centerY.equalTo(self.bgImageView);
    }];
    [_diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView);
        make.height.offset(20);
        make.width.offset(25);
        make.right.equalTo(self.voicePriceLabel.mas_left).offset(-2);
    }];
    [_voicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-9);
        make.height.offset(15);
        make.centerY.equalTo(self.bgImageView);
    }];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.offset(25);
    }];
}

- (void)setTipsByHobby:(NSString*)hobby {
    // 解决UICollectionViewCell复用出现的问题
    for (int i = 0; i < 3; i++) {
        UIImageView *lastImageView = [self viewWithTag:588 + i];
        if (lastImageView != nil) {
            [lastImageView removeFromSuperview];
        }
        UILabel *lastLabel = [self viewWithTag:888 + i];
        if (lastLabel != nil) {
            [lastLabel removeFromSuperview];
        }
    }
    NSArray *hobbiesArray = [hobby componentsSeparatedByString:@","];
    if (hobbiesArray.count > 0 && hobbiesArray.count <= 3) {
        for (int i = 0; i < hobbiesArray.count; i++) {
            UIImageView *bgImageView = [UIImageView new];
            bgImageView.image = SYImageNamed(@"tag_bg0");
            bgImageView.tag = 588 + i;
            [self.contentView addSubview:bgImageView];
            
            UILabel *tipsLabel = [UILabel new];
            tipsLabel.textColor = [UIColor whiteColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.font = SYFont(12, YES);
            tipsLabel.text = hobbiesArray[i];
            tipsLabel.tag = 888 + i;
            [self.contentView addSubview:tipsLabel];
            
            [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(45);
                make.height.offset(17);
                make.left.equalTo(self).offset(3 + i * 48);
                make.bottom.equalTo(self.bgImageView.mas_top).offset(-3);
            }];
            [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgImageView);
            }];
        }
    }
}

- (void)setStarsByLevel:(int)level {
    // 解决UICollectionViewCell复用出现的问题
    for (int i = 0; i < 5; i++) {
        UIImageView *lastImageView = [self viewWithTag:988 + i];
        if (lastImageView != nil) {
            [lastImageView removeFromSuperview];
        }
    }
    for (int i = 0; i < level; i++) {
        UIImageView *starImageView = [UIImageView new];
        starImageView.image= SYImageNamed(@"star");
        starImageView.tag = 988 + i;
        [self.contentView addSubview:starImageView];
        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.equalTo(self.contentView).offset(i * 20);
            make.centerY.equalTo(self.onlineStatusImageView);
        }];
    }
}

- (void)setScrollAliasLabel:(NSString *)alias {
    [_aliasScrolLabel removeFromSuperview];
    TXScrollLabelView *aliasScrolLabel = [TXScrollLabelView scrollWithTitle:alias type:TXScrollLabelViewTypeLeftRight];
    aliasScrolLabel.frame = CGRectMake(3, self.contentView.height - 20, self.contentView.width - 95, 15);
    aliasScrolLabel.textAlignment = NSTextAlignmentLeft;
    aliasScrolLabel.font = SYFont(12, YES);
    aliasScrolLabel.backgroundColor = [UIColor clearColor];
    aliasScrolLabel.scrollTitleColor = [UIColor whiteColor];
    aliasScrolLabel.scrollSpace = 20.f;
    _aliasScrolLabel = aliasScrolLabel;
    [self.contentView addSubview:aliasScrolLabel];
    [aliasScrolLabel beginScrolling];
}

@end
