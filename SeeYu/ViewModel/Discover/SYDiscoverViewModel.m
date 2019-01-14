//
//  SYDiscoverViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYDiscoverViewModel.h"
#import "SYWebViewModel.h"
#import "SYMomentViewModel.h"
@implementation SYDiscoverViewModel

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        /// 监听通知
        @weakify(self);
        [[SYNotificationCenter rac_addObserverForName:SYPlugSwitchValueDidChangedNotification object:nil] subscribeNext:^(id _) {
            @strongify(self);
            /// 配置数据
            [self _configureData];
        }];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    self.title = @"发现";
    /// 配置数据
    [self _configureData];
}
#pragma mark - 配置数据
- (void)_configureData{
    
    @weakify(self);
    
    /// 第一组
    SYCommonGroupViewModel *group0 = [SYCommonGroupViewModel groupViewModel];
    /// 盆友圈
    SYCommonArrowItemViewModel *moment = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"朋友圈" icon:@"ff_IconShowAlbum_25x25"];
    moment.destViewModelClass = [SYMomentViewModel class];
    group0.itemViewModels = @[moment];
    
    /// 第二组
    SYCommonGroupViewModel *group1 = [SYCommonGroupViewModel groupViewModel];
    /// 扫一扫
    SYCommonArrowItemViewModel *qrCode = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"扫一扫" icon:@"ff_IconQRCode_25x25"];
    /// 摇一摇
    SYCommonArrowItemViewModel *shake = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"摇一摇" icon:@"ff_IconShake_25x25"];
    group1.itemViewModels = @[qrCode , shake];
    
    /// 第三组
    SYCommonGroupViewModel *group2 = [SYCommonGroupViewModel groupViewModel];
    /// 附近的人
    SYCommonArrowItemViewModel *locationService = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"附近的人" icon:@"ff_IconLocationService_25x25"];
    /// 漂流瓶
    SYCommonArrowItemViewModel *bottle = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"漂流瓶" icon:@"ff_IconBottle_25x25"];
    group2.itemViewModels = @[locationService , bottle];
    
    /// 第四组
    SYCommonGroupViewModel *group3 = [SYCommonGroupViewModel groupViewModel];
    /// 购物
    SYCommonArrowItemViewModel *shopping = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"购物" icon:@"CreditCard_ShoppingBag_25x25"];
    /// 游戏
    SYCommonArrowItemViewModel *game = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"游戏" icon:@"MoreGame_25x25"];
    group3.itemViewModels = @[shopping , game];
    
    /// 第五组
    SYCommonGroupViewModel *group4 = [SYCommonGroupViewModel groupViewModel];
    /// 小程序
    SYCommonArrowItemViewModel *moreApps = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"小程序" icon:@"MoreWeApp_25x25"];
    group4.itemViewModels = @[moreApps];
    
    /// 插件功能
    NSMutableArray *group5s = [NSMutableArray arrayWithCapacity:2];
    /// 看一看
    if ([SYPreferenceSettingHelper boolForKey:SYPreferenceSettingLook]) {
        SYCommonArrowItemViewModel *look= [SYCommonArrowItemViewModel itemViewModelWithTitle:@"看一看" icon:@"ff_IconBrowse1_25x25"];
        look.centerLeftViewName = [SYPreferenceSettingHelper boolForKey:SYPreferenceSettingLookArtboard]?@"Artboard23_38x18":nil;;
        [group5s addObject:look];
        @weakify(look);
        look.operation = ^{
            @strongify(self);
            @strongify(look);
            NSURL *url = [NSURL URLWithString:SYMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            SYWebViewModel * webViewModel = [[SYWebViewModel alloc] initWithServices:self.services params:@{SYViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:webViewModel animated:YES];
            
            if (look.centerLeftViewName) {
                look.centerLeftViewName = nil;
                [SYPreferenceSettingHelper setBool:NO forKey:SYPreferenceSettingLookArtboard];
                // “手动触发self.dataSource的KVO”，必写。
                [self willChangeValueForKey:@"dataSource"];
                // “手动触发self.now的KVO”，必写。
                [self didChangeValueForKey:@"dataSource"];
            }
        };
    }
    /// 搜一搜
    if ([SYPreferenceSettingHelper boolForKey:SYPreferenceSettingSearch]) {
        SYCommonArrowItemViewModel *search = [SYCommonArrowItemViewModel itemViewModelWithTitle:@"搜一搜" icon:@"ff_IconSearch1_25x25"];
        search.centerLeftViewName = [SYPreferenceSettingHelper boolForKey:SYPreferenceSettingSearchArtboard]?@"Artboard23_38x18":nil;
        [group5s addObject:search];
        @weakify(search);
        search.operation = ^{
            @strongify(self);
            @strongify(search);
            NSURL *url = [NSURL URLWithString:SYMyBlogHomepageUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            SYWebViewModel * webViewModel = [[SYWebViewModel alloc] initWithServices:self.services params:@{SYViewModelRequestKey:request}];
            /// 去掉关闭按钮
            webViewModel.shouldDisableWebViewClose = YES;
            [self.services pushViewModel:webViewModel animated:YES];
            
            if (search.centerLeftViewName) {
                search.centerLeftViewName = nil;
                [SYPreferenceSettingHelper setBool:NO forKey:SYPreferenceSettingSearchArtboard];
                // “手动触发self.dataSource的KVO”，必写。
                [self willChangeValueForKey:@"dataSource"];
                // “手动触发self.now的KVO”，必写。
                [self didChangeValueForKey:@"dataSource"];
            }
        };
    }
    
    
    
    if (group5s.count>0) {
        SYCommonGroupViewModel *group5 = [SYCommonGroupViewModel groupViewModel];
        group5.itemViewModels = [group5s copy];
        self.dataSource = @[group0 , group1 ,group5 , group2 , group3 , group4];
    }else{
        self.dataSource = @[group0 , group1 , group2 , group3 , group4];
    }
}
@end
