//
//  SYWebVC.m
//  SeeYu
//
//  Created by senba on 2017/9/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SYWebVC.h"
#import "FBKVOController+SYExtension.h"
#import "UIScrollView+SYRefresh.h"

/// KVO 监听的属性
/// 加载情况
static NSString * const SYWebViewKVOLoading = @"loading";
/// 文章标题
static NSString * const SYWebViewKVOTitle = @"title";
/// 进度
static NSString * const SYWebViewKVOEstimatedProgress = @"estimatedProgress";

@interface SYWebVC ()
/// webView
@property (nonatomic, weak, readwrite) WKWebView *webView;
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;
/// 返回按钮
@property (nonatomic, readwrite, strong) UIBarButtonItem *backItem;
/// 关闭按钮 （点击关闭按钮  退出WebView）
@property (nonatomic, readwrite, strong) UIBarButtonItem *closeItem;

@end

@implementation SYWebVC
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)dealloc {
    SYDealloc;
    [_webView stopLoading];
}

- (instancetype)initWithViewModel:(SYWebVM *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
    /// 加载请求数据
    [self.webView loadRequest:self.viewModel.request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 添加断言，request错误 应用直接crash
    NSParameterAssert(self.viewModel.request);
    
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    
    ///CoderMikeHe FIXED: 切记 lightempty_ios 是前端跟H5商量的结果，请勿修改。
    NSString *userAgent = @"wechat_ios";
    
    if (!(SYIOSVersion>=9.0)) [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"userAgent":userAgent}];
    
    /// 注册JS
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    /// 这里可以注册JS的处理 涉及公司私有方法 这里笔者不作处理

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // CoderMikeHe Fixed : 自适应屏幕宽度js
    NSString *jsString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    [userContentController addUserScript:userScript];
    /// 赋值userContentController
    configuration.userContentController = userContentController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    if ((SYIOSVersion >= 9.0)) webView.customUserAgent = userAgent;
    self.webView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"navigator.userAgent.result is ++++ %@", result);
    }];
    
    /// 监听数据
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    /// binding self.viewModel.avatarUrlString
    [_KVOController sy_observe:self.webView keyPath:SYWebViewKVOTitle block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        /// CoderMikeHe FIXED: 这里只设置导航栏的title 以免self.title 设置了tabBarItem.title
        if (!self.viewModel.shouldDisableWebViewTitle) self.navigationItem.title = self.webView.title;
    }];
    [_KVOController sy_observe:self.webView keyPath:SYWebViewKVOLoading block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"--- webView is loading ---");
    }];
    
    [_KVOController sy_observe:self.webView keyPath:SYWebViewKVOEstimatedProgress block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }];

    /// 添加刷新控件
    if(self.viewModel.shouldPullDownToRefresh){
        [self.webView.scrollView sy_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            @strongify(self);
            [self.webView reload];
        }];
        [self.webView.scrollView.mj_header beginRefreshing];
    }
    self.webView.scrollView.contentInset = self.contentInset;
    
    /// CoderMikeHe: 适配 iPhone X + iOS 11，去掉安全区域
    if (@available(iOS 11.0, *)) {
        SYAdjustsScrollViewInsets_Never(webView.scrollView);
    }
}

#pragma mark - 事件处理
- (void)_backItemDidClicked { /// 返回按钮事件处理
    /// 可以返回到上一个网页，就返回到上一个网页
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {/// 不能返回上一个网页，就返回到上一个界面
        /// 判断 是Push还是Present进来的，
        if (self.presentingViewController) {
            [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
        } else {
            [self.viewModel.services popViewModelAnimated:YES];
        }
    }
}

- (void)_closeItemDidClicked {
    /// 判断 是Push还是Present进来的
    if (self.presentingViewController) {
        [self.viewModel.services dismissViewModelAnimated:YES completion:NULL];
    } else {
        [self.viewModel.services popViewModelAnimated:YES];
    }
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    /// js call OC function
    
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    /// 不显示关闭按钮
    if(self.viewModel.shouldDisableWebViewClose) return;

    UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
    if (backItem) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[backItem, self.closeItem]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[backItem]];
        }
    }
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.viewModel.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
//    NSURLRequest *request        = navigationAction.request;
//    NSString     *scheme         = [request.URL scheme];
    
    static NSString *endPayRedirectURL = nil;
    NSString *requestUrl = navigationAction.request.URL.absoluteString;
