//
//  HXMyNoticeTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXMyNoticeTableViewCell.h"

@implementation HXMyNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(HXNotifyModel *)model {
    _model = model;
    
    self.timeLabel.text = model.create_time;
    self.noticeLabel.text = model.title;
    self.activityLabel.text = [NSString stringWithFormat:@"活动时间:%@", model.update_time];
    self.contentLabel.text = [NSString stringWithFormat:@"活动详情:%@", model.des];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXMyNoticeTableViewCell";
    HXMyNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
