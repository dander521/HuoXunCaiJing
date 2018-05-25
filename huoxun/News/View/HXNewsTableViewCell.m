//
//  HXNewsTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXNewsTableViewCell.h"

@interface HXNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fireLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@end

@implementation HXNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.newsImageView.layer.cornerRadius = 5;
    self.newsImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXNewsModel *)model {
    _model = model;
    
    self.nameLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:model.title lineSpace:4 kern:0];
    self.timeLabel.text = model.create_time_format;
    self.fireLabel.text = model.view;
    if (![NSString isTextEmpty:model.img]) {
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"photo"]];
    } else {
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"photo"]];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXNewsTableViewCell";
    HXNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
