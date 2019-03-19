//
//  SYAnchorsListVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/18.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAnchorsListVM : SYVM

// 主播类型
@property (nonatomic, strong) NSString *anchorType;

// 获取主播列表
@property (nonatomic, strong) RACCommand *requestAnchorsListCommand;

// 主播列表
@property (nonatomic, strong) NSArray *anchorsArray;

@end

NS_ASSUME_NONNULL_END
