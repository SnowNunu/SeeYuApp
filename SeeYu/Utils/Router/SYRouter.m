//
//  SYRouter.m
//  WeChat
//
//  Created by senba on 2017/9/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYRouter.h"


@interface SYRouter ()

/// viewModel到viewController的映射
@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation SYRouter

static SYRouter *sharedInstance_ = nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{ 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [super allocWithZone:zone];
    });
    return sharedInstance_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return sharedInstance_;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [[self alloc] init];
    });
    return sharedInstance_;
}

- (SYVC *)viewControllerForViewModel:(SYVM *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
//    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[SYVC class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}


/// 这里是viewModel -> ViewController的映射
/// If You Use Push 、 Present 、 ResetRootViewController ,You Must Config This Dict
- (NSDictionary *)viewModelViewMappings {
    return @{@"SYGuideVM":@"SYGuideVC",
             @"SYLoginVM":@"SYLoginVC",
             @"SYRegisterVM":@"SYRegisterVC",
             @"SYHomePageVM":@"SYHomePageVC",
             @"SYUserInfoVM":@"SYUserInfoVC",
             @"SYFeatureSignatureVM":@"SYFeatureSignatureVC",
             @"SYSettingViewModel":@"SYSettingViewController",
             @"SYWebVM":@"SYWebVC",
             @"SYModifyNicknameVM":@"SYModifyNicknameVC",
             @"SYTestViewModel":@"SYTestViewController",
             @"SYSettingVM":@"SYSettingVC",
             @"SYAboutUsViewModel":@"SYAboutUsViewController",
             @"SYPrivacyViewModel":@"SYPrivacyViewController",
             @"SYGeneralViewModel":@"SYGeneralViewController",
             @"SYMomentVM":@"SYMomentVC",
             @"SYProfileInfoViewModel":@"SYProfileInfoViewController",
             @"SYAuthenticationVM":@"SYAuthenticationVC",
             @"SYMobileBindingVM":@"SYMobileBindingVC",
             @"SYRealnameVM":@"SYRealnameVC",
             @"SYSelfieVM":@"SYSelfieVC",
             @"SYDiamondsVM":@"SYDiamondsVC",
             @"SYRechargeVM":@"SYRechargeVC",
             @"SYHobbyVM":@"SYHobbyVC",
             @"SYCollectVM":@"SYCollectVC"
             };
}

@end
