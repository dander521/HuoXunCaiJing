//
//  HXCandyRechargeBottomTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyRechargeBottomTableViewCell.h"

@implementation HXCandyRechargeBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addressButton.layer.cornerRadius = 4;
    self.addressButton.layer.masksToBounds = true;
    self.addressButton.layer.borderWidth = 1;
    self.addressButton.layer.borderColor = RGB(102, 102, 102).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCandyRechargeBottomTableViewCell";
    HXCandyRechargeBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchAddressButton:(id)sender {
    
}

@end
