//
//  HXHeaderTableViewCell.m
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import "HXHeaderTableViewCell.h"
#import "SDCycleScrollView.h"

@interface HXHeaderTableViewCell () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cycleScrollView;

@property (nonatomic, strong) SDCycleScrollView *banner;

@end

@implementation HXHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 205) delegate:nil placeholderImage:[UIImage imageNamed:@"user_bg"]];
    self.banner.autoScrollTimeInterval = 3;
    self.banner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.banner.delegate = self;
    [self.cycleScrollView addSubview:self.banner];
}

- (void)setCycleData:(NSArray<HXBannerModel *> *)cycleData {
    _cycleData = cycleData;
    
    NSMutableArray *titleArray = [NSMutableArray new];
    NSMutableArray *imageArray = [NSMutableArray new];
    
    for (HXBannerModel *model in cycleData) {
        [titleArray addObject:model.title];
        [imageArray addObject:model.img];
    }
    
    self.banner.imageURLStringsGroup = imageArray;
//    self.banner.titlesGroup = titleArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"HXHeaderTableViewCell";
    HXHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    }
    
    return cell;
}

- (IBAction)touchItemButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(touchButtonItemWithType:)]) {
        HXHeaderType type = -1;
        switch (tag) {
            case 100:
                type = HXHeaderTypeHXNo;
                break;
            case 101:
                type = HXHeaderTypeProject;
                break;
            case 102:
                type = HXHeaderTypeHXJoin;
                break;
            case 103:
                type = HXHeaderTypeCreditExchange;
                break;
            default:
                break;
        }
        [self.delegate touchButtonItemWithType:type];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didSelectCycleScrollViewItemWithModel:)]) {
        [self.delegate didSelectCycleScrollViewItemWithModel:self.cycleData[index]];
    }
}

@end
