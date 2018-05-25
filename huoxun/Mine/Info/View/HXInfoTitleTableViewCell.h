//
//  HXInfoTitleTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXInfoTitleTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
