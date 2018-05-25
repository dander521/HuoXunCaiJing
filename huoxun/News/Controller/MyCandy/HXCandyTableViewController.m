//
//  HXCandyTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyTableViewController.h"
#import "HXCandyHeaderTableViewCell.h"
#import "HXCandyShareTableViewCell.h"
#import "TXShowWebViewController.h"
#import "HXCandyDetailTableViewController.h"
#import "HXCandyRechargeTableViewController.h"


@interface HXCandyTableViewController () <HXCandyShareTableViewCellDelegate, HXCandyHeaderTableViewCellDelegate>

@property (nonatomic, strong) NSString *candyNum;

@end

@implementation HXCandyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"积分";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"积分规则" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(candyRules) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItems = @[attention];
    
    [self getCandyNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)getCandyNumber {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getMySugar]
                             headParams:[RCHttpHelper accessAndLoginTokenHeader]
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    if ([responseObject[@"code"] integerValue] == 200) {
                                        self.candyNum = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
                                        [self.tableView reloadData];
                                    } else {
                                        [ShowMessage showMessage:responseObject[@"message"]];
                                    }
                                } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                } isLogin:^{
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
                                }];
}


#pragma mark - Custom Method

- (void)candyRules {
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = URL_CANDY_RULES;
    vwcWeb.naviTitle = @"积分规则";
    vwcWeb.isShowShare = true;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HXCandyHeaderTableViewCell *cell = [HXCandyHeaderTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.countLabel.text = self.candyNum;
        return cell;
    } else {
        HXCandyShareTableViewCell *cell = [HXCandyShareTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.titleImageVuew.image = [UIImage imageNamed:@"share_article"];
            cell.nameLabel.text = @"分享文章";
            cell.subLabel.text = @"分享文章给好友，即可抽取随机积分";
            [cell.shareBtn setTitle:@"去分享" forState:UIControlStateNormal];
        } else {
            cell.titleImageVuew.image = [UIImage imageNamed:@"invite_register"];
            cell.nameLabel.text = @"邀请注册";
            cell.subLabel.text = @"邀请好友注册，双方均能获得积分";
            [cell.shareBtn setTitle:@"去邀请" forState:UIControlStateNormal];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//        footerView.backgroundColor = [UIColor whiteColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 20)];
//        label.text = @"如何获取更多积分？";
//        label.font = FONT(14);
//        label.textColor = RGB(153, 153, 153);
//        [footerView addSubview:label];
//        return footerView;
        return nil;
    } else {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 20)];
        label.text = @"更多任务即将开启，敬请期待";
        label.font = FONT(14);
        label.textColor = RGB(153, 153, 153);
        label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 280.0;
    } else {
        return 80.0;
    }
}

#pragma mark - HXCandyHeaderTableViewCellDelegate

- (void)selectDetailButton {
    HXCandyDetailTableViewController *vwcHistory = [[HXCandyDetailTableViewController alloc] initWithNibName:NSStringFromClass([HXCandyDetailTableViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcHistory animated:true];
}

- (void)selectRechargeButton {
    HXCandyRechargeTableViewController *vwcHistory = [[HXCandyRechargeTableViewController alloc] initWithNibName:NSStringFromClass([HXCandyRechargeTableViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcHistory animated:true];
}

- (void)selectExchangeButton {
    TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
    vwcWeb.webViewUrl = URL_CANDY_EXCHANGE;
    vwcWeb.naviTitle = @"积分兑换";
    vwcWeb.isShowShare = false;
    [self.navigationController pushViewController:vwcWeb animated:true];
}

#pragma mark - HXCandyShareTableViewCellDelegate

- (void)selectShareWithTitle:(NSString *)title {
    if ([title isEqualToString:@"去分享"]) {
        // 跳转首页
        [self.navigationController popToRootViewControllerAnimated:false];
        [[AppDelegate sharedAppDelegate].tabBar setSelectedIndex:0];
    } else {
        // h5页面
        TXShowWebViewController *vwcWeb = [TXShowWebViewController new];
        vwcWeb.webViewUrl = [NSString stringWithFormat:@"%@%@", URL_REGISTER, [TXModelAchivar getUserModel].idField];
        vwcWeb.naviTitle = @"邀请注册";
        vwcWeb.isShowShare = true;
        [self.navigationController pushViewController:vwcWeb animated:true];
    }
}

@end
