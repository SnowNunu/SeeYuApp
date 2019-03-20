//
//  SYAnchorsRandomVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAnchorsRandomVC.h"

@interface SYAnchorsRandomVC ()

/* 背景图层 */
@property (nonatomic, strong) UIView *bgView;

/* 头像显示 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 视频连线 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 想连就连 */
@property (nonatomic, strong) UILabel *tipsLabel;

/* 在线人数文本 */
@property (nonatomic, strong) UILabel *onlineAmountLabel;

/* 第1个主播视频页面 */
@property (nonatomic, strong) UIView *firstAnchorView;

/* 第2个主播视频页面 */
@property (nonatomic, strong) UIView *secondAnchorView;

/* 第3个主播视频页面 */
@property (nonatomic, strong) UIView *thirdAnchorView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation SYAnchorsRandomVC

- (instancetype)initWithViewModel:(SYVM *)viewModel {
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.firstAnchorView jp_playVideoWithURL:[NSURL URLWithString:@"http://103.214.146.89/seeyu/show/121972.mp4"]];
    [self.secondAnchorView jp_playVideoWithURL:[NSURL URLWithString:@"http://103.214.146.89/seeyu/show/122257.mp4"]];
    [self.thirdAnchorView jp_playVideoWithURL:[NSURL URLWithString:@"http://103.214.146.89/seeyu/show/122236.mp4"]];
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = SYColorFromHexString(@"#333333");
    _bgView = bgView;
    [self.view addSubview:bgView];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.image = SYImageNamed(@"home_Head frame_self");
    _headImageView = headImageView;
    [bgView addSubview:headImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"自选视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SYRegularFont(20);
    _titleLabel = titleLabel;
    [bgView addSubview:titleLabel];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.text = @"视频连线 想连就连";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = SYRegularFont(18);
    _tipsLabel = tipsLabel;
    [bgView addSubview:tipsLabel];
    
    UILabel *onlineAmountLabel = [UILabel new];
    onlineAmountLabel.textColor = SYColor(154, 102, 224);
    onlineAmountLabel.text = @"当前在线 (95人)";
    onlineAmountLabel.textAlignment = NSTextAlignmentLeft;
    onlineAmountLabel.font = SYRegularFont(16);
    _onlineAmountLabel = onlineAmountLabel;
    [bgView addSubview:onlineAmountLabel];
    
    CGFloat width = (SY_SCREEN_WIDTH - 15 * 4) / 3;
//    UIView *firstAnchorView = [UIView new];
//    firstAnchorView.frame = CGRectMake(15, onlineAmountLabel.frame.origin.y + onlineAmountLabel.frame.size.height, width, width * 1.43);
//    _firstAnchorView = firstAnchorView;
//    [bgView addSubview:firstAnchorView];
//
//    UIView *secondAnchorView = [UIView new];
//    secondAnchorView.frame = CGRectMake(155, onlineAmountLabel.frame.origin.y + onlineAmountLabel.frame.size.height, width, width * 1.43);
//    _secondAnchorView = secondAnchorView;
//    [bgView addSubview:secondAnchorView];
//
//    UIView *thirdAnchorView = [[UIView alloc] initWithFrame:CGRectMake(230, 500, 80, 100)];
//    _thirdAnchorView = thirdAnchorView;
//    [bgView addSubview:thirdAnchorView];
    
//    NSURL *url = [NSURL URLWithString:_playerUrl];
}

- (void)_makeSubViewsConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.width.height.offset(120);
        make.top.equalTo(self.bgView).offset(15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.width.offset(150);
        make.height.offset(20);
        make.top.equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.titleLabel);
        make.height.offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    [self.onlineAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.left.equalTo(self.bgView).offset(15);
        make.height.offset(15);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(45);
    }];
//    [self.secondAnchorView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.firstAnchorView.mas_right).offset(15);
//        make.top.width.height.equalTo(self.firstAnchorView);
//    }];
//    [self.thirdAnchorView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.secondAnchorView.mas_right).offset(15);
//        make.top.width.height.equalTo(self.firstAnchorView);
//    }];
}

@end
