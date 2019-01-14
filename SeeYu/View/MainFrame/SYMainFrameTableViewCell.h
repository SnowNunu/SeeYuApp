//
//  SYMainFrameTableViewCell.h
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYReactiveView.h"
@interface SYMainFrameTableViewCell : UITableViewCell<SYReactiveView>
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
