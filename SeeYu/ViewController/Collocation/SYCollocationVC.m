//
//  SYCollocationVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVC.h"
#import "JPVideoPlayerKit.h"

@interface SYCollocationVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *singleShowView;

@property (nonatomic, strong) UIScrollView *controlView;

@property (nonatomic, strong) UIView *headBgView;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *aliasLabel;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIImageView *unlikeImageView;

@property (nonatomic, strong) UIButton *unlikeBtn;

@property (nonatomic, assign) NSString *direction;

@property (nonatomic, assign) BOOL canLoadMore;

@property (nonatomic, assign) int loadTime;

@end

@implementation SYCollocationVC

- (NSMutableArray *)datasource {
    if (_datasource == nil) {
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
    [self reloadCacheData];
    NSLog(@"%@",[[NSDate sy_currentTimestamp] substringToIndex:10]);
    [self judgeWhetherCanLoadMore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.singleShowView.jp_playerStatus == JPVideoPlayerStatusStop) {
        [self.singleShowView jp_resumePlayWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.singleShowView jp_stopPlay];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, speedMatchList) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            if (array.count == 0) {
                // 此时服务器中没有更多的数据了，重置页码为0
                YYCache *cache = [YYCache cacheWithName:@"seeyu"];
                [cache setObject:@"1" forKey:@"speedMatchPage"];
                self.page = @"1";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.viewModel.requestSpeedMatchCommand execute:@"1"];
                });
            } else {
                // 从服务器上拉取到的新数据
                self.datasource = [NSMutableArray arrayWithArray:array];
                YYCache *cache = [YYCache cacheWithName:@"seeyu"];
                [cache setObject:self.datasource forKey:@"speedMatch"];
                [self startUserShow];
            }
        }
    }];
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self judgeWhetherCanLoadMore];
        if (self.canLoadMore) {
            if (self.loadTime > SY_LOAD_TIME_PER_DAY) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
                [self changeUser];  // 会员无限制
            } else if (self.loadTime > 0) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
                [self writeCanLoadMoreCache];
                [self changeUser];
            } else {
                [self openRechargeTipsView:@"vip"];
            }
        } else {
            [self openRechargeTipsView:@"vip"];
        }
    }];
    [[self.unlikeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self judgeWhetherCanLoadMore];
        if (self.canLoadMore) {
            if (self.loadTime > SY_LOAD_TIME_PER_DAY) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
                [self changeUser];  // 会员无限制
            } else if (self.loadTime > 0) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
                [self writeCanLoadMoreCache];
                [self changeUser];
            } else {
                [self openRechargeTipsView:@"vip"];
            }
        } else {
            [self openRechargeTipsView:@"vip"];
        }
    }];
}

