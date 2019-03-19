//
//  SYFriendsListCell.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/15.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYFriendsListCell.h"

@implementation SYFriendsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupSubViews];
        [self _makeSubViewsConstraints];
    }
    return self;
}

- (void)_setupSubViews {
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 22.5f;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    UILabel *aliasLabel = [UILabel new];
    aliasLabel.font = SYRegularFont(20);
    aliasLabel.textAlignment = NSTextAlignmentLeft;
    _aliasLabel = aliasLabel;
    [self.contentView addSubview:aliasLabel];
}

- (void)_makeSubViewsConstraints {
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45.f);
        make.left.top.equalTo(self.contentView).offset(15);
    }];
    [_aliasLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(30);
        make.height.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
