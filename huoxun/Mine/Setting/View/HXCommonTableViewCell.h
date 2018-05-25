//
//  HXCommonTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCommonTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
