//
//  HXRechargeAmountTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeAmountTableViewCell.h"

@implementation HXRechargeAmountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXRechargedModel *)model {
    _model = model;
    
    self.typeLabel.text = model.pay_type;
    NSString *baseNum = nil;
    if ([model.rate containsString:@":"]) {
        baseNum = [model.rate componentsSeparatedByString:@":"].lastObject;
    } else if ([model.rate containsString:@"/"]) {
        baseNum = [model.rate componentsSeparatedByString:@"/"].lastObject;
    }
    
    self.amountLabel.text = [NSString stringWithFormat:@"%.5f", [model.num integerValue] / [baseNum floatValue]];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXRechargeAmountTableViewCell";
    HXRechargeAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
