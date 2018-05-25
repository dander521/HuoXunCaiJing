//
//  HXInfoDesTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXInfoDesTableViewCell : TXSeperateLineCell
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
