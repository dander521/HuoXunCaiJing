//
//  HXKeyWordTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXKeyWordTableViewCell.h"

@interface HXKeyWordTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *viewLabel;

@end

@implementation HXKeyWordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HXNewsDetailModel *)model {
    _model = model;
    
    self.viewLabel.text = model.view;
    self.praiseLabel.text = model.praise_num;
    self.praiseImageView.image = [model.is_praise isEqualToString:@"0"] ? [UIImage imageNamed:@"zan_cur"] : [UIImage imageNamed:@"zan"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXKeyWordTableViewCell";
    HXKeyWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchPraiseButton:(id)sender {
    [self.delegate selectPraiseButtonWithModel:self.model];
}


@end