- (void)_setupSubViews {
    UIView *singleShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT)];
    _singleShowView = singleShowView;
    [self.view addSubview:singleShowView];
    
    UIScrollView *controlView = [UIScrollView new];
    controlView.delegate = self;
    controlView.contentSize = CGSizeMake(SY_SCREEN_WIDTH * 2, 0);
    controlView.showsHorizontalScrollIndicator = NO;
    _controlView = controlView;
    [self.view addSubview:controlView];
    [self.view bringSubviewToFront:controlView];
    
    UIView *headBgView = [UIView new];
    headBgView.backgroundColor = SYColorAlpha(83, 16, 114, 0.2);
    _headBgView = headBgView;
    [controlView addSubview:headBgView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.cornerRadius = 22.f;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    headImageView.clipsToBounds = YES;
    _headImageView = headImageView;
    [headBgView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.textColor = [UIColor whiteColor];
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    aliasLabel.font = SYFont(13, YES);
    _aliasLabel = aliasLabel;
    [headBgView addSubview:aliasLabel];
    
    UILabel *signatureLabel = [UILabel new];
    signatureLabel.textColor = [UIColor whiteColor];
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.font = SYFont(10, YES);
    _signatureLabel = signatureLabel;
    [headBgView addSubview:signatureLabel];

    UIImageView *unlikeImageView = [UIImageView new];
    unlikeImageView.image = SYImageNamed(@"arrorLeft");
    _unlikeImageView = unlikeImageView;
    [controlView addSubview:unlikeImageView];
    
    UIButton *unlikeBtn = [UIButton new];
    [unlikeBtn setImage:SYImageNamed(@"unlike") forState:UIControlStateNormal];
    _unlikeBtn = unlikeBtn;
    [controlView addSubview:unlikeBtn];
    
    UIImageView *likeImageView = [UIImageView new];
    likeImageView.image = SYImageNamed(@"arrorRight");
    _likeImageView = likeImageView;
    [controlView addSubview:likeImageView];
    
    UIButton *likeBtn = [UIButton new];
    [likeBtn setImage:SYImageNamed(@"like") forState:UIControlStateNormal];
    _likeBtn = likeBtn;
    [controlView addSubview:likeBtn];
    
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(singleShowView);
    }];
    [headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(singleShowView);
        make.height.offset(SY_APPLICATION_STATUS_BAR_HEIGHT + 54);
    }];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headBgView).offset(-5);
        make.width.height.offset(44);
        make.left.equalTo(headBgView).offset(5);
    }];
    [aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView).offset(5);
        make.left.equalTo(headImageView.mas_right).offset(6);
        make.height.offset(15);
    }];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(aliasLabel);
        make.bottom.equalTo(headBgView).offset(-13);
    }];
    [unlikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singleShowView).offset(47);
        make.centerY.equalTo(unlikeBtn);
        make.width.offset(14);
        make.height.offset(19);
    }];
    [unlikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(57);
        make.bottom.equalTo(singleShowView).offset(-27);
        make.left.equalTo(unlikeImageView.mas_right).offset(3);
    }];
    [likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(singleShowView).offset(-47);
        make.centerY.equalTo(likeBtn);
        make.width.offset(14);
        make.height.offset(19);
    }];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(unlikeBtn);
        make.right.equalTo(likeImageView.mas_left).offset(-3);
    }];
}

// 加载缓存数据
- (void)reloadCacheData {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
//    [cache removeObjectForKey:@"speedMatch"];
//    [cache removeObjectForKey:@"speedMatchPage"];
    if ([cache containsObjectForKey:@"speedMatch"]) {
        // 有缓存数据优先读取缓存数据
        id dataValue = [cache objectForKey:@"speedMatch"];
        self.datasource = (NSMutableArray*)dataValue;
        id pageValue = [cache objectForKey:@"speedMatchPage"];
        NSString *page = (NSString*)pageValue;
        if (self.datasource.count <= 0) {
            page = [NSString stringWithFormat:@"%d",[page intValue] + 1];
            [self.viewModel.requestSpeedMatchCommand execute:page];
            [cache setObject:page forKey:@"speedMatchPage"];
        } else {
            [self startUserShow];
        }
        self.page = page;
    } else {
        // 初次使用没有缓存数据
        if ([cache containsObjectForKey:@"speedMatchPage"]) {
            // 读取页码
            id pageValue = [cache objectForKey:@"speedMatchPage"];
            self.page = (NSString*)pageValue;
            [self.viewModel.requestSpeedMatchCommand execute:self.page];
        } else {
            // 设置页码页面为1
            [cache setObject:@"1" forKey:@"speedMatchPage"];
            self.page = @"1";
            [self.viewModel.requestSpeedMatchCommand execute:self.page];
        }
    }
}

// 读取数组元素播放展示页
- (void)startUserShow {
    self.matchModel = self.datasource[0];
    [_singleShowView jp_playVideoWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        
    }];
    [_headImageView yy_setImageWithURL:[NSURL URLWithString:self.matchModel.userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    if (self.matchModel.userName != nil && self.matchModel.userName.length > 0) {
        _aliasLabel.text = self.matchModel.userName;
    }
    if (self.matchModel.userSignature != nil && self.matchModel.userSignature.length > 0) {
        _signatureLabel.text = self.matchModel.userSignature;
    }
    if (self.matchModel.userSpecialty != nil && self.matchModel.userSpecialty.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self setTipsByHobby:self.matchModel.userSpecialty];
        });
    }
}

