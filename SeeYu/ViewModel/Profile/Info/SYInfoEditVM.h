//
//  SYInfoEditVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYBaseInfoEditVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYInfoEditVM : SYVM

@property (nonatomic, strong) RACCommand *enterInfoEditViewCommand;

@end

NS_ASSUME_NONNULL_END
