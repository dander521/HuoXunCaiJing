//
//  HXJoinTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXJoinTableViewCell.h"

@interface HXJoinTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;

@end

@implementation HXJoinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.coverImageView.layer.cornerRadius = 5;
    self.coverImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJoinModel:(HXJoinModel *)joinModel {
    _joinModel = joinModel;
    
    self.titleLabel.text = joinModel.title;
    self.timeLabel.text = joinModel.create_time_format;
    self.fromLabel.text = joinModel.name;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:joinModel.cover] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:joinModel.face] placeholderImage:[UIImage imageNamed:@"photo"]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXJoinTableViewCell";
    HXJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
