//
//  SYAnchorsGatherCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsGatherCell.h"


@interface SYAnchorsGatherCell () <AVPlayerUpdateDelegate>

@end

@implementation SYAnchorsGatherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    self.playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:self.playerView];
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    _containerView = containerView;
    [self addSubview:containerView];
    [self bringSubviewToFront:containerView];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:SYImageNamed(@"nav_btn_back") forState:UIControlStateNormal];
    _backBtn = backBtn;
    [containerView addSubview:backBtn];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [containerView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.font = SYRegularFont(20);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [containerView addSubview:aliasLabel];
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = SYRegularFont(18);
    ageLabel.textAlignment = NSTextAlignmentLeft;
    _ageLabel = ageLabel;
    [containerView addSubview:ageLabel];
    
    UIButton *focusBtn = [UIButton new];
    [focusBtn setImage:SYImageNamed(@"home_btn_follow") forState:UIControlStateNormal];
    [focusBtn setImage:SYImageNamed(@"home_btn_followed") forState:UIControlStateSelected];
    _focusBtn = focusBtn;
    [containerView addSubview:focusBtn];
    
    UIButton *videoBtn = [UIButton new];
    [videoBtn setImage:SYImageNamed(@"home_btn_videoChat") forState:UIControlStateNormal];
    _videoBtn = videoBtn;
    [containerView addSubview:videoBtn];
}

- (void)_makeSubViewsConstraints {
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(24);
        make.top.equalTo(self.containerView).offset(40);
        make.left.equalTo(self.containerView).offset(15);
    }];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.left.equalTo(self.containerView).offset(20);
        make.bottom.equalTo(self.focusBtn.mas_top).offset(-30);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.ageLabel);
        make.bottom.equalTo(self.ageLabel.mas_top).offset(-10);
        make.height.offset(20);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView).offset(-5);
        make.height.offset(15);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.containerView).offset(-15);
    }];
    [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.width.offset(0.26 * SY_SCREEN_WIDTH);
        make.bottom.equalTo(self.containerView).offset(-15);
        make.height.offset(0.1 * SY_SCREEN_WIDTH);
    }];
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.5 * SY_SCREEN_WIDTH);
        make.right.equalTo(self).offset(-15);
        make.bottom.height.equalTo(self.focusBtn);
    }];
}

// AVPlayerUpdateDelegate
- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
//            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
            //            [_musicAlum startAnimation:_aweme.rate];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnim:NO];
//            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

- (void)initData:(SYAnchorsModel *)model {
    _model = model;
    _ageLabel.text = [NSString stringWithFormat:@"%@岁",model.userAge];
    _aliasLabel.text = model.userName;
    [_headImageView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYImageNamed(@"add_image") options:SYWebImageOptionAutomatic completion:NULL];
    _focusBtn.selected = model.followFlag == 1;
    [[_backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.goBack) {
            self.goBack();
        }
    }];
    [[_focusBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.focus) {
            self.focus();
        }
    }];
    [[_videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.video) {
            self.video();
        }
    }];
}

- (void)play {
    [_playerView play];
}

- (void)pause {
    [_playerView pause];
}

- (void)replay {
    [_playerView replay];
}

- (void)startDownloadBackgroundTask {
    [_playerView setPlayerWithUrl:_model.showVideo];
}

- (void)startDownloadHighPriorityTask {
    [_playerView startDownloadTask:[[NSURL alloc] initWithString:_model.showVideo] isBackground:NO];
}

@end
