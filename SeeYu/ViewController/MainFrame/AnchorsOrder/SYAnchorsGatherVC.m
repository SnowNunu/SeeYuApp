//
//  SYAnchorsGatherVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/29.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsGatherVC.h"
#import "AVPlayerManager.h"

NSString * const anchorsGatherCell   = @"anchorsGatherCell";

@interface SYAnchorsGatherVC () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isCurPlayerPause;

@property (nonatomic, strong) UITableView *tableView;

// 当前主播下标
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SYAnchorsGatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestAllAnchorsInfoCommand execute:nil];
    [SYNotificationCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [SYNotificationCenter addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [SYNotificationCenter addObserver:self selector:@selector(resumeVideo) name:@"hangUp" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_tableView.layer removeAllAnimations];
    NSArray<SYAnchorsGatherCell *> *cells = [_tableView visibleCells];
    for(SYAnchorsGatherCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array.count > 0) {
            [self.tableView reloadData];
            self.currentIndex = self.viewModel.currentIndex;
            NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
        }
    }];
}

- (void)_setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -SY_SCREEN_HEIGHT, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT * 3)];
    tableView.contentInset = UIEdgeInsetsMake(SY_SCREEN_HEIGHT, 0, SY_SCREEN_HEIGHT * 1, 0);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SYAnchorsGatherCell class] forCellReuseIdentifier:anchorsGatherCell];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)_makeSubViewsConstraints {
    
}

#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    SYAnchorsGatherCell *cell = [tableView dequeueReusableCellWithIdentifier:anchorsGatherCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[SYAnchorsGatherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:anchorsGatherCell];
    }
    SYAnchorsModel *model = self.viewModel.datasource[indexPath.row];
    [cell initData:model];
    [cell startDownloadBackgroundTask];
    __weak typeof (cell) wcell = cell;
    __weak typeof (self) wself = self;
    cell.goBack = ^{
        [self.viewModel.services popViewModelAnimated:YES];
    };
    cell.focus = ^{
        NSDictionary *params = @{@"userId":self.viewModel.services.client.currentUser.userId,@"userAnchorId":model.userId};
        [[self.viewModel.focusAnchorCommand execute:params] subscribeNext:^(id x) {
            wcell.focusBtn.selected = !wcell.focusBtn.selected;
        }];
    };
    cell.video = ^{
        SYUser *user = self.viewModel.services.client.currentUser;
        BOOL controlSwitch = NO;
        YYCache *cache = [YYCache cacheWithName:@"SeeYu"];
        if ([cache containsObjectForKey:@"controlSwitch"]) {
            // 有缓存数据优先读取缓存数据
            id value = [cache objectForKey:@"controlSwitch"];
            NSString *state = (NSString *) value;
            controlSwitch = [state isEqualToString:@"0"] ? YES : NO;
        } else {
            controlSwitch = NO;
        }
        if (controlSwitch) {
            // 不判断VIP状态
            if (user.userDiamond > model.anchorChatCost.intValue) {
                [wcell.playerView pause];
                [[RCCall sharedRCCall] startSingleCall:model.userId mediaType:RCCallMediaVideo];
            } else {
                [wself openRechargeTipsView:@"diamonds"];
            }
        } else {
            if (user.userVipStatus == 1) {
                if (user.userVipExpiresAt != nil) {
                    if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                        // 会员已过期的情况
                        [wself openRechargeTipsView:@"vip"];
                    } else {
                        // 会员未过期
                        if (user.userDiamond > model.anchorChatCost.intValue) {
                            if (model.userOnline == 0) {
                                // 主播忙碌状态不允许视频
                                [MBProgressHUD sy_showTips:@"用户忙碌中，请稍候再试"];
                            } else {
                                [wcell.playerView pause];
                                [[RCCall sharedRCCall] startSingleCall:model.userId mediaType:RCCallMediaVideo];
                            }
                        } else {
                            [wself openRechargeTipsView:@"diamonds"];
                        }
                    }
                }
            } else {
                // 未开通会员
                [wself openRechargeTipsView:@"vip"];
            }
        }
    };
    return cell;
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        
        if(translatedPoint.y < -50 && self.currentIndex < (self.viewModel.datasource.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //UITableView滑动到指定cell
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        } completion:^(BOOL finished) {
            //UITableView可以响应其他滑动手势
            scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
}

#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        SYAnchorsGatherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [cell startDownloadHighPriorityTask];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        } else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)applicationBecomeActive {
    SYAnchorsGatherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    SYAnchorsGatherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

// 打开权限弹窗
- (void)openRechargeTipsView:(NSString *)type {
    SYPopViewVM *popVM = [[SYPopViewVM alloc] initWithServices:self.viewModel.services params:nil];
    popVM.type = type;
    SYPopViewVC *popVC = [[SYPopViewVC alloc] initWithViewModel:popVM];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionMoveIn;
    [SYSharedAppDelegate presentVC:popVC withAnimation:animation];
}

- (void)resumeVideo {
    SYAnchorsGatherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [cell.playerView play];
}

@end
