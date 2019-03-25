//
//  SYForumHeaderCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/25.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYForumHeaderCell.h"

@implementation SYForumHeaderCell

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
    bgView.backgroundColor = SYColorFromHexString(@"#F8F8F8");
    _bgView = bgView;
    [self addSubview:bgView];
    
    YYLabel *titleLabel = [YYLabel new];
    titleLabel.font = SYRegularFont(15);
    titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    YYLabel *contentLabel = [YYLabel new];
    contentLabel.numberOfLines = 0;   // 开启多行显示
    contentLabel.preferredMaxLayoutWidth = SY_SCREEN_WIDTH - 60;
    contentLabel.font = SYRegularFont(13);
    contentLabel.textColor = SYColor(153, 153, 153);
    _contentLabel = contentLabel;
    [self addSubview:contentLabel];
}

- (void)_makeSubViewsConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.offset(17);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.bgView.mas_top).offset(-15);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(15);
    }];
}

@end
