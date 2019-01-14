//
//  SYBootRegisterVC.h
//  SeeYu
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  `首次`使用微信的选择登录Or注册界面

#import "SYVC.h"
#import "SYBootRegisterVM.h"
#import "SYBootRegisterView.h"
#import "ActionSheetPicker.h"

@interface SYBootRegisterVC : SYVC

@property(nonatomic, weak) SYBootRegisterView *bootRegisterView;

@property(nonatomic, strong) SYBootRegisterVM *viewModel;

@end
