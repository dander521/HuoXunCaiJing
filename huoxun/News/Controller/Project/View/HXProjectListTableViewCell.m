//
//  HXProjectListTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectListTableViewCell.h"

@interface HXProjectListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coinImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *whitePaperBtn;

@end

@implementation HXProjectListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkBtn.layer.cornerRadius = 12;
    self.checkBtn.layer.masksToBounds = true;
    
    self.whitePaperBtn.layer.cornerRadius = 12;
    self.whitePaperBtn.layer.masksToBounds = true;
    self.whitePaperBtn.layer.borderColor = RGB(187, 187, 187).CGColor;
    self.whitePaperBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXProjectModel *)model {
    _model = model;
    
    [self.coinImg sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"photo"]];
    self.nameLabel.text = model.title;
    self.shortLabel.text = model.symbol;
    self.desLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:model.des lineSpace:10 kern:0];
}

- (IBAction)touchCheckButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchCheckProjectWithModel:)]) {
        [self.delegate touchCheckProjectWithModel:self.model];
    }
}

- (IBAction)touchWhitePaperButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchWhitePaperProjectWithModel:)]) {
        [self.delegate touchWhitePaperProjectWithModel:self.model];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXProjectListTableViewCell";
    HXProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
