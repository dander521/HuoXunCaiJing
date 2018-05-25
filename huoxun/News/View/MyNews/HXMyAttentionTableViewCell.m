//
//  HXMyAttentionTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMyAttentionTableViewCell.h"

@implementation HXMyAttentionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellType:(HXMyAttentionTableViewCellType)cellType {
    _cellType = cellType;
    
    switch (cellType) {
        case HXMyAttentionTableViewCellTypeRecharge: {
            
        }
            break;
            
        case HXMyAttentionTableViewCellTypeReceiveCandy: {
            [self.orderNoLabel removeFromSuperview];
            [self.detailLabel removeFromSuperview];
        }
            break;
        
        case HXMyAttentionTableViewCellTypePraise: {
            [self.orderNoLabel removeFromSuperview];
            [self.countLabel removeFromSuperview];
            [self.detailLabel removeFromSuperview];
        }
            break;
            
        case HXMyAttentionTableViewCellTypeComment: {
            [self.orderNoLabel removeFromSuperview];
            [self.countLabel removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

- (void)setModel:(HXAttentionsModel *)model {
    _model = model;
    
    self.timeLabel.text = model.create_time;
    self.mainLabel.text = model.des;
    self.cellType = [model.type integerValue];
    
    switch (self.cellType) {
        case HXMyAttentionTableViewCellTypeRecharge: {
            self.mainLabel.text = model.des;
            self.orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@", model.recharge.create_time];;
            self.countLabel.text = [NSString stringWithFormat:@"数量：%@", model.recharge.num];
            self.detailLabel.text = [NSString stringWithFormat:@"钱包地址：%@", model.recharge.wallet];
        }
            break;
        case HXMyAttentionTableViewCellTypeReceiveCandy: {
            self.mainLabel.text = model.des;
            self.countLabel.text = [NSString stringWithFormat:@"数量：%@", model.recharge.uid_sugar];
//            self.detailLabel.text = [NSString stringWithFormat:@"详情：%@", model.model];
        }
            break;
            
        case HXMyAttentionTableViewCellTypePraise: {
            self.mainLabel.text = model.des;
        }
            break;
            
        case HXMyAttentionTableViewCellTypeComment: {
            self.mainLabel.text = model.des;
            self.detailLabel.text = [NSString stringWithFormat:@"评价详情：%@", model.recharge.content];
        }
            break;
        
            
        default:
            break;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXMyAttentionTableViewCell";
    HXMyAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
