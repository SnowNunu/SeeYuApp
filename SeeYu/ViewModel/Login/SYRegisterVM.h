//
//  SYRegisterVM.h
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYVM.h"

@interface SYRegisterVM : SYVM

@property (nonatomic, strong) NSString *job;

@property (nonatomic, strong) NSString *income;

@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) NSString *maritalStatus;

@property (nonatomic, strong) NSMutableArray *specialtyArray;

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) SYUser *user;

/// 注册命令
@property(nonatomic, strong) RACCommand *registerCommand;

/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readonly, strong) NSError *error;


@end