//    https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx10165830910861b05d2a1ae31485662244&package=3537174028
    
    // Wechat Pay, Note : modify redirect_url to resolve we couldn't return our app from wechat client.
//    if ([requestUrl hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![requestUrl hasSuffix:@"redirect_url=seeyu.zhyst.cn://"]) {
//        decisionHandler(WKNavigationActionPolicyCancel);

        // 1. If the url contain "redirect_url" : We need to remember it to use our scheme replace it.
        // 2. If the url not contain "redirect_url" , We should add it so that we will could jump to our app.
        //  Note : 2. if the redirect_url is not last string, you should use correct strategy, because the redirect_url's value may contain some "&" special character so that my cut method may be incorrect.
//        NSString *redirectUrl = nil;
//        if ([requestUrl containsString:@"redirect_url="]) {
//            NSRange redirectRange = [requestUrl rangeOfString:@"redirect_url"];
//            endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
//            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=xdx.%@://",CompanyFirstDomainByWeChatRegister]];
//        } else {
//            redirectUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=seeyu.zhyst.cn://"]];
//        }
//
//        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//        newRequest.allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields;
//        newRequest.URL = [NSURL URLWithString:redirectUrl];
//        [webView loadRequest:newRequest];
//        return;
//    }
    
    // Judge is whether to jump to other app.
    
//    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//        if ([scheme isEqualToString:@"weixin"]) {
//            // The var endPayRedirectURL was our saved origin url's redirect address. We need to load it when we return from wechat client.
//            if (endPayRedirectURL) {
//                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:XDX_URL_TIMEOUT]];
//            }
//        }else if ([scheme isEqualToString:[NSString stringWithFormat:@"xdx.%@",CompanyFirstDomainByWeChatRegister]]) {
//
//        }
//
//        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:request.URL];
//        if (canOpen) {
//            [[UIApplication sharedApplication] openURL:request.URL];
//        }
//        return;
//    }
    
    // ------  对alipays:相关的scheme处理 -------
    // 若遇到支付宝相关scheme，则跳转到本地支付宝App
    if ([requestUrl hasPrefix:@"alipays://"] || [requestUrl hasPrefix:@"alipay://"]) {
        // 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
        
        // 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            NSLog(@"跳转失败");
            [self alertControllerWithMessage:@"未检测到支付宝客户端，请您安装后重试。"];
        }
    } else if ([requestUrl hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"]) {
        NSDictionary *header = navigationAction.request.allHTTPHeaderFields;
        if (header[@"Referer"] == nil) {
            decisionHandler(WKNavigationActionPolicyCancel);
            NSMutableURLRequest *mutableRequest = [navigationAction.request mutableCopy];
            [mutableRequest setValue:@"seeyu.zhyst.cn" forHTTPHeaderField:@"Referer"];
            [webView loadRequest:mutableRequest];
            return;
        }
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL];
        if (canOpen) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        }
    }
    // 确认可以跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)alertControllerWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"立即安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // NOTE: 跳转itune下载支付宝App
        NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
        NSURL *downloadUrl = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication]openURL:downloadUrl];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /// CoderMike Fixed : 解决点击网页的链接 不跳转的Bug。
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark runJavaScript
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [NSObject sy_showAlertViewWithTitle:nil message:message confirmTitle:@"我知道了"];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    completionHandler(defaultText);
}



#pragma mark - Getter & Setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = SY_SCREEN_WIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        progressView.progressTintColor = SY_MAIN_TINTCOLOR;
        progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}


- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem sy_backItemWithTitle:@"返回" imageName:@"nav_btn_back" target:self action:@selector(_backItemDidClicked)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem sy_systemItemWithTitle:@"关闭" titleColor:nil imageName:nil target:self selector:@selector(_closeItemDidClicked) textType:YES];
    }
    return _closeItem;
}



@end
