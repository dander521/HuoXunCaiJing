//
//  TXTopItemCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2018/1/3.
//  Copyright © 2018年 utouu. All rights reserved.
//

#import "TXTopItemCollectionViewCell.h"

@interface TXTopItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation TXTopItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(HXCategroyModel *)model {
    _model = model;
    
    self.tagLabel.text = model.title;
    self.lineLabel.hidden = !model.isSelected;
    self.tagLabel.textColor = model.isSelected ? RGB(230, 33, 42) : RGB(102, 102, 102);
}

@end
