//
//  HXRechargeHistoryDetailTableViewController.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeHistoryDetailTableViewController.h"
#import "HXRechargeHeaderTableViewCell.h"
#import "HXRechargeProcessTableViewCell.h"
#import "HXRechargeAmountTableViewCell.h"

@interface HXRechargeHistoryDetailTableViewController ()

@end

@implementation HXRechargeHistoryDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 165;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ([self.model.update_time isEqualToString:@"0"]) {
            return 2;
        } else {
            return 4;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HXRechargeHeaderTableViewCell *cell = [HXRechargeHeaderTableViewCell cellWithTableView:tableView];
        cell.model = self.model;
        return cell;
    } else {
        if ([self.model.update_time isEqualToString:@"0"]) {
            if (indexPath.row == 0) {
                HXRechargeProcessTableViewCell *cell = [HXRechargeProcessTableViewCell cellWithTableView:tableView];
                cell.cellType = HXRechargeProcessCellTypeRed;
                cell.model = self.model;
                if (self.isAttention) {
                    cell.monthLabel.text = [self.create_time componentsSeparatedByString:@" "].firstObject;
                    cell.timeLabel.text = [self.create_time componentsSeparatedByString:@" "].lastObject;
                } else {
                    cell.monthLabel.text = [self.model.create_time componentsSeparatedByString:@" "].firstObject;
                    cell.timeLabel.text = [self.model.create_time componentsSeparatedByString:@" "].lastObject;
                }
                cell.statusLabel.text = @"待审核";
                return cell;
            } else {
                HXRechargeAmountTableViewCell *cell = [HXRechargeAmountTableViewCell cellWithTableView:tableView];
                cell.model = self.model;
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                HXRechargeProcessTableViewCell *cell = [HXRechargeProcessTableViewCell cellWithTableView:tableView];
                cell.cellType = HXRechargeProcessCellTypeRed;
                cell.model = self.model;
                cell.monthLabel.text = [self.model.update_time componentsSeparatedByString:@" "].firstObject;
                cell.timeLabel.text = [self.model.update_time componentsSeparatedByString:@" "].lastObject;
                cell.statusLabel.text = @"充值成功";
                return cell;
            } else if (indexPath.row == 1) {
                HXRechargeProcessTableViewCell *cell = [HXRechargeProcessTableViewCell cellWithTableView:tableView];
                cell.cellType = HXRechargeProcessCellTypeGray;
                cell.model = self.model;
                cell.monthLabel.text = [self.model.update_time componentsSeparatedByString:@" "].firstObject;
                cell.timeLabel.text = [self.model.update_time componentsSeparatedByString:@" "].lastObject;
                cell.statusLabel.text = @"审核成功待充值";
                return cell;
            } else if (indexPath.row == 2) {
                HXRechargeProcessTableViewCell *cell = [HXRechargeProcessTableViewCell cellWithTableView:tableView];
                cell.cellType = HXRechargeProcessCellTypeGray;
                cell.model = self.model;
                if (self.isAttention) {
                    cell.monthLabel.text = [self.create_time componentsSeparatedByString:@" "].firstObject;
                    cell.timeLabel.text = [self.create_time componentsSeparatedByString:@" "].lastObject;
                } else {
                    cell.monthLabel.text = [self.model.create_time componentsSeparatedByString:@" "].firstObject;
                    cell.timeLabel.text = [self.model.create_time componentsSeparatedByString:@" "].lastObject;
                }
                cell.statusLabel.text = @"待审核";
                return cell;
            } else {
                HXRechargeAmountTableViewCell *cell = [HXRechargeAmountTableViewCell cellWithTableView:tableView];
                cell.model = self.model;
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}



@end
