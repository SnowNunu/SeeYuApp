//
//  SYProfileInfoZoneCell.m
//  WeChat
//
//  Created by senba on 2018/1/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "SYProfileInfoZoneCell.h"

@implementation SYProfileInfoZoneCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ProfileInfoZoneCell";
    SYProfileInfoZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self sy_viewFromXib];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
