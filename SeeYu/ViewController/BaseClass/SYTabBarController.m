//
//  SYTabBarController.m
//  WeChat
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYTabBarController.h"
#import "SYTabBar.h"
@interface SYTabBarController ()
/// tabBarController
@property (nonatomic, strong, readwrite) UITabBarController *tabBarController;
@end

@implementation SYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    /// 添加子控制器
    [self.view addSubview:self.tabBarController.view];
    [self addChildViewController:self.tabBarController];
    [self.tabBarController didMoveToParentViewController:self];
    
    // kvc替换系统的tabBar
    SYTabBar *tabbar = [[SYTabBar alloc] init];
    //kvc实质是修改了系统的_tabBar
    [self.tabBarController setValue:tabbar forKeyPath:@"tabBar"];
    if (SY_IS_IPHONE_X) {
        [[UITabBar appearance] setBackgroundImage:SYImageNamed(@"tabbar_x")];
    } else {
        [[UITabBar appearance] setBackgroundImage:SYImageNamed(@"tabbar")];
    }
}

#pragma mark - Ovveride
- (BOOL)shouldAutorotate {
    return self.tabBarController.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.tabBarController.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.tabBarController.selectedViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.tabBarController.selectedViewController.prefersStatusBarHidden;
}
@end