// 切换用户
- (void)changeUser {
    if (self.datasource.count > 1) {
        [self.datasource removeObjectAtIndex:0];
        [self.singleShowView jp_stopPlay];
        self.matchModel = self.datasource[0];
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        [cache setObject:self.datasource forKey:@"speedMatch"];
        [self.singleShowView jp_playVideoWithURL:[NSURL URLWithString:self.matchModel.showVideo] options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        
        }];
        [_headImageView yy_setImageWithURL:[NSURL URLWithString:self.matchModel.userHeadImg] placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
        if (self.matchModel.userName != nil && self.matchModel.userName.length > 0) {
            _aliasLabel.text = self.matchModel.userName;
        }
        if (self.matchModel.userSignature != nil && self.matchModel.userSignature.length > 0) {
            _signatureLabel.text = self.matchModel.userSignature;
        }
        if (self.matchModel.userSpecialty != nil && self.matchModel.userSpecialty.length > 0) {
            [self setTipsByHobby:self.matchModel.userSpecialty];
        }
    } else {
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        self.page = [NSString stringWithFormat:@"%d",self.page.intValue + 1];
        [cache setObject:self.page forKey:@"speedMatchPage"];
        [self.viewModel.requestSpeedMatchCommand execute:self.page];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
    if(translatedPoint.x < 0) {
        _direction = @"left";
    } else {
        _direction = @"right";
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self judgeWhetherCanLoadMore];
    if (self.canLoadMore) {
        if (self.loadTime > SY_LOAD_TIME_PER_DAY) {
            [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
            if ([_direction isEqualToString:@"right"]) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
            }
            [self changeUser];  // 会员无限制
        } else if (self.loadTime > 0) {
            [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
            if ([_direction isEqualToString:@"right"]) {
                [self.viewModel.matchLikeCommand execute:self.matchModel.userId];
            }
            [self writeCanLoadMoreCache];
            [self changeUser];
        } else {
            [self openRechargeTipsView:@"vip"];
        }
    } else {
        [self openRechargeTipsView:@"vip"];
    }
}

- (void)setTipsByHobby:(NSString*)hobby {
    for (int i = 0; i < 3; i++) {
        UIImageView *lastImageView = [self.view viewWithTag:588 + i];
        if (lastImageView != nil) {
            [lastImageView removeFromSuperview];
        }
        UILabel *lastLabel = [self.view viewWithTag:888 + i];
        if (lastLabel != nil) {
            [lastLabel removeFromSuperview];
        }
    }
    NSArray *hobbiesArray = [hobby componentsSeparatedByString:@","];
    if (hobbiesArray.count > 0 && hobbiesArray.count <= 3) {
        for (int i = 0; i < hobbiesArray.count; i++) {
            UIImageView *bgImageView = [UIImageView new];
            NSString *imageName = [NSString stringWithFormat:@"tag_bg%d",i];
            bgImageView.image = SYImageNamed(imageName);
            bgImageView.tag = 588 + i;
            [_headBgView addSubview:bgImageView];
            
            UILabel *tipsLabel = [UILabel new];
            tipsLabel.textColor = [UIColor whiteColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.font = SYFont(12, YES);
            tipsLabel.text = hobbiesArray[i];
            tipsLabel.tag = 888 + i;
            [_headBgView addSubview:tipsLabel];
            
            [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(45);
                make.height.offset(17);
                make.right.equalTo(self.headBgView).offset(- 5 + (2 - i) * (-48));
                make.top.equalTo(self.headImageView);
            }];
            [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bgImageView);
            }];
        }
    }
}

