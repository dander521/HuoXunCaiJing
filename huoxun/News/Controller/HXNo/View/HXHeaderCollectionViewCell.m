//
//  HXHeaderCollectionViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXHeaderCollectionViewCell.h"

@interface HXHeaderCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HXHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.layer.cornerRadius = 12.5;
    self.nameLabel.layer.masksToBounds = true;
}

- (void)setModel:(HXCategroyModel *)model {
    _model = model;
    
    self.nameLabel.text = model.title;
    self.nameLabel.backgroundColor = model.isSelected ? RGB(230, 33, 42) : RGB(255, 255, 255);
    self.nameLabel.textColor = model.isSelected ? RGB(255, 255, 255) : RGB(153, 153, 153);
    self.nameLabel.layer.borderWidth = 1;
    self.nameLabel.layer.borderColor = model.isSelected ? RGB(230, 33, 42).CGColor : RGB(153, 153, 153).CGColor;
}

@end
