//
//  HXCandyRechargeTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyRechargeTableViewCell.h"

@implementation HXCandyRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXRechargeRulesModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    self.percentLabel.text = [NSString stringWithFormat:@"实时价格：%@%@=%@HXT", model.divisor, model.name, model.sugar_num];
    NSString *imageName = [model.isSelected boolValue] ? @"radio_cur" : @"radio";
    [self.radioButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCandyRechargeTableViewCell";
    HXCandyRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
- (IBAction)touchRadioButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectedItemWithModel:)]) {
        [self.delegate selectedItemWithModel:self.model];
    }
}

@end
