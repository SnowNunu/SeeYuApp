//
//  SYCollocationVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/2/27.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollocationVC : SYVC <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *bgTableView;


@property (nonatomic, assign) NSInteger currentIndex;

// 当前播放页面是否暂停
@property (nonatomic, assign) BOOL isCurrentPlayerPause;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
