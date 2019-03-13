//
//  SYRegisterVC.h
//  SeeYu
//
//  Created by senba on 2017/9/26.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  `首次`使用微信的选择登录Or注册界面

#import "SYVC.h"
#import "SYRegisterVM.h"
#import "SYRegisterView.h"
#import "ActionSheetPicker.h"

@interface SYRegisterVC : SYVC

@property(nonatomic, weak) SYRegisterView *registerView;

@property(nonatomic, strong) SYRegisterVM *viewModel;

@end
