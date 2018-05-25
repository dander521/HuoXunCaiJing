//
//  TXHotSearchCollectionViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/12/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXHotSearchCollectionViewCell.h"

@interface TXHotSearchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation TXHotSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.layer.cornerRadius = self.contentLabel.size.height/2;
    self.contentLabel.layer.masksToBounds = true;
    self.contentLabel.layer.borderWidth = 1;
    self.contentLabel.layer.borderColor = RGB(102, 102, 102).CGColor;
    
}

@end
