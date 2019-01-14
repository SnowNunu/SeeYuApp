//
//  SYRegisterVC.h
//  WeChat
//
//  Created by senba on 2017/10/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  注册账号

#import "SYVC.h"
#import "SYRegisterVM.h"
#import "SYRegisterView.h"
#import "ActionSheetPicker.h"
@interface SYRegisterVC : SYVC 

@property (nonatomic, strong) SYRegisterVM *viewModel;

@property(nonatomic, weak) SYRegisterView *registerView;

@end
