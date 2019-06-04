//
//  SYMainFrameVC.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMainFrameVC.h"
#import "SYAnchorsOrderVC.h"
#import "SYNearbyVC.h"
#import "SYRankingVC.h"
#import "SYAnchorsRandomVC.h"
#import "SYGiftPackageVM.h"
#import "SYGiftPackageVC.h"
#import "SYGiftPackageModel.h"

@interface SYMainFrameVC ()

/// viewModel
@property (nonatomic, readwrite, strong) SYMainFrameVM *viewModel;

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@property (nonatomic, strong) SYUser *user;

@end

@implementation SYMainFrameVC

@dynamic viewModel;

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    self.user = viewModel.services.client.currentUser;
    return self;
}

/// 子类代码逻辑
- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置导航栏
    [self _setupNavigation];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 获取用户地理位置
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;   //最佳精度
    [self startLocating];   // 开启定位
    [self.viewModel.requestPermissionsCommand execute:nil];
    [self.viewModel.loginReportCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
    [RACObserve(self, user) subscribeNext:^(SYUser *user) {
        if (user != nil) {
            // 这里没有去服务器重新请求一下当前用户的信息，因为考虑到注册时间不会变
            NSTimeInterval interval = 8 * 3600 - [self.user.userRegisterTime timeIntervalSinceNow];
            if (!(interval > 3600 * 24 * 7)) {
                // 可以参与新手活动
                [self.viewModel.requestGiftPackageInfoCommand execute:nil];
            }
        }
    }];
    [RACObserve(self.viewModel, datasource) subscribeNext:^(NSArray *array) {
        if (array != nil) {
            // 请求完服务器后判断当天的签到状态再打开礼包页面
            NSTimeInterval interval = 8 * 3600 - [self.user.userRegisterTime timeIntervalSinceNow];
            int day = interval / 3600 / 24;  //获取当前是注册完之后的第几天
            SYGiftPackageModel *model = self.viewModel.datasource[day];
            if (model.giftRecordIsReceive == 0) {
                SYGiftPackageVM *giftVM = [[SYGiftPackageVM alloc] initWithServices:SYSharedAppDelegate.services params:nil];
                giftVM.giftPackagesArray = array;
                SYGiftPackageVC *giftVC = [[SYGiftPackageVC alloc] initWithViewModel:giftVM];
                CATransition *animation = [CATransition animation];
                [animation setDuration:0.3];
                animation.type = kCATransitionPush;
                animation.subtype = kCATransitionMoveIn;
                [SYSharedAppDelegate presentVC:giftVC withAnimation:animation];
            }
        }
    }];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation { 
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"语聊",@"附近",@"榜单"] delegate:self indicatorType:FSIndicatorTypeEqualTitle showHalo:YES];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYFont(15, YES);
    self.titleView.titleSelectFont = SYFont(15, YES);
    self.titleView.showHalo = YES;
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    // 语聊界面
    SYAnchorsOrderVC *anchorsOrderVC = [[SYAnchorsOrderVC alloc] initWithViewModel:self.viewModel.anchorsOrderVM];
    [childVCs addObject:anchorsOrderVC];
    // 附近的人界面
    SYNearbyVC *nearVC = [[SYNearbyVC alloc]initWithViewModel:self.viewModel.nearbyVM];
    [childVCs addObject:nearVC];
//    // 选聊界面
//    SYAnchorsRandomVC *randomVC = [[SYAnchorsRandomVC alloc]initWithViewModel:self.viewModel.anchorsRandomVM];
//    [childVCs addObject:randomVC];
    // 榜单界面
    SYRankingVC *rankingVC = [[SYRankingVC alloc]initWithViewModel:self.viewModel.rankingVM];
    [childVCs addObject:rankingVC];
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

#pragma mark - 开始定位
- (void)startLocating {
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];   //开始定位
}

/* 定位完成后 回调 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    [manager stopUpdatingLocation];   //停止定位
    CLGeocoder *geoCoder = [CLGeocoder new];
    @weakify(self)
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        @strongify(self)
        CLPlacemark *pl = [placemarks firstObject];
        if(error == nil) {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            [self.viewModel.uploadLocationInfoCommand execute:@{@"userId":self.viewModel.services.client.currentUserId,@"userLongitude":[NSString stringWithFormat:@"%f",pl.location.coordinate.longitude],@"userLatitude":[NSString stringWithFormat:@"%f",pl.location.coordinate.latitude]}];
            NSLog(@"%@", pl.locality);
        }
    }];
}

/* 定位失败后 回调 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
        [MBProgressHUD sy_showTips:@"定位失败，请检查"];
    }
}
/* 监听用户授权状态 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        // 用户未开启定位功能
    }
}

@end
