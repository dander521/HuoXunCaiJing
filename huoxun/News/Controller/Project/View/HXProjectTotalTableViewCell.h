//
//  HXProjectTotalTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/5.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXProjectTotalTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UILabel *projectAmount;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
