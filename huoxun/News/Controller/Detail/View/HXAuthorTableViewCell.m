//
//  HXAuthorTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXAuthorTableViewCell.h"

@interface HXAuthorTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end

@implementation HXAuthorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImg.layer.cornerRadius = 15;
    self.avatarImg.layer.masksToBounds = true;
    self.attentionBtn.layer.cornerRadius = 15;
    self.attentionBtn.layer.masksToBounds = true;
    self.attentionBtn.layer.borderWidth = 1;
    self.attentionBtn.layer.borderColor = RGB(230, 33, 42).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModle:(HXAuthorModel *)modle {
    _modle = modle;
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:modle.avatar] placeholderImage:[UIImage imageNamed:@"none_av"]];
    self.authorLabel.text = modle.nickname;
    NSString *attStr = [modle.isatt isEqualToString:@"0"] ? @"关注" : @"取消关注";
    [self.attentionBtn setTitle:attStr forState:UIControlStateNormal];
    if ([modle.isatt isEqualToString:@"0"]) {
        [self.attentionBtn setTitleColor:RGB(230, 33, 42) forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = RGB(230, 33, 42).CGColor;
    } else {
        [self.attentionBtn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = RGB(136, 136, 136).CGColor;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXAuthorTableViewCell";
    HXAuthorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchAttentionButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAttentionWithModel:)]) {
        [self.delegate selectAttentionWithModel:self.modle];
    }
}

@end
