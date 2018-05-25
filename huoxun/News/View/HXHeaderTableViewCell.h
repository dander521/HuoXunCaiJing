//
//  HXHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBannerModel.h"

typedef NS_ENUM(NSInteger, HXHeaderType) {
    HXHeaderTypeHXNo,
    HXHeaderTypeProject,
    HXHeaderTypeHXJoin,
    HXHeaderTypeCreditExchange
};

@protocol HXHeaderTableViewCellDelegate <NSObject>

- (void)touchButtonItemWithType:(HXHeaderType)type;

- (void)didSelectCycleScrollViewItemWithModel:(HXBannerModel *)model;

@end

@interface HXHeaderTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <HXHeaderTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray <HXBannerModel *>*cycleData;

@end
