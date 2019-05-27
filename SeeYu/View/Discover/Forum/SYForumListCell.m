//
//  SYForumListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumListCell.h"

@implementation SYForumListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubviews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubviews {
    UIView *bgView = [UIView new];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 9.f;
    bgView.backgroundColor = SYColorFromHexString(@"#FFF3FF");
    _bgView = bgView;
    [self addSubview:bgView];
    
    YYLabel *titleLabel = [YYLabel new];
    titleLabel.numberOfLines = 0;   // 开启多行显示
    titleLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 60 - 14;
    titleLabel.font = SYFont(15,YES);
    titleLabel.textColor = SYColor(56, 56, 56);
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UIImageView *titleImageView = [UIImageView new];
    titleImageView.layer.cornerRadius = 6.f;
    titleImageView.clipsToBounds = YES;
    _titleImageView = titleImageView;
    [self addSubview:titleImageView];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 3;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 60;
    contentLabel.font = SYRegularFont(13);
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self addSubview:contentLabel];
    
    UIImageView *commentImageView = [UIImageView new];
    commentImageView.image = SYImageNamed(@"news_icon_comment");
    _commentImageView = commentImageView;
    [self addSubview:commentImageView];
    
    UILabel *commentsNumLabel = [UILabel new];
    commentsNumLabel.textColor = SYColor(193, 99, 237);
    commentsNumLabel.font = SYFont(10,YES);
    _commentsNumLabel = commentsNumLabel;
    [self addSubview:commentsNumLabel];
    
    UILabel *toAnswerLabel = [UILabel new];
    toAnswerLabel.textColor = SYColor(159, 105, 235);
    toAnswerLabel.font = SYRegularFont(15);
    toAnswerLabel.text = @"去回答";
    toAnswerLabel.textAlignment = NSTextAlignmentRight;
    _toAnswerLabel = toAnswerLabel;
    [self addSubview:toAnswerLabel];
    
    UIImageView *toAnswerImageView = [UIImageView new];
    toAnswerImageView.image = SYImageNamed(@"arrorMore");
    _toAnswerImageView = toAnswerImageView;
    [self addSubview:toAnswerImageView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)_makeSubViewsConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.top.equalTo(self).offset(4);
        make.bottom.equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self.bgView).offset(15);
        make.height.offset(20);
    }];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.width.equalTo(self.titleLabel);
        make.height.offset(0);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(9);
        make.left.width.equalTo(self.titleLabel);
    }];
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        make.width.offset(17);
        make.height.offset(13.5);
        make.bottom.equalTo(self).offset(-12);
        make.left.equalTo(self.contentLabel).offset(9);
    }];
    [_commentsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImageView.mas_right).offset(4);
        make.width.offset(60);
        make.height.centerY.equalTo(self.commentImageView);
    }];
    [_toAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toAnswerImageView.mas_left).offset(-4);
        make.width.offset(60);
        make.height.centerY.equalTo(self.commentImageView);
    }];
    [_toAnswerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(17);
        make.height.offset(11.5);
        make.right.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self.commentsNumLabel);
    }];
}

- (void)setTitleImageViewByUrl:(NSString *)url {
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.equalTo(self.titleImageView.mas_width).multipliedBy(0.476);
    }];
    [self.titleImageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:SYImageNamed(@"Q&A_defaultImg") options:SYWebImageOptionAutomatic completion:NULL];
}

- (void)removeTitleImagewView {
    self.titleImageView.image = nil;
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
}

@end
