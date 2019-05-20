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
#import "SYAlipayModel.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    webView.navigationDelegate = self;
    _webView = webView;
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    /// CoderMikeHe: 适配 iPhone X + iOS 11，去掉安全区域
    if (@available(iOS 11.0, *)) {
        SYAdjustsScrollViewInsets_Never(webView.scrollView);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.viewModel.requestUrl]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

#pragma mark - 事件处理
- (void)_backItemDidClicked {
    /// 返回按钮事件处理
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
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"网页连接:%@",url);
    if ([url containsString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"]) {
#warning 微信支付链接不要拼接redirect_url，如果拼接了还是会返回到浏览器的
        //传入的是微信支付链接：https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx201801291021026cb304f9050743178155&package=3456576571
        //这里把webView设置成一个像素点，主要是不影响操作和界面，主要的作用是设置referer和调起微信
        WebChatPayH5View *h5View = [[WebChatPayH5View alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        //url是没有拼接redirect_url微信h5支付链接
        [h5View loadingURL:url withIsWebChatURL:NO];
        [self.view addSubview:h5View];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if([url containsString:@"alipay://alipayclient"]) {
        NSLog(@"%@",[url decodeFromPercentEscapeString]);
        NSArray *array = [[url decodeFromPercentEscapeString] componentsSeparatedByString:@"?"];
        NSString *jsonString = array[1];
        SYAlipayModel *model = [SYAlipayModel yy_modelWithJSON:jsonString];
        model.fromAppUrlScheme = @"seeyu.zhyst.cn://";
        NSString *modifyString = [model yy_modelToJSONString];
        NSString *payUrl = [NSString stringWithFormat:@"%@?%@",array[0],modifyString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payUrl]];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
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

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
