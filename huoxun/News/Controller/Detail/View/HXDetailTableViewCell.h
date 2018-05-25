//
//  HXDetailTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNewsDetailViewController.h"
#import <WebKit/WebKit.h>

@interface HXDetailTableViewCell : TXSeperateLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSString *htmlString;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, weak) HXNewsDetailViewController *controllerView;

@end
