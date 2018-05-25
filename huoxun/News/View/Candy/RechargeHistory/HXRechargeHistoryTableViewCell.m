//
//  HXRechargeHistoryTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeHistoryTableViewCell.h"

@implementation HXRechargeHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addressButton.layer.cornerRadius = 4;
    self.addressButton.layer.masksToBounds = true;
    self.addressButton.layer.borderWidth = 1;
    self.addressButton.layer.borderColor = RGB(153, 153, 153).CGColor;
    
    self.statusButton.layer.cornerRadius = 4;
    self.statusButton.layer.masksToBounds = true;
    self.statusButton.layer.borderWidth = 1;
    self.statusButton.layer.borderColor = RGB(230, 33, 41).CGColor;
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXRechargeHistoryModel *)model {
    _model = model;
    
    self.timeLabel.text = model.create_time;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@", model.create_time];
    self.countLabel.text = [NSString stringWithFormat:@"数量：%@", model.num];
    self.addressLabel.text = [NSString stringWithFormat:@"钱包地址：%@", model.wallet];
    
    if ([model.status integerValue] == 0) {
        [self.statusButton setTitle:@"审核中" forState:UIControlStateNormal];
    } else {
        [self.statusButton setTitle:@"已通过" forState:UIControlStateNormal];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXRechargeHistoryTableViewCell";
    HXRechargeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
- (IBAction)touchAddressButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAddressButtonWithModel:)]) {
        [self.delegate selectAddressButtonWithModel:self.model];
    }
}

@end
