//
//  HXApplyCategoryTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXVerifyTypeModel.h"

@interface HXApplyCategoryTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) HXVerifyTypeModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
