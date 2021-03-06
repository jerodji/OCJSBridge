//
//  ViewController.m
//  TMEasyJSBridgeWebView
//
//  Created by 吉久东 on 2019/8/13.
//  Copyright © 2019 JIJIUDONG. All rights reserved.
//

#import "ViewController.h"

#import "WKWebView+RuntimeJSBridge.h"

#import "NativeMethods.h"
#import "IOSInterface.h"
#import "JSMethods.h"


@interface ViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGRect rect = CGRectMake(20, 88, self.view.bounds.size.width-40, self.view.bounds.size.height-300);

    self.webView = [[WKWebView alloc] initWithFrame:rect
                                      configuration:[[WKWebViewConfiguration alloc] init]
                                       listenerName:@"JSBridgeListener" // iOS,安卓,前端 三端保持一致
                                           services:@{
                                             @"testService": [NativeMethods new],
                                             @"ioService": [IOSInterface new]
                                           }];
        
    self.webView.navigationDelegate = self;
   [self.view addSubview:self.webView];
    
    NSString* _urlStr = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:_urlStr]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UILabel* l = [UILabel new];
    l.text = @"灰色这里是原生界面";
    l.frame = CGRectMake(20, self.view.bounds.size.height - 150, 310, 20);
    [self.view addSubview:l];
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.backgroundColor = [UIColor yellowColor];
    [b setTitle:@"黄色是原生按钮" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [b addTarget:self action:@selector(nativeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    b.frame = CGRectMake(20, self.view.bounds.size.height-100, 300, 50);
    [self.view addSubview:b];
}

- (void)nativeButtonClicked {
    NSLog(@"--- native: 主动调用JS divChangeColor方法");
    // MARK: 主动调用JS
    [self.webView invokeJSFunction:@"divChangeColor" params:@{@"color": [self Ox_randomColor]} completionHandler:^(id response, NSError *error) {
        NSLog(@"--- native: 执行 JS 方法完成.");
    }];
}

- (NSMutableString*)Ox_randomColor {
    NSMutableString* color = [[NSMutableString alloc] initWithString:@"#"];
    NSArray * STRING = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    for (int i=0; i<6; i++) {
        NSInteger index = arc4random_uniform((uint32_t)STRING.count);
        NSString *c = [STRING objectAtIndex:index];
        [color appendString:c];
    }
    return color;
}

@end
