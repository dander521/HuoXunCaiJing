//
//  HXCandyHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/3/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXCandyHeaderTableViewCell.h"

@implementation HXCandyHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rechargeButton.layer.cornerRadius = 15;
    self.rechargeButton.layer.masksToBounds = true;
    self.rechargeButton.layer.borderWidth = 1;
    self.rechargeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.exchangeButton.layer.cornerRadius = 15;
    self.exchangeButton.layer.masksToBounds = true;
    self.exchangeButton.layer.borderWidth = 1;
    self.exchangeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.detailBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:self.detailBgView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.detailBgView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.detailBgView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXCandyHeaderTableViewCell";
    HXCandyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchCandyDetailBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDetailButton)]) {
        [self.delegate selectDetailButton];
    }
}

- (IBAction)touchRechargeBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectRechargeButton)]) {
        [self.delegate selectRechargeButton];
    }
}
- (IBAction)touchExchangeBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectExchangeButton)]) {
        [self.delegate selectExchangeButton];
    }
}

@end
