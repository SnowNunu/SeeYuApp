//
//  SYForumCommentVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumCommentVC.h"
#import "SYForumHeaderCell.h"
#import "SYMomentCommentToolView.h"
#import "SYForumResultModel.h"

@interface SYForumCommentVC() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SYMomentCommentToolView *commentToolView;

/// 记录键盘高度
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation SYForumCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复话题";
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
    [self.viewModel.requestForumsCommentsCommand execute:@1];
}

- (void)bindViewModel {
    @weakify(self)
    [[RACObserve(self.viewModel, datasource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    //// 监听commentToolView的高度变化
    [[RACObserve(self.commentToolView, toHeight) distinctUntilChanged] subscribeNext:^(NSNumber * toHeight) {
        @strongify(self);
        if (toHeight.floatValue < SYMomentCommentToolViewMinHeight) return ;
        /// 更新CommentView的高度
        [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(toHeight);
        }];
        [UIView animateWithDuration:.25f animations:^{
            // 适当时候更新布局
            [self.view layoutSubviews];
            /// 滚动表格
            [self _scrollTheTableViewForComment];
        }];
    }];
    /// 监听键盘 高度
    /// 监听按钮
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] takeUntil:self.rac_willDeallocSignal ]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * notification) {
         @strongify(self);
         @weakify(self);
         [self sy_convertNotification:notification completion:^(CGFloat duration, UIViewAnimationOptions options, CGFloat keyboardH) {
             @strongify(self);
             if (keyboardH == self.keyboardHeight) {
                 // 这里会收到3次键盘通知，需要进行重复操作判断
                 return ;
             }
             if (keyboardH <= 0) {
                 keyboardH = -self.keyboardHeight;
             }
             self.keyboardHeight = keyboardH;
             /// 全局记录keyboardH
             AppDelegate.sharedDelegate.showKeyboard = (keyboardH > 0);
             if (keyboardH > 0) {
                 [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.bottom.equalTo(self.view).with.offset(-1 *keyboardH);
                 }];
             } else {
                 [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.bottom.equalTo(self.view);
                 }];
             }
             // 执行动画
             [UIView animateWithDuration:duration delay:0.0f options:options animations:^{
                 // 如果是Masonry或者autoLayout UITextField或者UITextView 布局 必须layoutSubviews，否则文字会跳动
                 [self.view layoutSubviews];
                 /// 滚动表格
                 [self _scrollTheTableViewForComment];
             } completion:nil];
         }];
     }];
    [[self.commentToolView.releaseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.commentToolView.textView.text.length > 0) {
            [MBProgressHUD sy_showProgressHUD:@"发表中，请稍候" addedToView:self.view];
            [self.viewModel.postCommentCommand execute:self.commentToolView.textView.text];
        }
        NSLog(@"%@",self.commentToolView.textView.text);
    }];
    [self.viewModel.postCommentCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYForumResultModel *model) {
        [MBProgressHUD sy_hideHUDForView:self.view];
        if ([model.commentStatus isEqualToString:@"2"]) {
            [MBProgressHUD sy_showTips:@"评论发布成功"];
        } else {
            [MBProgressHUD sy_showTips:@"评论审核中，敬请等待"];
        }
    }];
    [self.viewModel.postCommentCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_hideHUDForView:self.view];
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

- (void)_setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[SYForumCommentCell class] forCellReuseIdentifier:@"forumCommentCell"];
    [tableView registerClass:[SYForumHeaderCell class] forCellReuseIdentifier:@"forumHeaderCell"];
    _tableView = tableView;
    [self.view addSubview:tableView];
    SYMomentCommentToolView *commentToolView = [[SYMomentCommentToolView alloc] init];
    self.commentToolView = commentToolView;
    [self.view addSubview:commentToolView];
    [commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.view);
    }];
}

- (void)_makeSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

#pragma  mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.viewModel.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SYForumHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumHeaderCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[SYForumHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumHeaderCell"];
        }
        cell.titleLabel.text = self.viewModel.model.forumTitle;
        cell.contentLabel.text = self.viewModel.model.forumContent;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        SYForumCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumCommentCell" forIndexPath:indexPath];
        if(!cell) {
            cell = [[SYForumCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"forumListCell"];
        }
        SYForumCommentModel *model = self.viewModel.datasource[indexPath.row];
        [cell.headPhotoView yy_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholder:SYWebAvatarImagePlaceholder() options:SYWebImageOptionAutomatic completion:NULL];
        cell.aliasLabel.text = model.userName;
        cell.contentLabel.text = model.commentContent;
        cell.genderImageView.image = [model.userGender isEqualToString:@"男"] ? SYImageNamed(@"news_icon_male") : SYImageNamed(@"news_icon_female");
        cell.likeNumLabel.text = model.commentLiked;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

/// 评论的时候 滚动tableView
- (void)_scrollTheTableViewForComment {
//    if (self.keyboardHeight > 0) { /// 键盘抬起 才允许滚动
        /// 这个就是你需要滚动差值
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.keyboardHeight) animated:NO];
//    }
}

@end
