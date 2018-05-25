//
//  HXRechargeProcessTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/14.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXRechargeProcessTableViewCell.h"

@implementation HXRechargeProcessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(HXRechargeProcessCellType)cellType {
    _cellType = cellType;
    
    if (cellType == HXRechargeProcessCellTypeRed) {
        self.topLabel.hidden = true;
        self.monthLabel.textColor = RGB(229, 20, 4);
        self.timeLabel.textColor = RGB(229, 20, 4);
        self.statusLabel.textColor = RGB(229, 20, 4);
        
        self.statusImageView.image = [UIImage imageNamed:@"rechaging"];
        
    } else {
        self.topLabel.hidden = false;
        
        self.monthLabel.textColor = RGB(153, 153, 153);
        self.timeLabel.textColor = RGB(153, 153, 153);
        self.statusLabel.textColor = RGB(153, 153, 153);
        
        self.statusImageView.image = [UIImage imageNamed:@"rechaged"];
    }
}

- (void)setModel:(HXRechargedModel *)model {
    _model = model;
    
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXRechargeProcessTableViewCell";
    HXRechargeProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
