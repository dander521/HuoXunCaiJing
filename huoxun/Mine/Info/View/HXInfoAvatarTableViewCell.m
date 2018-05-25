//
//  HXInfoAvatarTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXInfoAvatarTableViewCell.h"

@implementation HXInfoAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImg.layer.cornerRadius = 15;
    self.avatarImg.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXInfoAvatarTableViewCell";
    HXInfoAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchUploadButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchUploadUserAvatarButton)]) {
        [self.delegate touchUploadUserAvatarButton];
    }
}

@end
