//
//  HXAuthorHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAuthorHeaderTableViewCell.h"

@interface HXAuthorHeaderTableViewCell ()

@end

@implementation HXAuthorHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 40;
    self.avatarImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXAuthorModel *)model {
    _model = model;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"none_av"]];
    self.nameLabel.text = model.name;
    self.attentionLabel.text = model.att_num;
    self.articleLabel.text = model.article_num;
    self.funsLabel.text = model.fans_num;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXAuthorHeaderTableViewCell";
    HXAuthorHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchArticleButton:(id)sender {
    [self.delegate selectArticleButton];
}

- (IBAction)touchAttentionButton:(id)sender {
    [self.delegate selectAttentionButton];
}

- (IBAction)touchFansButton:(id)sender {
    [self.delegate selectFansButton];
}


@end
