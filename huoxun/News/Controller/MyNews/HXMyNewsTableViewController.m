//
//  HXMyNewsTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMyNewsTableViewController.h"
#import "HXMyNewsTableViewCell.h"
#import "HXMyNoticeTableViewController.h"
#import "HXMyAttentionTableViewController.h"

@interface HXMyNewsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HXMyNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    self.tableView.estimatedSectionHeaderHeight = 20;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorNotice) name:kNotificationCalculatorNotice object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculatorNotice {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXMyNewsTableViewCell *cell = [HXMyNewsTableViewCell cellWithTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.cellLineRightMargin = TXCellRightMarginType16;
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cell.typeImageView.image = [UIImage imageNamed:@"news_attention"];
        cell.typeLabel.text = @"提醒";
        NSInteger attCount = [[TXModelAchivar getUserModel].attentionCount integerValue] - [[TXModelAchivar getUserModel].attentionLocalCount integerValue];
        cell.countLabel.hidden = attCount > 0 ? false : true;
        cell.countLabel.text = [NSString stringWithFormat:@"%ld", attCount];
    } else {
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.typeImageView.image = [UIImage imageNamed:@"news_notice"];
        cell.typeLabel.text = @"公告";
        NSInteger notiCount = [[TXModelAchivar getUserModel].notifyCount integerValue] - [[TXModelAchivar getUserModel].notifyLocalCount integerValue];
        cell.countLabel.hidden = notiCount > 0 ? false : true;
        cell.countLabel.text = [NSString stringWithFormat:@"%ld", notiCount];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [RCHttpHelper pushLoginViewControllerWithTarget:self.navigationController];
            return;
        }
        
        HXMyAttentionTableViewController *detailViewController = [[HXMyAttentionTableViewController alloc] initWithNibName:NSStringFromClass([HXMyAttentionTableViewController class]) bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        HXMyNoticeTableViewController *detailViewController = [[HXMyNoticeTableViewController alloc] initWithNibName:NSStringFromClass([HXMyNoticeTableViewController class]) bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

@end
