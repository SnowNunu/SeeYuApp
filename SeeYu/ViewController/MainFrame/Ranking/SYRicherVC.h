//
//  SYRicherVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/30.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYTableView.h"
#import "SYRicherVM.h"
#import "UIScrollView+SYRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYRicherVC : SYVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SYTableView *tableView;

@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
