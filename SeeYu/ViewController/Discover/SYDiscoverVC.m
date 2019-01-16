//
//  SYDiscoverVC.m
//  SeeYu
//
//  Created by trc on 2017/9/11.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYDiscoverVC.h"
#import "SYMomentVC.h"

@interface SYDiscoverVC ()

@property (nonatomic, readonly, strong) SYDiscoverVM *viewModel;

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYDiscoverVC

@dynamic viewModel;

- (void)viewDidLoad {
    /// 设置导航栏
    [self _setupNavigation];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"热门",@"专区",@"社区"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYRegularFont(18);
    self.titleView.titleSelectFont = SYRegularFont(20);
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    SYMomentVC *momentVC = [[SYMomentVC alloc]init];
//    SYMomentVC *momentVC = [[SYMomentVC alloc]initWithViewModel:self.viewModel.momentVM];
    [childVCs addObject:momentVC];
    for (int i = 0; i < 2; i ++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = SYColor(50 * i / 255, 50 * i / 255, 50 * i / 255);
        [childVCs addObject:vc];
    }
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, SY_APPLICATION_TOP_BAR_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
    self.title = @[@"热门",@"专区",@"社区"][endIndex];
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
    self.title = @[@"热门",@"专区",@"社区"][endIndex];
}

@end
