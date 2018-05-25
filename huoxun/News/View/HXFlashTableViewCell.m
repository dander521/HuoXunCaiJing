//
//  HXFlashTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXFlashTableViewCell.h"
#import "TXScrollLabelView.h"

@interface HXFlashTableViewCell () <TXScrollLabelViewDelegate>

@property (nonatomic, strong) TXScrollLabelView *labelView;

@end

@implementation HXFlashTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFlashArray:(NSArray *)flashArray {
    _flashArray = flashArray;
    
    NSMutableArray *desArray = [NSMutableArray new];
    for (HXFlashModel *model in flashArray) {
        [desArray addObject:model.des];
    }
    
    self.labelView = [TXScrollLabelView scrollWithTextArray:desArray type:TXScrollLabelViewTypeFlipNoRepeat velocity:3 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];

    /** Step3: 设置代理进行回调 */
    self.labelView.scrollLabelViewDelegate = self;

    /** Step4: 布局(Required) */
    self.labelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);

    [self addSubview:self.labelView];

    //偏好(Optional), Preference,if you want.
    self.labelView.scrollTitleColor = RGB(46, 46, 46);
    self.labelView.font = FONT(12);
    self.labelView.scrollInset = UIEdgeInsetsMake(0, 15 , 0, 15);
    self.labelView.scrollSpace = 10;
    self.labelView.font = [UIFont systemFontOfSize:15];
    self.labelView.textAlignment = NSTextAlignmentLeft;
    self.labelView.backgroundColor = [UIColor whiteColor];
    self.labelView.layer.cornerRadius = 5;

    /** Step5: 开始滚动(Start scrolling!) */
    [self.labelView beginScrolling];
}

- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    HXFlashModel *model = self.flashArray[index];
    [self.delegate selectScrollViewWithModel:model];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXFlashTableViewCell";
    HXFlashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}



@end
