//
//  HXMarketViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/4.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMarketViewController.h"
#import "TXWebView.h"

@interface HXMarketViewController ()

@end

@implementation HXMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TXWebView *webView = [[TXWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    webView.requestUrl = @"http://huoxun.com/m/market?app=yes";
    [self.view addSubview:webView];
    
    // 定义全局leftBarButtonItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
