//
//  HXJoinTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/10.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXJoinModel.h"

@interface HXJoinTableViewCell : TXSeperateLineCell
@property (nonatomic, strong) HXJoinModel *joinModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
