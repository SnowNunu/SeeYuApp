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

@end

@implementation SYWebVC {
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}

@dynamic viewModel;

- (void)dealloc {
    SYDealloc;
    [_webView stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)_setupSubViews {
    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    _webView = webView;
    [self.view addSubview:webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.viewModel.requestUrl]];
}

- (void)_makeSubViewsConstraints {
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:SY_WX_PAY_PREFIX]) {
        //新建webView
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:web];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                [newRequest setHTTPMethod:@"GET"];
                [newRequest setValue:SY_APP_SCHEME forHTTPHeaderField:@"Referer"];
                [web loadRequest:newRequest];
            });
        });
        return NO;
    } else if ([request.URL.absoluteString hasPrefix:@"alipays://"] || [request.URL.absoluteString hasPrefix:@"alipay://"]) {
        NSString *requestUrl = [self URLDecodeString:request.URL.absoluteString];
        //替换fromAppUrlScheme 为 本APP的UrlSheme
        NSString *newStr = [self changeScheme:requestUrl];
        NSString *encodeValue = [newStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:encodeValue];
        [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        return NO;
    }
    return YES;
}

// 替换UrlScheme
- (NSString *)changeScheme:(NSString *)str {
    NSArray *paramsArr = [str componentsSeparatedByString:@"?"];
    NSDictionary *dict = [self jsonToMessageDict:paramsArr.lastObject];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    mDict[@"fromAppUrlScheme"] = SY_APP_SCHEME;
    NSString *jsonStr = mDict.mj_JSONString; //MJExtension
    return [NSString stringWithFormat:@"%@?%@",paramsArr.firstObject,jsonStr];
}

- (NSDictionary *)jsonToMessageDict:(id)messageJson {
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:[messageJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    return messageDict ? : @{};
}

// URL decode
- (NSString *)URLDecodeString:(NSString *)str {
    NSString *decodeString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodeString;
}


@end
