//
//  SYAnchorsOrderVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsOrderVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYAnchorsListVC.h"
#import "SYAnchorsListVM.h"

@interface SYAnchorsOrderVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYAnchorsOrderVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSecondTag];
}

#pragma mark - 设置二级标题
- (void)_setupSecondTag {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 40) titles:@[@"推荐",@"新人",@"三星",@"四星",@"五星",@"关注"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = SYColor(199, 99, 237);
    self.titleView.titleSelectColor = SYColor(248, 56, 129);
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYFont(13, YES);
    self.titleView.titleSelectFont = SYFont(13, YES);
    [self.view addSubview:_titleView];

    NSArray *typeArray = @[@"recommend",@"new",@"three",@"four",@"five",@"follow"];
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (int i = 0; i < 6; i++) {
        SYAnchorsListVM *listViewModel = [[SYAnchorsListVM alloc] initWithServices:self.viewModel.services params:@{SYViewModelUtilKey:typeArray[i]}];
        SYAnchorsListVC *anchorsListVC = [[SYAnchorsListVC alloc] initWithViewModel:listViewModel];
        [childVCs addObject:anchorsListVC];
    }
    self.contentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - 40 - SY_APPLICATION_TAB_BAR_HEIGHT - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

@end
