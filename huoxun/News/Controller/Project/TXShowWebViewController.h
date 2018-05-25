//
//  TXShowWebViewController.h
//  TailorX
//
//  Created by RogerChen on 2017/4/13.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWebView.h"

@interface TXShowWebViewController : UIViewController

@property (nonatomic, strong) TXWebView *webView;
/** webViewUrl */
@property (nonatomic, strong) NSString *webViewUrl;
/** naviTitle */
@property (nonatomic, strong) NSString *naviTitle;

@property (nonatomic, assign) BOOL isShowShare;

@end
