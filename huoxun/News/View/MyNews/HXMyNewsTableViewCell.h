//
//  HXMyNewsTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/3/9.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMyNewsTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
