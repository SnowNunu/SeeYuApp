//
//  SYMainFrameTableViewCell.m
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYMainFrameTableViewCell.h"
#import "SYMainFrameItemViewModel.h"
@interface SYMainFrameTableViewCell ()
/// viewModel
@property (nonatomic, readwrite, strong) SYMainFrameItemViewModel *viewModel;

/// avatarView
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
/// nickenameLabel
@property (weak, nonatomic) IBOutlet UILabel *nickenameLabel;
/// locationBtn
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
/// starLevelView
@property (weak, nonatomic) IBOutlet UIImageView *starLevelView;
/// audienceNumsLabel
@property (weak, nonatomic) IBOutlet UILabel *audienceNumsLabel;
/// coverView
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
/// headTipsBtn
@property (weak, nonatomic) IBOutlet UIButton *headTipsBtn;
/// signView
@property (weak, nonatomic) IBOutlet UIImageView *signView;

@end

@implementation SYMainFrameTableViewCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LiveRoomCell";
    SYMainFrameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self sy_viewFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)bindViewModel:(SYMainFrameItemViewModel *)viewModel{
    self.viewModel = viewModel;
    
    [self.avatarView yy_setImageWithURL:viewModel.liveRoom.smallpic placeholder:SYImageNamed(@"header_default_100x100") options:SYWebImageOptionAutomatic completion:NULL];
    self.signView.hidden = !viewModel.liveRoom.isSign;
    
    self.nickenameLabel.text = viewModel.liveRoom.myname;
    self.starLevelView.image = SYImageNamed(viewModel.girlStar);
    
    [self.locationBtn setTitle:viewModel.liveRoom.gps forState:UIControlStateNormal];
    self.audienceNumsLabel.attributedText = viewModel.allNumAttr;
    
    [self.headTipsBtn setTitle:viewModel.liveRoom.familyName forState:UIControlStateNormal];
    [self.coverView yy_setImageWithURL:viewModel.liveRoom.bigpic placeholder:SYImageNamed(@"placeholder_head_100x100") options:SYWebImageOptionAutomatic completion:NULL];
}

#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
