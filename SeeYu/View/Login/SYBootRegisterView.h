//
//  SYBootRegisterView.h
//  SeeYu
//
//  Created by 唐荣才 on 2018/12/29.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYBootRegisterView : UIView 

/// 昵称输入框
@property(nonatomic, weak) UITextField *aliasTextField;

/// 年龄按钮
@property(nonatomic, weak) UIButton *ageBtn;

/// "男"按钮
@property(nonatomic, weak) UIButton *maleBtn;

/// "男"文本
@property(nonatomic, weak) UILabel *maleLabel;

/// "女"按钮
@property(nonatomic, weak) UIButton *femaleBtn;

/// "女"文本
@property(nonatomic, weak) UILabel *femaleLabel;

/// 下一步按钮
@property(nonatomic, weak) UIButton *nextBtn;

+ (instancetype)bootRegisterView;

@end

NS_ASSUME_NONNULL_END
