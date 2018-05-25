//
//  HXDetailHeaderTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXNewsDetailModel.h"

@interface HXDetailHeaderTableViewCell : TXSeperateLineCell

@property (nonatomic, strong) HXNewsDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
