//
//  SYTopUpVC.m
//  SeeYu
//
//  Created by 唐荣才 on 2019/5/17.
//  Copyright © 2019 fljj. All rights reserved.
//

#import "SYTopUpVC.h"

@interface SYTopUpVC ()

@end

@implementation SYTopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _setupSubViews];
    [self _makeSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.viewModel.payUrl]]];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (void)_setupSubViews {
    UIWebView *webView = [UIWebView new];
    webView.delegate = self;
    _webView = webView;
    [self.view addSubview:webView];
}

- (void)_makeSubViewsConstraints {
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* reqUrl = request.URL.absoluteString;
//    if ([reqUrl hasPrefix:@"https://openapi.alipay.com/gateway.do"] || [reqUrl hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
//        //bSucc是否成功调起支付宝
//        if (!bSucc) {
//            NSLog(@"调用失败");
//            return NO;
//        }
//    }
    return YES;
}

@end
