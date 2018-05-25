//
//  HXCandyRechargeTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRechargeRulesModel.h"

@protocol HXCandyRechargeTableViewCellDelegate <NSObject>

- (void)selectedItemWithModel:(HXRechargeRulesModel *)model;

@end

@interface HXCandyRechargeTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HXCandyRechargeTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (nonatomic, strong) HXRechargeRulesModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
