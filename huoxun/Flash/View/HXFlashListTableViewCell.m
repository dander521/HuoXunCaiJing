//
//  HXFlashListTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashListTableViewCell.h"

@interface HXFlashListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HXFlashListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXFlashModel *)model {
    _model = model;
    
    self.timeLabel.text = model.create_time_format;
    
    NSString *str = nil;
    if ([model.type isEqualToString:@"fast"]) {
        self.shareButton.hidden = false;
        self.shareImageView.hidden = false;
        [self.iconImageView removeFromSuperview];
        [self.nameLabel removeFromSuperview];
        str = model.des;
    } else if ([model.type isEqualToString:@"weibo"]) {
        self.shareButton.hidden = true;
        self.shareImageView.hidden = true;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:[UIImage imageNamed:@"photo"]];
        self.nameLabel.text = model.user_name;
        str = model.des;
    } else {
        self.shareButton.hidden = true;
        self.shareImageView.hidden = true;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.user_avatar] placeholderImage:[UIImage imageNamed:@"photo"]];
        self.nameLabel.text = model.user_name;
        str = model.des;
    }
    if ([NSString isTextEmpty:str]) {
        
    } else {
        self.contentLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:str lineSpace:5 kern:0];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXFlashListTableViewCell";
    HXFlashListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchShareButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchShareContentButtonWithModel:)]) {
        [self.delegate touchShareContentButtonWithModel:self.model];
    }
}

@end
