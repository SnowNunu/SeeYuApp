//
//  SYSearchTextCell.m
//  WeChat
//
//  Created by senba on 2018/2/28.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYSearchTextCell.h"
#import "SYSearchFriendsViewModel.h"

@interface SYSearchTextCell ()

/// searchLabel
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

/// viewModel
@property (nonatomic, readwrite, strong) SYSearchFriendsViewModel *viewModel;
@end


@implementation SYSearchTextCell
#pragma mark - Public Method

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchTextCell";
    SYSearchTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self sy_viewFromXib];
    return cell;
}

- (void)bindViewModel:(SYSearchFriendsViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.searchLabel.text = viewModel.searchText;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
