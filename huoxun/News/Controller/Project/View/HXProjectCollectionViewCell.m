//
//  HXProjectCollectionViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXProjectCollectionViewCell.h"

@interface HXProjectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coinImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation HXProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shadowView.layer.shadowRadius = 5;
    
    self.shadowView.layer.cornerRadius = 5;
    self.shadowView.layer.masksToBounds = true;
    self.shadowView.layer.borderWidth = 1;
    self.shadowView.layer.borderColor = RGB(229, 229, 229).CGColor;
}

- (void)setModel:(HXProjectModel *)model {
    _model = model;
    
    [self.coinImg sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"photo"]];
    self.nameLabel.text = model.title;
    self.desLabel.attributedText = [TXCustomTools getAttributedStringWithLineSpace:model.des lineSpace:8 kern:0];
}

@end
