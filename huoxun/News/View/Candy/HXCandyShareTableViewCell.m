//
//  HXCandyShareTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyShareTableViewCell.h"

@implementation HXCandyShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shareBtn.layer.cornerRadius = 15;
    self.shareBtn.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCandyShareTableViewCell";
    HXCandyShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchShareButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectShareWithTitle:)]) {
        [self.delegate selectShareWithTitle:self.shareBtn.titleLabel.text];
    }
}

@end
