//
//  HXApplyCategoryTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXApplyCategoryTableViewCell.h"

@implementation HXApplyCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXVerifyTypeModel *)model {
    _model = model;
    
    self.typeLabel.text = model.name;
    
    if ([model.idField isEqualToString:@"1"]) {
        self.iconImageView.image = [UIImage imageNamed:@"verified_1"];
    } else if ([model.idField isEqualToString:@"2"]) {
        self.iconImageView.image = [UIImage imageNamed:@"verified_2"];
    } else if ([model.idField isEqualToString:@"3"]) {
        self.iconImageView.image = [UIImage imageNamed:@"verified_3"];
    } else if ([model.idField isEqualToString:@"4"]) {
        self.iconImageView.image = [UIImage imageNamed:@"verified_4"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"verified_1"];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXApplyCategoryTableViewCell";
    HXApplyCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
