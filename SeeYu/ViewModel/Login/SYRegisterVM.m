//
//  SYRegisterVM.m
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Hyphenate/Hyphenate.h>
#import "SYRegisterVM.h"
#import "SYURLParameters.h"
#import "SYHTTPRequest.h"
#import "CocoaSecurity.h"

@interface SYRegisterVM ()

/// error （PS；这个记录请求过程中的发生的错误，请求之前必须置nil）
@property (nonatomic, readwrite, strong) NSError *error;

@end


@implementation SYRegisterVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    self.dict = params;
    return self;
}

- (void)initialize {
    [super initialize];
    self.prefersNavigationBarBottomLineHidden = YES;
    self.title = @"基本信息";
    self.backTitle = @"";
    @weakify(self);
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        // 随机生成六位数作为用户密码(并使用aes加密)
        NSString *strRandom = @"";
        for(int i = 0; i < 6; i++) {
            strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
        }
        CocoaSecurityResult *pwd = [CocoaSecurity aesEncrypt:strRandom hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9" hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
        NSString *password = pwd.base64;
        NSDictionary *parameters = @{@"userPassword":password,@"userName":self.dict[@"alias"],@"userAge":self.dict[@"age"],@"userGender":self.dict[@"gender"],@"userProfession":[self.job stringByReplacingOccurrencesOfString:@" " withString:@""],@"userIncome":self.income,@"userHeight":self.height,@"userMarry":self.maritalStatus,@"userSpecialty":[self.specialtyArray componentsJoinedByString:@","]};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_REGISTER parameters:subscript.dictionary];
        [[[[SYHTTPRequest requestWithParameters:paramters]
           enqueueResultClass:[SYUser class]]
          sy_parsedResults]
         subscribeNext:^(SYUser * user) {
             NSLog(@"register successful");
             user.userPassword = password;
             /// 存储登录账号
             [SAMKeychain setRawLogin:user.userId];
             /// 存储用户数据
             [self.services.client loginUser:user];
             self.user = user;
         } error:^(NSError *error) {
             /// 失败回调
             NSLog(@"error");
             [MBProgressHUD sy_showErrorTips:error];
         } completed:^{
             // 登录环信
             EMError *error = [[EMClient sharedClient] loginWithUsername:self.user.userId password:self.user.userPassword];
             if (!error) {
                 // 开启自动登录
                 [[EMClient sharedClient].options setIsAutoLogin:YES];
                 /// 切换根控制器
                 dispatch_async(dispatch_get_main_queue(), ^{
                     /// 发通知
                     [MBProgressHUD sy_showTips:@"注册成功"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:SYSwitchRootViewControllerNotification object:nil userInfo:@{SYSwitchRootViewControllerUserInfoKey:@(SYSwitchRootViewControllerFromTypeLogin)}];
                 });
             }
         }];
        return [RACSignal empty];
    }];
}

@end
