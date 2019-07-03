//
//  SYRegisterVM.m
//  WeChat
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYRegisterVM.h"
#import "SYRegisterVM.h"
#import "SYLoginVM.h"
#import "CocoaSecurity.h"

@interface SYRegisterVM ()

@end

@implementation SYRegisterVM

- (void)initialize {
    [super initialize];
    self.title = @"基本信息";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    @weakify(self);
    self.registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        // 随机生成六位数作为用户密码(并使用aes加密)
        NSString *strRandom = @"";
        for(int i = 0; i < 6; i++) {
            strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
        }
        NSString *password = [CocoaSecurity md5:strRandom].hexLower;
        self.password = password;
        NSDictionary *parameters = @{@"userPassword":password,@"userName":self.alias,@"userAge":self.age,@"userGender":self.gender,@"userProfession":self.job,@"userIncome":self.income,@"userHeight":self.height,@"userMarry":self.maritalStatus,@"userChannelId":SY_APP_CHANNEL,@"userFrom":@"2"};
        SYKeyedSubscript *subscript = [[SYKeyedSubscript alloc]initWithDictionary:parameters];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_USER_REGISTER parameters:subscript.dictionary];
        return [[[self.services.client enqueueRequest:[SYHTTPRequest requestWithParameters:paramters] resultClass:[SYUser class]] sy_parsedResults] takeUntil:self.rac_willDeallocSignal];
    }];
    self.enterLoginViewCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        SYLoginVM *vm = [[SYLoginVM alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:vm animated:YES];
        return [RACSignal empty];
    }];
}

@end
