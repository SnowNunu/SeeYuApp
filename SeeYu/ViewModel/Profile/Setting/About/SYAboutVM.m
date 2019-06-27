//
//  SYAboutVM.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/13.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYAboutVM.h"

@implementation SYAboutVM

- (instancetype)initWithServices:(id<SYViewModelServices>)services params:(NSDictionary *)params {
    if (self = [super initWithServices:services params:params]) {
        
    }
    return self;
}

- (void)initialize {
    [super initialize];
    self.title = @"关于我们";
    self.backTitle = @"";
    self.prefersNavigationBarBottomLineHidden = YES;
    self.requestUpdateInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SYKeyedSubscript *subscript = [SYKeyedSubscript subscript];
        SYURLParameters *paramters = [SYURLParameters urlParametersWithMethod:SY_HTTTP_METHOD_POST path:SY_HTTTP_PATH_APP_UPDATE_INFO parameters:subscript.dictionary];
        SYHTTPRequest *request = [SYHTTPRequest requestWithParameters:paramters];
        return [[self.services.client enqueueRequest:request resultClass:[SYAppUpdateModel class]] sy_parsedResults];
    }];
    [self.requestUpdateInfoCommand.executionSignals.switchToLatest.deliverOnMainThread subscribeNext:^(SYAppUpdateModel *model) {
        if ([SY_APP_VERSION floatValue] >= model.version) {
            [MBProgressHUD sy_showTips:@"当前已经是最新版本！"];
        } else {
            // 提示应用需要更新
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到APP有新的版本，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (model.downloadLink != nil && model.downloadLink.length > 0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadLink]];
                }
            }]];
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [self.requestUpdateInfoCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD sy_showErrorTips:error];
    }];
}

@end
