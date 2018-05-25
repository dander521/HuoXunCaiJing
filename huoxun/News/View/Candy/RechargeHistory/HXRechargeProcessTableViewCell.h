//
//  HXRechargeProcessTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRechargedModel.h"

typedef NS_ENUM(NSInteger, HXRechargeProcessCellType) {
    HXRechargeProcessCellTypeRed,
    HXRechargeProcessCellTypeGray
};

@interface HXRechargeProcessTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, assign) HXRechargeProcessCellType cellType;

@property (nonatomic, strong) HXRechargedModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
