//
//  UMWebViewController.h
//  Gonglue
//
//  Created by jiajun on 12/12/12.
//  Copyright (c) 2012 Gonglue.com. All rights reserved.
//

#import "UMViewController.h"

@interface UMWebViewController : UMViewController <UIWebViewDelegate>

@property (strong, nonatomic)   UIWebView                 *webView;

- (void)loadRequest;
- (void)reloadToolBar;

@end