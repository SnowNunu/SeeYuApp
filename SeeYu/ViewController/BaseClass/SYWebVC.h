//
//  SYWebVC.h
//  SeeYu
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有需要显示WKWebView的自定义视图控制器的基类

#import "SYVC.h"
#import "SYWebVM.h"
#import <WebKit/WebKit.h>
#import "SYWebVM.h"
#import "WebChatPayH5View.h"

@interface SYWebVC : SYVC <WKNavigationDelegate>

/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;

@property (nonatomic, strong) SYWebVM *viewModel;

@end
