//
//  HXDetailHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXDetailHeaderTableViewCell.h"

@interface HXDetailHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation HXDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLabel.layer.cornerRadius = 9;
    self.typeLabel.layer.masksToBounds = true;
    self.typeLabel.layer.borderWidth = 1;
    self.typeLabel.layer.borderColor = RGB(189, 189, 189).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(HXNewsDetailModel *)model {
    _model = model;
    if ([NSString isTextEmpty:model.title]) {
        self.titleLabel.attributedText = [HXDetailHeaderTableViewCell getAttributedStringWithLineSpace:@"暂无标题" lineSpace:6 kern:0];
    } else {
        self.titleLabel.attributedText = [HXDetailHeaderTableViewCell getAttributedStringWithLineSpace:model.title lineSpace:6 kern:0];
    }
    
    self.typeLabel.text = [model.original isEqualToString:@"1"] ? @"原创" : @"转载";
    self.timeLabel.text = model.create_time_format;
    self.readLabel.text = model.user.nickname;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXDetailHeaderTableViewCell";
    HXDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

+ (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace; //设置行间距
    paragraphStyle.firstLineHeadIndent = 0.0;//设置第一行缩进
    UIFont *font = FONT(18);
    NSDictionary*attriDict =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
    
    return attributedString;
}

@end
