//
//  ViewController.m
//  BlocBrowser
//
//  Created by Cynthia Whitlatch on 5/7/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//
//new

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webView;
//@property(nonatomic, assign) id< UIWebViewDelegate > delegate

@end

@implementation ViewController

- (void)loadView {
    UIView *mainView = [UIView new];

    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    NSString *urlString = @"http://wikipedia.org";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [mainView addSubview:self.webView];
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
    
- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
        
    //make the webview fill the main view
    self.webView.frame = self.view.frame;
}

@end
