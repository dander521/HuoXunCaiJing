//
//  HXAttentionTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/25.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAttentionModel.h"

@interface HXAttentionTableViewCell : TXSeperateLineCell

@property (nonatomic, strong) HXAttentionModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
