//
//  HXNewsTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNewsModel.h"

@interface HXNewsTableViewCell : TXSeperateLineCell

@property (nonatomic, strong) HXNewsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
