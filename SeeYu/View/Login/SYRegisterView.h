//
//  SYRegisterView.h
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/31.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYRegisterView : UIView

/// 职业选择框
@property(nonatomic, weak) UITextField *jobTextField;

/// 收入选择框
@property(nonatomic, weak) UIButton *incomeBtn;

/// 身高选择框
@property(nonatomic, weak) UIButton *heightBtn;

/// 婚姻状态选择框
@property(nonatomic, weak) UIButton *maritalStatusBtn;

/// 体壮如牛按钮
@property(nonatomic, weak) UIButton *strongTipsBtn;

/// 车技娴熟按钮
@property(nonatomic, weak) UIButton *technologyTipsBtn;

/// 稳重成熟按钮
@property(nonatomic, weak) UIButton *steadyTipsBtn;

/// 温柔贤淑按钮
@property(nonatomic, weak) UIButton *softTipsBtn;

/// 英俊潇洒按钮
@property(nonatomic, weak) UIButton *smartTipsBtn;

/// 耐力持久按钮
@property(nonatomic, weak) UIButton *durableTipsBtn;

/// 下一步按钮
@property(nonatomic, weak) UIButton *completeBtn;

+ (instancetype)registerView;

@end

NS_ASSUME_NONNULL_END
