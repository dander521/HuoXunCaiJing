//
//  HXRechargeAmountTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRechargedModel.h"

@interface HXRechargeAmountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@property (nonatomic, strong) HXRechargedModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
