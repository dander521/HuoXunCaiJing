//
//  HXProjectHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXProjectModel.h"

@protocol HXProjectHeaderTableViewCellDelegate <NSObject>

- (void)selectItemViewWithModel:(HXProjectModel *)model;

@end

@interface HXProjectHeaderTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <HXProjectHeaderTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
