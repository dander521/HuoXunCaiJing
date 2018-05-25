//
//  HXFlashTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXFlashModel.h"

@protocol HXFlashTableViewCellDelegate <NSObject>

- (void)selectScrollViewWithModel:(HXFlashModel *)model;

@end

@interface HXFlashTableViewCell : TXSeperateLineCell

@property (nonatomic, weak) id <HXFlashTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *flashArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
