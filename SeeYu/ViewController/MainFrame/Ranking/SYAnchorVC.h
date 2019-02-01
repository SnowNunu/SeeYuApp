//
//  SYAnchorVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYAnchorVM.h"
#import "SYTableView.h"
#import "UIScrollView+SYRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorVC : SYVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SYTableView *tableView;

@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
