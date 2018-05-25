//
//  HXCommentTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCommentTableViewCell.h"

@interface HXCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HXCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HXCommentModel *)model {
    _model = model;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"none_nav"]];
    self.userNameLabel.text = [NSString isTextEmpty:model.user.nickname] ? @"火讯用户" : model.user.nickname;
    self.timeLabel.text = model.add_time;
    self.contentLabel.text = model.content;
    
    self.praiseLabel.text = model.znum;
    self.praiseImageView.image = [model.is_praise isEqualToString:@"0"] ? [UIImage imageNamed:@"zan_cur"] : [UIImage imageNamed:@"zan"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCommentTableViewCell";
    HXCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}
- (IBAction)touchPraiseLabel:(id)sender {
    [self.delegate selectCommentPraiseButtonWithModel:self.model cell:self];
}

@end
