//
//  SYAnchorVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/1/29.
//  Copyright © 2019年 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorVM : SYVM

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) RACCommand *requestAnchorsCommand;

@end

NS_ASSUME_NONNULL_END
