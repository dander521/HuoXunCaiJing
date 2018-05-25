//
//  HXRechargeHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeHeaderTableViewCell.h"

@implementation HXRechargeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addressButton.layer.cornerRadius = 4;
    self.addressButton.layer.masksToBounds = true;
    self.addressButton.layer.borderWidth = 1;
    self.addressButton.layer.borderColor = RGB(153, 153, 153).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXRechargedModel *)model {
    _model = model;
    
    self.orderNoLabel.text = model.create_time;
    self.numLabel.text = model.num;
    self.typeLabel.text = model.pay_type;
    self.addressLabel.text = model.wallet;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXRechargeHeaderTableViewCell";
    HXRechargeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
- (IBAction)touchAddressButton:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.wallet;
    [ShowMessage showMessage:@"复制成功"];
}

@end
