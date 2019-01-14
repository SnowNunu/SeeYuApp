//
//  SYBootRegisterVM.h
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYVM.h"
#import "SYRegisterVM.h"

@interface SYBootRegisterVM : SYVM

@property (nonatomic, strong) NSString *age;

@property (nonatomic, strong) RACCommand *nextCommand;

// 用户昵称
@property (nonatomic, strong) NSString *alias;

// 性别
@property (nonatomic, strong) NSString *gender;

@end
