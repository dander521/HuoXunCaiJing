//
//  HXProjectDetailIntroductTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectDetailIntroductTableViewCell.h"

@interface HXProjectDetailIntroductTableViewCell ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HXProjectDetailIntroductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://huoxun.com"]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXProjectDetailIntroductTableViewCell";
    HXProjectDetailIntroductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue]; //此方法获取webview的内容高度（建议使用）
    //设置通知或者代理来传高度
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getProjectCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error);
}

@end
