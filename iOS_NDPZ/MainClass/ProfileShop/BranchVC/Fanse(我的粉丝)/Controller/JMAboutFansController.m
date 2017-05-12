//
//  JMAboutFansController.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMAboutFansController.h"
#import "IMYWebView.h"
#import "JMEmptyView.h"
#import "JumpUtils.h"
#import "IosJsBridge.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgressView.h"
#import "WebViewJavascriptBridge.h"
#import "JMRegisterJS.h"


@interface JMAboutFansController () <IMYWebViewDelegate,UIWebViewDelegate,WKUIDelegate> {
    NSString *loadLink;
}

@property (nonatomic ,strong) IMYWebView *baseWebView;
@property (nonatomic, strong) JMEmptyView *empty;


@end

@implementation JMAboutFansController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"关于粉丝" selecotr:@selector(backBtnClicked:)];
    
    
    loadLink = @"https://m.nidepuzi.com/mall/mama/invited";
    
    [self emptyView];
    self.baseWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) usingUIWebView:NO];
    self.baseWebView.scalesPageToFit = YES;
    self.baseWebView.viewController = self;
    self.baseWebView.delegate = self;
    [self.view addSubview:self.baseWebView];
    
    [[JMGlobal global] showWaitLoadingInView:self.baseWebView];
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadLink]]];
    
//    if(self.baseWebView.usingUIWebView) {
//        [self registerJsBridge];
//    }
}
- (void)refresh {
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadLink]]];
}
//- (void)registerJsBridge {
//    JMRegisterJS *regis = [[JMRegisterJS alloc] init];
//    [regis registerJSBridgeBeforeIOSSeven:self WebView:self.baseWebView];
//}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
    //    self.empty.hidden = NO;
    //    [[JMGlobal global] hideWaitLoading];
}
- (void)webViewDidStartLoad:(IMYWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    self.empty.hidden = YES;
    //    self.baseWebView.cs_h = SCREENHEIGHT - 20 - kAppTabBarHeight;
    [[JMGlobal global] hideWaitLoading];
}
- (void)emptyView {
    kWeakSelf
    self.empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 300) / 2, SCREENWIDTH, 300) Title:@"~~(>_<)~~" DescTitle:@"网络加载失败~!" BackImage:@"netWaring" InfoStr:@"重新加载"];
    [self.view addSubview:self.empty];
    self.empty.hidden = YES;
    self.empty.block = ^(NSInteger index) {
        if (index == 100) {
            kStrongSelf
            strongSelf.empty.hidden = YES;
            [strongSelf refresh];
//            [strongSelf.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadLink]]];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
@end













