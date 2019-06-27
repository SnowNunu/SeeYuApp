//
//  SYGiftVM.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/4/20.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVM.h"
#import "SYGiftResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftVM : SYVM

@property (nonatomic, strong) NSString *friendId;

@property (nonatomic, strong) SYUser *user;

@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) RACCommand *requestGiftsListCommand;

@property (nonatomic, strong) RACCommand *sendGiftCommand;

@end

NS_ASSUME_NONNULL_END
