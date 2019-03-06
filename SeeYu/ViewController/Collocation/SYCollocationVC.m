//
//  SYCollocationVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVC.h"
#import "SYCollocationCell.h"
#import "AVPlayerManager.h"

NSString * const collocationCell = @"collocationCell";

@interface SYCollocationVC ()

@end

@implementation SYCollocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;   // 隐藏导航栏
    _dataArray = [NSMutableArray new];
    [_dataArray addObject:@"https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200ff50000bcshae7a1hap4ad0hdh0&line=0&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0"];
    [_dataArray addObject:@"https://aweme.snssdk.com/aweme/v1/play/?video_id=0013151fddac47fea5815b2537d657bd&line=0&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0"];
    [_dataArray addObject:@"https://aweme.snssdk.com/aweme/v1/play/?video_id=v0200fe70000bbra4gq6tgq2ecgca150&line=0&ratio=720p&media_type=4&vr_type=0&test_cdn=None&improve_bitrate=0"];
    [self _setupSubViews];
}

- (void)_setupSubViews {
    CGRect tableViewRect = CGRectMake(0, 0, SY_SCREEN_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT, 3 * SY_SCREEN_WIDTH);
    _bgTableView = [[UITableView alloc] initWithFrame:tableViewRect];
    _bgTableView.center = CGPointMake(SY_SCREEN_WIDTH / 2, (SY_SCREEN_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT) / 2);
    // 上、左、下、右扩展出去的值
    _bgTableView.contentInset = UIEdgeInsetsMake(SY_SCREEN_WIDTH, 0, SY_SCREEN_WIDTH, 0);
    _bgTableView.backgroundColor = SYColorAlpha(0, 0, 0, 0.01);
    _bgTableView.delegate = self;
    _bgTableView.dataSource = self;
    _bgTableView.showsVerticalScrollIndicator = NO;
    _bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bgTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);  // 逆时针旋转90°
    [_bgTableView registerClass:SYCollocationCell.class forCellReuseIdentifier:collocationCell];
    [self.view addSubview:_bgTableView];
    if (@available(iOS 11.0, *)) {
        _bgTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SY_SCREEN_WIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    SYCollocationCell *cell = [tableView dequeueReusableCellWithIdentifier:collocationCell forIndexPath:indexPath];
    [cell setPlayUrl:_dataArray[indexPath.row]];
    [cell startDownloadBackgroundTask];
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);  // 顺时针旋转90°
    return cell;
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        if(translatedPoint.y < -50 && self.currentIndex < (self.dataArray.count - 1)) {
            self.currentIndex ++;   //向右滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向左滑动索引递减
        }
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.bgTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];
    });
}

#pragma KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurrentPlayerPause = NO;
        //获取当前显示的cell
        SYCollocationCell *cell = [self.bgTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [cell startDownloadHighPriorityTask];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            // 播放视频
            [cell replay];
        } else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.bgTableView indexPathForCell:wcell];
                if(!wself.isCurrentPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
