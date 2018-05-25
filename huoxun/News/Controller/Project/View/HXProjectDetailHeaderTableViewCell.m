//
//  HXProjectDetailHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectDetailHeaderTableViewCell.h"

@interface HXProjectDetailHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weburlLabel;

@property (weak, nonatomic) IBOutlet UIButton *whitePaperBtn;

@property (weak, nonatomic) IBOutlet UILabel *iconPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;


@end

@implementation HXProjectDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.whitePaperBtn.layer.cornerRadius = 15;
    self.whitePaperBtn.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXProjectDetailModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"photo"]];
    self.nameLabel.text = model.title;
    self.shortNameLabel.text = model.symbol;
    self.weburlLabel.text = model.website;
    
    self.totalLabel.text = model.total;
    self.availableLabel.text = model.circulate;
    
    self.iconPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price.price_cny];
    self.changeLabel.text = [NSString stringWithFormat:@"%@%%", model.price.percent_change_24h];
    self.priceLabel.text = model.price.price_usd;
    self.dealLabel.text = model.price.bargain;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXProjectDetailHeaderTableViewCell";
    HXProjectDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchWhitePaperButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchProjectDetailWhitePaperWithPPTUrl:)]) {
        [self.delegate touchProjectDetailWhitePaperWithPPTUrl:self.model.ppt];
    }
}


@end
