//
//  SYCollocationCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationCell.h"

@implementation SYCollocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SYColorAlpha(0, 0, 0, 0.01);
        [self _setupSubViews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

// 添加控件
- (void)_setupSubViews {
    // 播放器
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    // 按钮背板
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    // 暂停按钮
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
}

// 添加约束
- (void)_makeSubViewsConstraints {
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)setPlayerUrl:(NSString *)url {
    _playUrl = url;
}

- (void)startDownloadBackgroundTask {
    [_playerView setPlayerWithUrl:_playUrl];
}

- (void)startDownloadHighPriorityTask {
    [_playerView startDownloadTask:[[NSURL alloc] initWithString:_playUrl] isBackground:NO];
}

// AVPlayerUpdateDelegate
- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
//            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
//            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            [_playerView play];
            break;
        case AVPlayerItemStatusFailed:
//            [self startLoadingPlayItemAnim:NO];
//            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

@end
