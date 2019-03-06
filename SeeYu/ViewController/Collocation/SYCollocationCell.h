//
//  SYCollocationCell.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnPlayerReady)(void);

@interface SYCollocationCell : UITableViewCell <AVPlayerUpdateDelegate>

// 视频播放器view
@property (nonatomic, strong) AVPlayerView *playerView;

// 按钮背板
@property (nonatomic, strong) UIView *container;

// 暂停按钮
@property (nonatomic ,strong) UIImageView *pauseIcon;

// 视频url
@property (nonatomic, strong) NSString *playUrl;

// 视频是否已经加载完成
@property (nonatomic, assign) BOOL isPlayerReady;

// 视频加载完成回调
@property (nonatomic, strong) OnPlayerReady onPlayerReady;

// 播放视频
- (void)play;

// 暂停视频
- (void)pause;

// 重新播放
- (void)replay;

// 开启后台视频下载
- (void)startDownloadBackgroundTask;

// 开启前台视频下载
- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
