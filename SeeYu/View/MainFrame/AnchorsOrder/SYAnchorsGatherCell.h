//
//  SYAnchorsGatherCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYAnchorsModel.h"
#import "AVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnPlayerReady)(void);

typedef void (^goBack)(void);

typedef void (^focusAnchor)(void);

typedef void (^sendVideo)(void);

@class AVPlayerView;

@interface SYAnchorsGatherCell : UITableViewCell

@property (nonatomic, strong) SYAnchorsModel *model;

// 视频播放器view
@property (nonatomic, strong) AVPlayerView *playerView;

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

// 控制面板
@property (nonatomic, strong) UIView *containerView;

// 头像
@property (nonatomic, strong) UIImageView *headImageView;

// 昵称
@property (nonatomic, strong) UILabel *aliasLabel;

// 年龄
@property (nonatomic, strong) UILabel *ageLabel;

// 关注按钮
@property (nonatomic, strong) UIButton *focusBtn;

// 发起视频按钮
@property (nonatomic, strong) UIButton *videoBtn;

@property (nonatomic, strong) OnPlayerReady    onPlayerReady;

// 返回上一层
@property (nonatomic, strong) goBack goBack;

// 关注主播
@property (nonatomic, strong) focusAnchor focus;

// 发起视频
@property (nonatomic, strong) sendVideo video;

@property (nonatomic, assign) BOOL             isPlayerReady;

- (void)initData:(SYAnchorsModel *)model;

- (void)play;

- (void)pause;

- (void)replay;

- (void)startDownloadBackgroundTask;

- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
