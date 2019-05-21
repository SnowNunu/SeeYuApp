//
//  SYInfoEditVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYInfoEditVC.h"
#import "FSSegmentTitleView.h"
#import "FSPageContentView.h"
#import "SYBaseInfoDetailVC.h"
#import "SYBaseInfoDetailVM.h"
#import "SYCoverInfoEditVC.h"
#import "SYCoverInfoEditVM.h"
#import "SYVideoInfoEditVC.h"
#import "SYVideoInfoEditVM.h"

@interface SYInfoEditVC () <FSSegmentTitleViewDelegate,FSPageContentViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *contentView;

@end

@implementation SYInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSecondTag];
}

- (void)_setupSecondTag {
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, SY_SCREEN_WIDTH, 40) titles:@[@"介绍",@"封面",@"视频"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleNormalColor = SYColor(193, 99, 237);
    self.titleView.titleSelectColor = SYColor(248, 56, 129);
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.indicatorColor = [UIColor whiteColor];
    self.titleView.titleFont = SYFont(13, YES);
    self.titleView.titleSelectFont = SYFont(13, YES);
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    SYBaseInfoDetailVM *baseInfoViewModel = [[SYBaseInfoDetailVM alloc] initWithServices:self.viewModel.services params:nil];
    SYBaseInfoDetailVC *baseInfoVC = [[SYBaseInfoDetailVC alloc] initWithViewModel:baseInfoViewModel];
    [childVCs addObject:baseInfoVC];
    
    SYCoverInfoEditVM *coverInfoViewModel = [[SYCoverInfoEditVM alloc] initWithServices:self.viewModel.services params:nil];
    SYCoverInfoEditVC *coverInfoVC = [[SYCoverInfoEditVC alloc] initWithViewModel:coverInfoViewModel];
    [childVCs addObject:coverInfoVC];
    
    SYVideoInfoEditVM *videoInfoViewModel = [[SYVideoInfoEditVM alloc] initWithServices:self.viewModel.services params:nil];
    SYVideoInfoEditVC *videoInfoVC = [[SYVideoInfoEditVC alloc] initWithViewModel:videoInfoViewModel];
    [childVCs addObject:videoInfoVC];
    self.contentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 40, SY_SCREEN_WIDTH, SY_SCREEN_HEIGHT - 40 - SY_APPLICATION_TOP_BAR_HEIGHT) childVCs:childVCs parentVC:self delegate:self];
    [self.view addSubview:_contentView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem sy_systemItemWithTitle:nil titleColor:nil imageName:@"nav_btn_setting" target:self selector:@selector(enterInfoEditView) textType:NO];
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.contentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)enterInfoEditView {
    [self.viewModel.enterInfoEditViewCommand execute:nil];
}

@end
