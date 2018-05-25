//
//  HXRechargeHistoryTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRechargeHistoryModel.h"

@protocol HXRechargeHistoryTableViewCellDelegate <NSObject>

- (void)selectAddressButtonWithModel:(HXRechargeHistoryModel *)model;

@end

@interface HXRechargeHistoryTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HXRechargeHistoryTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) HXRechargeHistoryModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
