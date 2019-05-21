//
//  SYTopUpVC.h
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYVC.h"
#import "SYTopUpVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYTopUpVC : SYVC <UIWebViewDelegate>

@property (nonatomic, strong) SYTopUpVM *viewModel;

@property (nonatomic, strong) UIWebView *webView;

@end

NS_ASSUME_NONNULL_END