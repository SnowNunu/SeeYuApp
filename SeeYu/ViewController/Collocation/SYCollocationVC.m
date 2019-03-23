//
//  SYCollocationVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYCollocationVC.h"

@interface SYCollocationVC ()

@property (nonatomic, strong) UIView *singleShowView;

@end

@implementation SYCollocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)bindViewModel {
    [RACObserve(self.viewModel, speedMatchList) subscribeNext:^(id x) {
        
    }];
}

- (void)_setupSubViews {
    UIView *singleShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - SY_APPLICATION_TAB_BAR_HEIGHT)];
    _singleShowView = singleShowView;
    [self.view addSubview:singleShowView];
}

// 加载缓存数据
- (void)reloadCacheData {
    YYCache *cache = [YYCache cacheWithName:@"seeyu"];
    if ([cache containsObjectForKey:@"speedMatch"]) {
        //
    } else {
        // 初次使用没有缓存数据
        [self.viewModel.requestSpeedMatchCommand execute:nil];
    }
//    //根据key写入缓存value
//    [yyCache setObject:value forKey:key];
//    //判断缓存是否存在
//    BOOL isContains = [yyCache containsObjectForKey:key];
//    NSLog(@"containsObject : %@", isContains?@"YES":@"NO");
//    //根据key读取数据
//    id vuale=[yyCache objectForKey:key];
//    NSLog(@"value : %@",vuale);
//    //根据key移除缓存
//    [yyCache removeObjectForKey:key];
//    //移除所有缓存
//    [yyCache removeAllObjects];
}


@end
