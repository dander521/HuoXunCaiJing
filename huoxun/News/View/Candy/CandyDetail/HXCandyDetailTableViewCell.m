//
//  HXCandyDetailTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/11.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyDetailTableViewCell.h"

@implementation HXCandyDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXCandyDetailModel *)model {
    _model = model;
    
    self.nameLabel.text = [model.from_type isEqualToString:@"1"] ? @"分享" : @"邀请注册";
    self.timeLabel.text = model.create_time;
    self.countLabel.text = [model.sign isEqualToString:@"1"] ? [NSString stringWithFormat:@"+%@", model.number] : [NSString stringWithFormat:@"-%@", model.number];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCandyDetailTableViewCell";
    HXCandyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
