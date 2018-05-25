//
//  HXLongBottomTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/26.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXLongBottomTableViewCell.h"

@implementation HXLongBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXLongBottomTableViewCell";
    HXLongBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
