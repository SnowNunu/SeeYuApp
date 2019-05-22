//
//  SYRechargeVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/12.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYRechargeVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYVipVC.h"
#import "SYDiamondsVC.h"

@interface SYRechargeVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupNavigation];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self changeFirstShowView];
}

#pragma mark - 设置导航栏
- (void)_setupNavigation {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 80, 44) titles:@[@"充值VIP",@"充值钻石"] delegate:self indicatorType:FSIndicatorTypeEqualTitle showHalo:YES];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.titleSelectColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYFont(15, YES);
    self.titleView.titleSelectFont = SYFont(15, YES);
    self.titleView.showHalo = YES;
    self.navigationItem.titleView = self.titleView;
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    // 充值vip界面
    SYVipVC *vipVC = [[SYVipVC alloc] initWithViewModel:self.viewModel.vipViewModel];
    [childVCs addObject:vipVC];
    // 充值钻石界面
    SYDiamondsVC *diamondsVC = [[SYDiamondsVC alloc] initWithViewModel:self.viewModel.diamondsViewModel];
    [childVCs addObject:diamondsVC];
    
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)changeFirstShowView {
    if ([self.viewModel.rechargeType isEqualToString:@"diamonds"]) {
        self.titleView.selectIndex = 1;
        self.contentView.contentViewCurrentIndex = 1;
    } else {
        self.titleView.selectIndex = 0;
        self.contentView.contentViewCurrentIndex = 0;
    }
}

@end
