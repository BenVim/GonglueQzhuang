//
//  SFWebViewController.m
//  Gonglue
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 Gonglue.com. All rights reserved.
//

#import "SFWebViewController.h"
#import "UMSlideNavigationController.h"

@interface SFWebViewController ()

- (void)back;
- (void)dismissKeyboard;

@end

@implementation SFWebViewController

#pragma mark - private

- (void)back
{
    [self.navigator popViewControllerAnimated:YES];
}

- (void)dismissKeyboard
{
    [self.webView endEditing:YES];
}

#pragma mark - parent

- (void)loadRequest {
    NSLog (@"SFWebViewController->loadRequest");
    if (! [@"http" isEqualToString:[self.url protocol]]) {
        self.url = [NSURL URLWithString:self.params[@"url"]];
    }
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestObj];
}

- (void)openedFromViewControllerWithURL:(NSURL *)aUrl
{
    NSLog (@"SFWebViewController->openedFromViewControllerWithURL");
    UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [navBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [navBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateHighlighted];
    navBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:navBtn];
    self.navigationItem.leftBarButtonItem = btnItem;
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog (@"SFWebViewController->webViewDidFinishLoad");
    [super webViewDidFinishLoad:webView];
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.body.removeChild(document.getElementById('header'));document.body.removeChild(document.getElementById('footer'));"];
    
    if (! [[self.params allKeys] containsObject:@"title"] || 0 >= [self.params[@"title"] length] ||1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        // note 颜色 头部
        label.textColor = [UIColor whiteColor];RGBCOLOR(92.0f, 92.0f, 92.0f);
        label.text = self.params[@"title"];//[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [label sizeToFit];
        self.navigationItem.titleView = label;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog (@"SFWebViewController->shouldStartLoadWithRequest");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // note 颜色 头部
    label.textColor = [UIColor whiteColor];//RGBCOLOR(92.0f, 92.0f, 92.0f);
    label.text = @"载入中...";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    // 如果是退出请求 http://gonglue.me/user/logout ，拦截
    return YES;
}

#pragma mark

- (void)viewDidLoad
{
    NSLog (@"SFWebViewController->viewDidLoad");
    [super viewDidLoad];
    
    if (! [@"login" isEqualToString:[self.url host]]
        && 1 == [self.params[@"login"] intValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SFNotificationLogout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRequest) name:SFNotificationLogout object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMNotificationWillShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard) name:UMNotificationWillShow object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBCOLOR(92.0f, 92.0f, 92.0f);

//    if ([[self.params allKeys] containsObject:@"title"] && 0 < [self.params[@"title"] length]) {
//        label.text = self.params[@"title"];
//    }
//    else {
//        label.text = @"Loading...";
//    }
    label.text = @"载入中...";
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

@end
