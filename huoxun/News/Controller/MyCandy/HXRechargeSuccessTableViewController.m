//
//  HXRechargeSuccessTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeSuccessTableViewController.h"
#import "HXRechargeSuccessTableViewCell.h"
#import "HXCandyTableViewController.h"

@interface HXRechargeSuccessTableViewController ()

@end

@implementation HXRechargeSuccessTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值积分";
    
    self.tableView.estimatedSectionHeaderHeight = 20.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(rechargeSuccess) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(14);
    UIBarButtonItem *attention = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItems = @[attention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (void)rechargeSuccess {
//    [self.navigationController popToRootViewControllerAnimated:true];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HXCandyTableViewController class]]) {
            HXCandyTableViewController *vwcCandy =(HXCandyTableViewController *)controller;
            [self.navigationController popToViewController:vwcCandy animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXRechargeSuccessTableViewCell *cell = [HXRechargeSuccessTableViewCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
