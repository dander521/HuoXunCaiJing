//
//  HXApplyInputTableViewCell.h
//  huoxun
//
//  Created by 倩倩 on 2018/2/6.
//  Copyright © 2018年 zhuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXApplyInputTableViewCell : TXSeperateLineCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
