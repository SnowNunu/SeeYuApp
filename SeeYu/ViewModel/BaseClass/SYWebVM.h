//
//  SYWebVM.h
//  SeeYu
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有含有`WKWebView`的视图的视图模型基类

#import "SYVM.h"

@interface SYWebVM : SYVM

/// url
@property (nonatomic, readwrite, copy) NSURL *requestUrl;

/// 下拉刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;

/// 是否取消关闭按钮。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewClose;

@end
