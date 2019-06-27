//
//  SYAboutVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYAppUpdateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYAboutVM : SYVM

// 获取当前app最新版本信息
@property (nonatomic, strong) RACCommand *requestUpdateInfoCommand;

@end

NS_ASSUME_NONNULL_END