- (void)judgeWhetherCanLoadMore {
    SYUser *user = self.viewModel.services.client.currentUser;
    if (user.userVipStatus == 1) {
        if (user.userVipExpiresAt != nil) {
            
            if ([NSDate sy_overdue:user.userVipExpiresAt]) {
                // 会员已过期的情况
                YYCache *cache = [YYCache cacheWithName:@"seeyu"];
                if ([cache containsObjectForKey:@"loadMoreInfo"]) {
                    NSString *value = (NSString *)[cache objectForKey:@"loadMoreInfo"];
                    NSArray *array = [value componentsSeparatedByString:@"*"];
                    NSString *date = array.firstObject;
                    if ([date isEqualToString:[[NSDate sy_currentTimestamp] substringToIndex:10]]) {
                        int time = [(NSString *)array[1] intValue];
                        self.loadTime = time;
                        self.canLoadMore = time > 0 ? YES : NO;
                    } else {
                        self.loadTime = SY_LOAD_TIME_PER_DAY;
                        self.canLoadMore = YES;
                        [cache setObject:[NSString stringWithFormat:@"%@*%d",[[NSDate sy_currentTimestamp] substringToIndex:10],_loadTime] forKey:@"loadMoreInfo"];
                    }
                } else {
                    // 读取不到则是首次使用
                    self.canLoadMore = YES;
                    self.loadTime = SY_LOAD_TIME_PER_DAY;  // 每天限制使用五次
                    [self writeCanLoadMoreCache];
                }
            } else {
                // 会员未过期
                self.canLoadMore = YES;
                self.loadTime = SY_LOAD_TIME_PER_DAY + 1;
            }
        }
    } else {
        // 未开通会员
        YYCache *cache = [YYCache cacheWithName:@"seeyu"];
        if ([cache containsObjectForKey:@"loadMoreInfo"]) {
            NSString *value = (NSString *)[cache objectForKey:@"loadMoreInfo"];
            NSArray *array = [value componentsSeparatedByString:@"*"];
            NSString *date = array.firstObject;
            if ([date isEqualToString:[[NSDate sy_currentTimestamp] substringToIndex:10]]) {
                int time = [(NSString *)array[1] intValue];
                self.loadTime = time;
                self.canLoadMore = time > 0 ? YES : NO;
            } else {
                self.loadTime = SY_LOAD_TIME_PER_DAY;
                self.canLoadMore = YES;
                [cache setObject:[NSString stringWithFormat:@"%@*%d",[[NSDate sy_currentTimestamp] substringToIndex:10],_loadTime] forKey:@"loadMoreInfo"];
            }
        } else {
            // 读取不到则是首次使用
            self.canLoadMore = YES;
            self.loadTime = SY_LOAD_TIME_PER_DAY;  // 每天限制使用五次
            [self writeCanLoadMoreCache];
        }
    }
}

- (void)writeCanLoadMoreCache {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if (_loadTime > 0) {
        if ([cache containsObjectForKey:@"loadMoreInfo"]) {
            _loadTime = --_loadTime;
            NSString *value = (NSString *)[cache objectForKey:@"loadMoreInfo"];
            NSArray *array = [value componentsSeparatedByString:@"*"];
            NSString *date = array.firstObject;
            if ([date isEqualToString:[[NSDate sy_currentTimestamp] substringToIndex:10]]) {
                [cache setObject:[NSString stringWithFormat:@"%@*%d",date,_loadTime] forKey:@"loadMoreInfo"];
            } else {
                _loadTime = SY_LOAD_TIME_PER_DAY;
                [cache setObject:[NSString stringWithFormat:@"%@*%d",[[NSDate sy_currentTimestamp] substringToIndex:10],_loadTime] forKey:@"loadMoreInfo"];
            }
        } else {
            NSString *value = [NSString stringWithFormat:@"%@*%d",[[NSDate sy_currentTimestamp] substringToIndex:10],_loadTime];
            [cache setObject:value forKey:@"loadMoreInfo"];
        }
    } else {
        self.canLoadMore = NO;
    }
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

@end
