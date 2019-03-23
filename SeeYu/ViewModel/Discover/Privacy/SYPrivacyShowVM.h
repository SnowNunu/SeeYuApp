//
//  SYPrivacyShowVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/3/23.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYPrivacyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYPrivacyShowVM : SYVM

@property (nonatomic, strong) SYPrivacyModel *model;

/* 返回 */
@property (nonatomic, strong) RACCommand *goBackCommand;

@end

NS_ASSUME_NONNULL_END
