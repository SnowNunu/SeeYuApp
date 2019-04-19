//
//  SYOutboundVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/19.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYOutboundVM : SYVM

@property (nonatomic, strong) NSString *callerId;

@property (nonatomic, strong) NSString *interval;

@property (nonatomic, strong) SYUser *callerInfo;

@property (nonatomic, strong) RACCommand *requestCallerInfoCommand;

@end

NS_ASSUME_NONNULL_END
